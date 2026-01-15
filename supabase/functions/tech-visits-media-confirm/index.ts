// Edge Function: Confirm Media Upload
// Endpoint: POST /v1/tech/visits/:id/media/confirm
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

    // Parse request body
    const body = await req.json()
    const visitId = body.visit_id || body.visitId
    const filePath = body.file_path
    const fileType = body.file_type || 'image' // image, video, pdf

    if (!visitId) {
      throw new Error('Visit ID is required (provide in body as visit_id)')
    }

    if (!filePath) {
      throw new Error('file_path is required')
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

    // Validate file type
    const allowedTypes = ['image', 'video', 'pdf']
    if (!allowedTypes.includes(fileType)) {
      throw new Error(`Invalid file type: ${fileType}`)
    }

    // Verify file exists in storage
    const { data: fileData, error: fileError } = await supabase.storage
      .from('visits')
      .list(undefined, {
        search: filePath.split('/').pop(),
      })

    if (fileError) {
      throw new Error(`Failed to verify file: ${fileError.message}`)
    }

    // Create visit_media record
    const { data: mediaRecord, error: mediaError } = await supabase
      .from('visit_media')
      .insert({
        org_id: auth.orgId,
        visit_id: visitId,
        uploaded_by: auth.userId,
        file_path: filePath,
        file_type: fileType as 'image' | 'video' | 'pdf',
      })
      .select()
      .single()

    if (mediaError || !mediaRecord) {
      throw new Error(`Failed to create media record: ${mediaError?.message}`)
    }

    // Log audit entry
    await supabase.from('audit_logs').insert({
      org_id: auth.orgId,
      entity: 'visit_media',
      entity_id: mediaRecord.id,
      action: 'upload',
      performed_by: auth.userId,
      payload: {
        visit_id: visitId,
        file_path: filePath,
        file_type: fileType,
      },
    })

    return createSuccessResponse(mediaRecord, 201)
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
