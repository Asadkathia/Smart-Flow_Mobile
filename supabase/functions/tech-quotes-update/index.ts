// Edge Function: Update Quote
// Endpoint: PUT /v1/tech/quotes/:id
// Channel: mobile_technician
// Role: technician

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { authGuard, createErrorResponse, createSuccessResponse } from '../_shared/auth_guard.ts'
import { getSupabaseClient } from '../_shared/db.ts'

serve(async (req) => {
  try {
    const auth = await authGuard(req, ['technician'], ['mobile_technician'])
    
    if (req.method !== 'PUT') {
      throw new Error('Method not allowed')
    }

    const body = await req.json()
    const quoteId = body.quote_id || body.quoteId
    const taxable = body.taxable
    const lineItems = body.line_items || body.lineItems

    if (!quoteId) {
      throw new Error('Quote ID is required')
    }

    const supabase = getSupabaseClient()

    // Get quote and verify ownership
    const { data: quote, error: quoteError } = await supabase
      .from('quotes')
      .select(`
        *,
        visit:visits!inner (
          id,
          technician_id
        )
      `)
      .eq('id', quoteId)
      .eq('visit.technician_id', auth.userId)
      .single()

    if (quoteError || !quote) {
      throw new Error('Quote not found or access denied')
    }

    // Validate quote status (only draft quotes can be updated)
    if (quote.status !== 'draft') {
      throw new Error(`Cannot update quote with status: ${quote.status}. Only draft quotes can be updated.`)
    }

    // Get billing settings for tax calculation
    const { data: billingSettings, error: billingError } = await supabase
      .from('billing_settings')
      .select('tax_rate')
      .eq('org_id', auth.orgId)
      .single()

    if (billingError || !billingSettings) {
      throw new Error('Billing settings not found')
    }

    // Update quote if taxable changed
    if (taxable !== undefined && taxable !== quote.taxable) {
      const { error: updateError } = await supabase
        .from('quotes')
        .update({
          taxable,
          version: quote.version + 1,
        })
        .eq('id', quoteId)
        .eq('version', quote.version)

      if (updateError) {
        if (updateError.code === 'PGRST116') {
          return createErrorResponse(
            new Error('Quote was modified by another user. Please refresh and try again.'),
            409
          )
        }
        throw new Error(`Failed to update quote: ${updateError.message}`)
      }
    }

    // Update line items if provided
    if (lineItems && Array.isArray(lineItems)) {
      // Delete existing line items (except service_call_fee which is locked)
      await supabase
        .from('line_items')
        .delete()
        .eq('quote_id', quoteId)
        .neq('type', 'service_call_fee')

      // Insert new line items
      for (const item of lineItems) {
        // Skip service_call_fee as it's auto-added and locked
        if (item.type === 'service_call_fee') continue

        await supabase.from('line_items').insert({
          org_id: auth.orgId,
          quote_id: quoteId,
          type: item.type,
          reference_id: item.reference_id || null,
          description: item.description,
          unit: item.unit,
          qty: item.qty,
          unit_price: item.unit_price,
          taxable: item.taxable !== undefined ? item.taxable : (taxable !== undefined ? taxable : quote.taxable),
        })
      }
    }

    // Recalculate totals
    const { data: allLineItems } = await supabase
      .from('line_items')
      .select('*')
      .eq('quote_id', quoteId)

    let subtotal = 0
    let discountTotal = 0
    let taxTotal = 0

    allLineItems?.forEach((item) => {
      const itemTotal = item.qty * item.unit_price
      if (item.type === 'discount') {
        discountTotal += itemTotal
      } else {
        subtotal += itemTotal
      }
    })

    // Calculate tax if taxable
    const finalTaxable = taxable !== undefined ? taxable : quote.taxable
    if (finalTaxable) {
      const taxableItems = allLineItems?.filter(
        (item) => item.taxable && item.type !== 'discount'
      ) || []
      
      const taxableSubtotal = taxableItems.reduce(
        (sum, item) => sum + (item.qty * item.unit_price),
        0
      )
      
      const discountRatio = subtotal > 0 ? discountTotal / subtotal : 0
      const taxableDiscount = taxableSubtotal * discountRatio
      
      taxTotal = (taxableSubtotal - taxableDiscount) * billingSettings.tax_rate
    }

    const grandTotal = subtotal - discountTotal + taxTotal

    // Update quote totals
    const { data: updatedQuote, error: finalUpdateError } = await supabase
      .from('quotes')
      .update({
        subtotal,
        discount_total: discountTotal,
        tax_total: taxTotal,
        grand_total: grandTotal,
        version: quote.version + 1,
      })
      .eq('id', quoteId)
      .select(`
        *,
        line_items:line_items(*)
      `)
      .single()

    if (finalUpdateError || !updatedQuote) {
      throw new Error(`Failed to update quote totals: ${finalUpdateError?.message}`)
    }

    // Log audit entry
    await supabase.from('audit_logs').insert({
      org_id: auth.orgId,
      entity: 'quote',
      entity_id: quoteId,
      action: 'update',
      performed_by: auth.userId,
      payload: {
        taxable_changed: taxable !== undefined,
        line_items_updated: lineItems ? lineItems.length : 0,
      },
    })

    return createSuccessResponse(updatedQuote)
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
