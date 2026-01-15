// Edge Function: Delete Quote
// Endpoint: DELETE /v1/tech/quotes/:id
// Channel: mobile_technician
// Role: technician

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { authGuard, createErrorResponse, createSuccessResponse } from '../_shared/auth_guard.ts'
import { getSupabaseClient } from '../_shared/db.ts'

serve(async (req) => {
  try {
    const auth = await authGuard(req, ['technician'], ['mobile_technician'])
    
    if (req.method !== 'DELETE') {
      throw new Error('Method not allowed')
    }

    // Extract quote ID from query params or body
    const url = new URL(req.url)
    const quoteId = url.searchParams.get('quote_id') || url.searchParams.get('id') || 
                    (await req.json().catch(() => ({}))).quote_id

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

    // Validate quote status (only draft quotes can be deleted)
    if (quote.status !== 'draft') {
      throw new Error(`Cannot delete quote with status: ${quote.status}. Only draft quotes can be deleted.`)
    }

    // Check if quote has been used to create an invoice
    const { data: invoice } = await supabase
      .from('invoices')
      .select('id')
      .eq('quote_id', quoteId)
      .limit(1)
      .single()

    if (invoice) {
      throw new Error('Cannot delete quote that has been used to create an invoice')
    }

    // Delete line items first (CASCADE should handle this, but explicit for clarity)
    await supabase
      .from('line_items')
      .delete()
      .eq('quote_id', quoteId)

    // Delete quote
    const { error: deleteError } = await supabase
      .from('quotes')
      .delete()
      .eq('id', quoteId)

    if (deleteError) {
      throw new Error(`Failed to delete quote: ${deleteError.message}`)
    }

    // Log audit entry
    await supabase.from('audit_logs').insert({
      org_id: auth.orgId,
      entity: 'quote',
      entity_id: quoteId,
      action: 'delete',
      performed_by: auth.userId,
      payload: {
        quote_number: quote.quote_number,
        visit_id: quote.visit_id,
      },
    })

    return createSuccessResponse({ 
      message: 'Quote deleted successfully',
      quote_id: quoteId 
    })
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
