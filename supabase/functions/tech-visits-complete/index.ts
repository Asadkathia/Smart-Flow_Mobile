// Edge Function: Complete Visit
// Endpoint: POST /v1/tech/visits/:id/complete
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
    const signaturePath = body.signature_path || body.signature_url

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

    // Validate state transition (in_progress or paused → completed)
    if (visit.status !== 'in_progress' && visit.status !== 'paused') {
      throw new Error(`Cannot complete visit with status: ${visit.status}. Only in_progress or paused visits can be completed.`)
    }

    // Validate signature is provided (PRD requirement)
    if (!signaturePath) {
      throw new Error('Signature is required to complete a visit')
    }

    const now = new Date().toISOString()

    // Update visit status with optimistic locking
    const { data: updated, error: updateError } = await supabase
      .from('visits')
      .update({
        status: 'completed',
        actual_end: visit.actual_end || now,
        version: visit.version + 1,
        updated_at: now,
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
      throw new Error(`Failed to complete visit: ${updateError.message}`)
    }

    if (!updated) {
      throw new Error('Failed to complete visit')
    }

    // Create or update signature record
    if (signaturePath) {
      const { error: sigError } = await supabase
        .from('visit_signatures')
        .upsert({
          org_id: auth.orgId,
          visit_id: visitId,
          signed_by: auth.userId, // Will be replaced with customer name if available
          signature_path: signaturePath,
          signed_at: now,
        }, {
          onConflict: 'visit_id',
        })

      if (sigError) {
        // Log error but don't fail the visit completion
        console.error('Failed to save signature:', sigError)
      }
    }

    // Log audit entry
    await supabase.from('audit_logs').insert({
      org_id: auth.orgId,
      entity: 'visit',
      entity_id: visitId,
      action: 'complete',
      performed_by: auth.userId,
      payload: {
        previous_status: visit.status,
        new_status: 'completed',
        signature_path: signaturePath || null,
      },
    })

    return createSuccessResponse(updated)
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
