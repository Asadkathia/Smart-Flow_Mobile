// Edge Function: Start Visit
// Endpoint: POST /v1/tech/visits/:id/start
// Channel: mobile_technician
// Role: technician

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { authGuard, createErrorResponse, createSuccessResponse } from '../_shared/auth_guard.ts'
import { getSupabaseClient } from '../_shared/db.ts'

serve(async (req) => {
  try {
    const auth = await authGuard(req, ['technician'], ['mobile_technician'])
    
    // Extract visit ID from request body or query params
    let visitId: string | null = null
    
    if (req.method === 'POST') {
      const body = await req.json().catch(() => ({}))
      visitId = body.visit_id || body.visitId
    }
    
    // Fallback to query param
    if (!visitId) {
      const url = new URL(req.url)
      visitId = url.searchParams.get('visit_id') || url.searchParams.get('visitId')
    }

    if (!visitId) {
      throw new Error('Visit ID is required (provide in body as visit_id or query param)')
    }

    const supabase = getSupabaseClient()

    // Get visit and verify ownership
    const { data: visit, error: fetchError } = await supabase
      .from('visits')
      .select('*')
      .eq('id', visitId)
      .eq('technician_id', auth.userId)
      .single()

    if (fetchError || !visit) {
      throw new Error('Visit not found or access denied')
    }

    // Validate state transition (scheduled → in_progress or paused → in_progress)
    if (visit.status !== 'scheduled' && visit.status !== 'paused') {
      throw new Error(`Cannot start visit with status: ${visit.status}. Allowed statuses: scheduled, paused`)
    }

    // Update visit status with optimistic locking
    const { data: updated, error: updateError } = await supabase
      .from('visits')
      .update({
        status: 'in_progress',
        actual_start: visit.actual_start || new Date().toISOString(),
        version: visit.version + 1,
        updated_at: new Date().toISOString()
      })
      .eq('id', visitId)
      .eq('version', visit.version)  // Optimistic lock check
      .select()
      .single()

    if (updateError) {
      if (updateError.code === 'PGRST116') {
        // No rows updated (version mismatch)
        return createErrorResponse(
          new Error('Visit was modified by another user. Please refresh and try again.'),
          409
        )
      }
      throw new Error(`Update failed: ${updateError.message}`)
    }

    // Log audit entry
    await supabase.from('audit_logs').insert({
      org_id: auth.orgId,
      entity: 'visit',
      entity_id: visitId,
      action: 'start',
      performed_by: auth.userId,
      payload: { 
        previous_status: visit.status, 
        new_status: 'in_progress',
        visit_id: visitId
      }
    })

    return createSuccessResponse(updated)
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
