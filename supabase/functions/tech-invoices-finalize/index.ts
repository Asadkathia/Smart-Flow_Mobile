// Edge Function: Finalize Invoice
// Endpoint: POST /v1/tech/invoices/:id/finalize
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
    const invoiceId = body.invoice_id || body.invoiceId

    if (!invoiceId) {
      throw new Error('Invoice ID is required')
    }

    const supabase = getSupabaseClient()

    // Get invoice and verify ownership
    const { data: invoice, error: invoiceError } = await supabase
      .from('invoices')
      .select(`
        *,
        visit:visits!inner (
          id,
          technician_id
        )
      `)
      .eq('id', invoiceId)
      .eq('visit.technician_id', auth.userId)
      .single()

    if (invoiceError || !invoice) {
      throw new Error('Invoice not found or access denied')
    }

    // Validate invoice status (must be draft)
    if (invoice.status !== 'draft') {
      throw new Error(`Cannot finalize invoice with status: ${invoice.status}. Only draft invoices can be finalized.`)
    }

    // Update invoice status with optimistic locking
    const { data: updated, error: updateError } = await supabase
      .from('invoices')
      .update({
        status: 'unpaid',
        version: invoice.version + 1,
        updated_at: new Date().toISOString(),
      })
      .eq('id', invoiceId)
      .eq('version', invoice.version) // Optimistic lock check
      .select()
      .single()

    if (updateError) {
      if (updateError.code === 'PGRST116') {
        return createErrorResponse(
          new Error('Invoice was modified by another user. Please refresh and try again.'),
          409
        )
      }
      throw new Error(`Failed to finalize invoice: ${updateError.message}`)
    }

    if (!updated) {
      throw new Error('Failed to finalize invoice')
    }

    // Log audit entry
    await supabase.from('audit_logs').insert({
      org_id: auth.orgId,
      entity: 'invoice',
      entity_id: invoiceId,
      action: 'finalize',
      performed_by: auth.userId,
      payload: {
        previous_status: 'draft',
        new_status: 'unpaid',
        invoice_number: invoice.invoice_number,
      },
    })

    return createSuccessResponse(updated)
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
