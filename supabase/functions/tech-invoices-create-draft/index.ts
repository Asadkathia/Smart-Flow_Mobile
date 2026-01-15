// Edge Function: Create Invoice Draft from Quote
// Endpoint: POST /v1/tech/quotes/:quoteId/create-invoice-draft
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

    const body = await req.json()
    const quoteId = body.quote_id || body.quoteId

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

    // Validate quote status (must be finalized)
    if (quote.status !== 'finalized') {
      throw new Error(`Cannot create invoice from quote with status: ${quote.status}. Quote must be finalized.`)
    }

    // Check if invoice already exists for this quote
    const { data: existingInvoice } = await supabase
      .from('invoices')
      .select('id, status')
      .eq('quote_id', quoteId)
      .limit(1)
      .single()

    if (existingInvoice) {
      throw new Error(`Invoice already exists for this quote (ID: ${existingInvoice.id})`)
    }

    // Generate invoice number
    const { data: invoiceNumberData, error: invoiceNumberError } = await supabase
      .rpc('generate_invoice_number', { p_org_id: auth.orgId })

    if (invoiceNumberError || !invoiceNumberData) {
      throw new Error(`Failed to generate invoice number: ${invoiceNumberError?.message}`)
    }

    const invoiceNumber = invoiceNumberData as string

    // Create invoice draft
    const { data: invoice, error: invoiceError } = await supabase
      .from('invoices')
      .insert({
        org_id: auth.orgId,
        visit_id: quote.visit_id,
        quote_id: quoteId,
        invoice_number: invoiceNumber,
        status: 'draft',
        total: quote.grand_total,
        version: 1,
      })
      .select()
      .single()

    if (invoiceError || !invoice) {
      throw new Error(`Failed to create invoice: ${invoiceError?.message}`)
    }

    // Update quote status to invoiced
    const { error: quoteUpdateError } = await supabase
      .from('quotes')
      .update({
        status: 'invoiced',
        version: quote.version + 1,
      })
      .eq('id', quoteId)
      .eq('version', quote.version)

    if (quoteUpdateError) {
      // Log error but don't fail invoice creation
      console.error('Failed to update quote status:', quoteUpdateError)
    }

    // Log audit entry
    await supabase.from('audit_logs').insert({
      org_id: auth.orgId,
      entity: 'invoice',
      entity_id: invoice.id,
      action: 'create',
      performed_by: auth.userId,
      payload: {
        quote_id: quoteId,
        invoice_number: invoiceNumber,
        total: quote.grand_total,
      },
    })

    return createSuccessResponse(invoice, 201)
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
