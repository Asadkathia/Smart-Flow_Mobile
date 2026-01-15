// Edge Function: Get/Send Chat Messages
// Endpoint: GET/POST /v1/tech/chat/threads/:threadId/messages
// Channel: mobile_technician
// Role: technician

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { authGuard, createErrorResponse, createSuccessResponse } from '../_shared/auth_guard.ts'
import { getSupabaseClient } from '../_shared/db.ts'

serve(async (req) => {
  try {
    const auth = await authGuard(req, ['technician'], ['mobile_technician'])
    const supabase = getSupabaseClient()

    // Extract thread ID from URL path, query params, or body
    const url = new URL(req.url)
    const pathParts = url.pathname.split('/').filter(p => p)
    const threadIdIndex = pathParts.indexOf('threads') + 1
    let threadId = pathParts[threadIdIndex]
    
    // If not in path, check query parameters (for GET requests)
    if (!threadId) {
      threadId = url.searchParams.get('thread_id') || url.searchParams.get('threadId')
    }
    
    // If still not found, check request body (for POST requests)
    if (!threadId) {
      try {
        const body = await req.json().catch(() => ({}))
        threadId = body.thread_id || body.threadId
      } catch {
        // Body parsing failed, threadId remains undefined
      }
    }

    if (!threadId) {
      throw new Error('Thread ID is required')
    }

    // Verify user is a participant
    const { data: participant } = await supabase
      .from('chat_participants')
      .select('chat_id, org_id')
      .eq('chat_id', threadId)
      .eq('user_id', auth.userId)
      .single()

    if (!participant) {
      throw new Error('Access denied: Not a participant in this thread')
    }

    if (req.method === 'GET') {
      // Get messages for thread
      const { data: messages, error } = await supabase
        .from('chat_messages')
        .select('*')
        .eq('chat_id', threadId)
        .order('created_at', { ascending: true })

      if (error) throw error

      return createSuccessResponse(messages || [])
    }

    if (req.method === 'POST') {
      // Send message
      const body = await req.json()
      const messageBody = body.message_body || body.message || body.text

      if (!messageBody || messageBody.trim().length === 0) {
        throw new Error('Message body is required')
      }

      if (messageBody.length > 5000) {
        throw new Error('Message body must be 5000 characters or less')
      }

      const { data: message, error: createError } = await supabase
        .from('chat_messages')
        .insert({
          org_id: auth.orgId,
          chat_id: threadId,
          sender_id: auth.userId,
          message_body: messageBody,
        })
        .select()
        .single()

      if (createError || !message) {
        throw new Error(`Failed to send message: ${createError?.message}`)
      }

      // Update thread updated_at
      await supabase
        .from('chat_threads')
        .update({ updated_at: new Date().toISOString() })
        .eq('id', threadId)

      return createSuccessResponse(message, 201)
    }

    throw new Error('Method not allowed')
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
