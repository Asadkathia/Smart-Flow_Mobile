// Edge Function: Get/Add Visit Notes
// Endpoint: GET/POST /v1/tech/visits/:id/notes
// Channel: mobile_technician
// Role: technician

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { authGuard, createErrorResponse, createSuccessResponse } from '../_shared/auth_guard.ts'
import { getSupabaseClient } from '../_shared/db.ts'

serve(async (req) => {
  try {
    const auth = await authGuard(req, ['technician'], ['mobile_technician'])
    const supabase = getSupabaseClient()

    const body = await req.method === 'POST' ? await req.json() : {}
    const visitId = body.visit_id || body.visitId

    if (!visitId) {
      throw new Error('Visit ID is required')
    }

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

    if (req.method === 'GET') {
      // Get notes for visit
      const { data: notes, error } = await supabase
        .from('notes')
        .select('*')
        .eq('visit_id', visitId)
        .order('created_at', { ascending: false })

      if (error) throw error

      return createSuccessResponse(notes || [])
    }

    if (req.method === 'POST') {
      // Add note to visit
      const { body: noteBody, is_internal = false } = body

      if (!noteBody || noteBody.trim().length === 0) {
        throw new Error('Note body is required')
      }

      const { data: note, error: createError } = await supabase
        .from('notes')
        .insert({
          org_id: auth.orgId,
          visit_id: visitId,
          author_id: auth.userId,
          body: noteBody,
          version: 1,
        })
        .select()
        .single()

      if (createError || !note) {
        throw new Error(`Failed to create note: ${createError?.message}`)
      }

      // Log audit entry
      await supabase.from('audit_logs').insert({
        org_id: auth.orgId,
        entity: 'note',
        entity_id: note.id,
        action: 'create',
        performed_by: auth.userId,
        payload: {
          visit_id: visitId,
          is_internal,
        },
      })

      return createSuccessResponse(note, 201)
    }

    throw new Error('Method not allowed')
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
