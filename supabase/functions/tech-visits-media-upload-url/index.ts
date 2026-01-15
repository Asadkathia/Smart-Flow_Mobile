// Edge Function: Get Signed Upload URL for Visit Media
// Endpoint: POST /v1/tech/visits/:id/media/upload-url
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

    // Extract visit ID from request body
    const body = await req.json()
    const visitId = body.visit_id || body.visitId

    if (!visitId) {
      throw new Error('Visit ID is required (provide in body as visit_id)')
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

    // Parse request body
    const body = await req.json()
    const fileExtension = body.file_extension || 'jpg'
    const fileType = body.file_type || 'image' // image, video, pdf

    // Validate file type
    const allowedTypes = ['image', 'video', 'pdf']
    if (!allowedTypes.includes(fileType)) {
      throw new Error(`Invalid file type: ${fileType}. Allowed: ${allowedTypes.join(', ')}`)
    }

    // Generate unique filename
    const fileName = `${crypto.randomUUID()}.${fileExtension}`
    const filePath = `${visit.org_id}/visits/${visitId}/${fileName}`

    // Generate signed upload URL (valid for 1 hour)
    const { data: signedUrlData, error: signedUrlError } = await supabase.storage
      .from('visits')
      .createSignedUploadUrl(filePath, {
        upsert: false,
        expiresIn: 3600, // 1 hour
      })

    if (signedUrlError || !signedUrlData) {
      throw new Error(`Failed to generate signed URL: ${signedUrlError?.message}`)
    }

    return createSuccessResponse({
      upload_url: signedUrlData.signedUrl,
      file_path: filePath,
      expires_at: new Date(Date.now() + 3600 * 1000).toISOString(),
      file_type: fileType,
    })
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
