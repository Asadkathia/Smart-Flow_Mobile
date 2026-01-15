// Edge Function: Pause Visit
// Endpoint: POST /v1/tech/visits/:id/pause
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
    const visitId = body.visit_id || body.visitId
    const reason = body.reason || body.status_reason

    if (!visitId) {
      throw new Error('Visit ID is required')
    }

    const supabase = getSupabaseClient()

    // Get visit and verify ownership
    const { data: visit, error: visitError } = await supabase
      .from('visits')
      .select('*')
      .eq('id', visitId)
      .eq('technician_id', auth.userId)
      .single()

    if (visitError || !visit) {
      throw new Error('Visit not found or access denied')
    }

    // Validate state transition (in_progress → paused)
    if (visit.status !== 'in_progress') {
      throw new Error(`Cannot pause visit with status: ${visit.status}. Only in_progress visits can be paused.`)
    }

    // Update visit status with optimistic locking
    const { data: updated, error: updateError } = await supabase
      .from('visits')
      .update({
        status: 'paused',
        status_reason: reason || null,
        version: visit.version + 1,
        updated_at: new Date().toISOString(),
      })
      .eq('id', visitId)
      .eq('version', visit.version) // Optimistic lock check
      .select()
      .single()

    if (updateError) {
      if (updateError.code === 'PGRST116') {
        return createErrorResponse(
          new Error('Visit was modified by another user. Please refresh and try again.'),
          409
        )
      }
      throw new Error(`Failed to pause visit: ${updateError.message}`)
    }

    if (!updated) {
      throw new Error('Failed to pause visit')
    }

    // Log audit entry
    await supabase.from('audit_logs').insert({
      org_id: auth.orgId,
      entity: 'visit',
      entity_id: visitId,
      action: 'pause',
      performed_by: auth.userId,
      payload: {
        previous_status: 'in_progress',
        new_status: 'paused',
        reason: reason || null,
      },
    })

    return createSuccessResponse(updated)
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
