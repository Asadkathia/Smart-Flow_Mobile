// Edge Function: Create Draft Quote
// Endpoint: POST /v1/tech/visits/:visitId/quotes
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

    // Extract visit ID from URL path
    const url = new URL(req.url)
    const pathParts = url.pathname.split('/').filter(p => p)
    const visitIdIndex = pathParts.indexOf('visits') + 1
    const visitId = pathParts[visitIdIndex]

    if (!visitId) {
      throw new Error('Visit ID is required')
    }

    const supabase = getSupabaseClient()

    // Verify visit ownership
    const { data: visit, error: visitError } = await supabase
      .from('visits')
      .select('id, org_id, technician_id')
      .eq('id', visitId)
      .eq('technician_id', auth.userId)
      .single()

    if (visitError || !visit) {
      throw new Error('Visit not found or access denied')
    }

    // Get billing settings for org
    const { data: billingSettings, error: billingError } = await supabase
      .from('billing_settings')
      .select('service_call_fee, tax_rate')
      .eq('org_id', auth.orgId)
      .single()

    if (billingError || !billingSettings) {
      throw new Error('Billing settings not found for organization')
    }

    // Generate quote number using database function
    const { data: quoteNumberData, error: quoteNumberError } = await supabase
      .rpc('generate_quote_number', { p_org_id: auth.orgId })

    if (quoteNumberError || !quoteNumberData) {
      throw new Error(`Failed to generate quote number: ${quoteNumberError?.message}`)
    }

    const quoteNumber = quoteNumberData as string

    // Parse request body
    const body = await req.json()
    const taxable = body.taxable !== undefined ? body.taxable : true

    // Create quote
    const { data: quote, error: quoteError } = await supabase
      .from('quotes')
      .insert({
        org_id: auth.orgId,
        visit_id: visitId,
        quote_number: quoteNumber,
        status: 'draft',
        taxable: taxable,
        subtotal: 0,
        discount_total: 0,
        tax_total: 0,
        grand_total: 0,
        version: 1,
      })
      .select()
      .single()

    if (quoteError || !quote) {
      throw new Error(`Failed to create quote: ${quoteError?.message}`)
    }

    // Auto-add service call fee line item (locked, non-deletable)
    const { data: serviceCallFee, error: feeError } = await supabase
      .from('line_items')
      .insert({
        org_id: auth.orgId,
        quote_id: quote.id,
        type: 'service_call_fee',
        description: 'Service Call Fee',
        unit: 'each',
        qty: 1,
        unit_price: billingSettings.service_call_fee,
        taxable: taxable, // Taxable if quote is taxable
        version: 1,
      })
      .select()
      .single()

    if (feeError || !serviceCallFee) {
      // Rollback quote creation
      await supabase.from('quotes').delete().eq('id', quote.id)
      throw new Error(`Failed to add service call fee: ${feeError?.message}`)
    }

    // Recalculate totals
    const { data: lineItems } = await supabase
      .from('line_items')
      .select('*')
      .eq('quote_id', quote.id)

    let subtotal = 0
    let discountTotal = 0
    let taxTotal = 0

    lineItems?.forEach((item) => {
      const itemTotal = item.qty * item.unit_price
      if (item.type === 'discount') {
        discountTotal += itemTotal
      } else {
        subtotal += itemTotal
      }
    })

    // Calculate tax if taxable
    if (taxable) {
      const taxableItems = lineItems?.filter(
        (item) => item.taxable && item.type !== 'discount'
      ) || []
      
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

    // Update quote with calculated totals
    const { data: updatedQuote, error: updateError } = await supabase
      .from('quotes')
      .update({
        subtotal,
        discount_total: discountTotal,
        tax_total: taxTotal,
        grand_total: grandTotal,
      })
      .eq('id', quote.id)
      .select(`
        *,
        line_items:line_items(*)
      `)
      .single()

    if (updateError || !updatedQuote) {
      throw new Error(`Failed to update quote totals: ${updateError?.message}`)
    }

    // Log audit entry
    await supabase.from('audit_logs').insert({
      org_id: auth.orgId,
      entity: 'quote',
      entity_id: quote.id,
      action: 'create',
      performed_by: auth.userId,
      payload: {
        visit_id: visitId,
        quote_number: quoteNumber,
      },
    })

    return createSuccessResponse(updatedQuote, 201)
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
