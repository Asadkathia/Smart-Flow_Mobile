// Edge Function: Get Chat Threads
// Endpoint: GET /v1/tech/chat/threads
// Channel: mobile_technician
// Role: technician

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { authGuard, createErrorResponse, createSuccessResponse } from '../_shared/auth_guard.ts'
import { getSupabaseClient } from '../_shared/db.ts'

serve(async (req) => {
  try {
    const auth = await authGuard(req, ['technician'], ['mobile_technician'])
    
    if (req.method !== 'GET') {
      throw new Error('Method not allowed')
    }

    const supabase = getSupabaseClient()

    // Get chat threads where user is a participant
    const { data: threads, error } = await supabase
      .from('chat_threads')
      .select(`
        *,
        participants:chat_participants!inner (
          user_id,
          role_in_chat,
          joined_at
        ),
        last_message:chat_messages (
          id,
          message_body,
          created_at
        )
      `)
      .eq('org_id', auth.orgId)
      .eq('participants.user_id', auth.userId)
      .order('updated_at', { ascending: false })

    if (error) throw error

    // Format response
    const formattedThreads = (threads || []).map((thread: any) => {
      const lastMessage = thread.last_message && thread.last_message.length > 0
        ? thread.last_message[0]
        : null

      return {
        ...thread,
        last_message: lastMessage,
        participants: thread.participants || [],
      }
    })

    return createSuccessResponse(formattedThreads)
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
