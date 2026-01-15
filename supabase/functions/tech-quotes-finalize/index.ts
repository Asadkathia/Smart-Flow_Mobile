// Edge Function: Finalize Quote
// Endpoint: POST /v1/tech/quotes/:id/finalize
// Channel: mobile_technician
// Role: technician

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { authGuard, createErrorResponse, createSuccessResponse } from '../_shared/auth_guard.ts'
import { getSupabaseClient } from '../_shared/db.ts'

serve(async (req) => {
  try {
    const auth = await authGuard(req, ['technician'], ['mobile_technician'])
    
    if (req.method !== 'POST') {
      throw new Error('Method not allowed')
    }

    // Extract quote ID from URL path
    const url = new URL(req.url)
    const pathParts = url.pathname.split('/').filter(p => p)
    const quoteIdIndex = pathParts.indexOf('quotes') + 1
    const quoteId = pathParts[quoteIdIndex]

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

    // Validate quote status
    if (quote.status !== 'draft') {
      throw new Error(`Cannot finalize quote with status: ${quote.status}. Only draft quotes can be finalized.`)
    }

    // Validate quote has at least one line item (service_call_fee counts)
    const { data: lineItems, error: itemsError } = await supabase
      .from('line_items')
      .select('*')
      .eq('quote_id', quoteId)

    if (itemsError) {
      throw new Error(`Failed to fetch line items: ${itemsError.message}`)
    }

    if (!lineItems || lineItems.length === 0) {
      throw new Error('Quote must have at least one line item before finalization')
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

    // Recalculate totals (in case they changed)
    let subtotal = 0
    let discountTotal = 0
    let taxTotal = 0

    lineItems.forEach((item) => {
      const itemTotal = item.qty * item.unit_price
      if (item.type === 'discount') {
        discountTotal += itemTotal
      } else {
        subtotal += itemTotal
      }
    })

    // Calculate tax if taxable
    if (quote.taxable) {
      const taxableItems = lineItems.filter(
        (item) => item.taxable && item.type !== 'discount'
      )
      
      const taxableSubtotal = taxableItems.reduce(
        (sum, item) => sum + (item.qty * item.unit_price),
        0
      )
      
      // Apply discount proportionally to taxable items
      const discountRatio = subtotal > 0 ? discountTotal / subtotal : 0
      const taxableDiscount = taxableSubtotal * discountRatio
      
      taxTotal = (taxableSubtotal - taxableDiscount) * billingSettings.tax_rate
    }

    const grandTotal = subtotal - discountTotal + taxTotal

    // Update quote status to finalized with optimistic locking
    const { data: updatedQuote, error: updateError } = await supabase
      .from('quotes')
      .update({
        status: 'finalized',
        subtotal,
        discount_total: discountTotal,
        tax_total: taxTotal,
        grand_total: grandTotal,
        locked_at: new Date().toISOString(),
        locked_by: auth.userId,
        version: quote.version + 1,
        updated_at: new Date().toISOString(),
      })
      .eq('id', quoteId)
      .eq('version', quote.version) // Optimistic lock check
      .select(`
        *,
        line_items:line_items(*)
      `)
      .single()

    if (updateError) {
      if (updateError.code === 'PGRST116') {
        // No rows updated (version mismatch)
        return createErrorResponse(
          new Error('Quote was modified by another user. Please refresh and try again.'),
          409
        )
      }
      throw new Error(`Failed to finalize quote: ${updateError.message}`)
    }

    if (!updatedQuote) {
      throw new Error('Failed to finalize quote')
    }

    // Log audit entry
    await supabase.from('audit_logs').insert({
      org_id: auth.orgId,
      entity: 'quote',
      entity_id: quoteId,
      action: 'finalize',
      performed_by: auth.userId,
      payload: {
        previous_status: 'draft',
        new_status: 'finalized',
        grand_total: grandTotal,
      },
    })

    return createSuccessResponse(updatedQuote)
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
