// Edge Function: Get Today's Visits
// Endpoint: GET /v1/tech/visits/today
// Channel: mobile_technician
// Role: technician

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { authGuard, createErrorResponse, createSuccessResponse } from '../_shared/auth_guard.ts'
import { getSupabaseClient } from '../_shared/db.ts'

serve(async (req) => {
  const requestId = crypto.randomUUID();
  console.log(`[${requestId}] tech-visits-today: Request received`, { method: req.method, url: req.url });

  try {
    // Authenticate and authorize
    console.log(`[${requestId}] tech-visits-today: Calling authGuard...`);
    const auth = await authGuard(req, ['technician'], ['mobile_technician'])
    console.log(`[${requestId}] tech-visits-today: Auth successful`, { userId: auth.userId, orgId: auth.orgId });

    // Initialize Supabase client
    const supabase = getSupabaseClient()

    // Get today's date range (start of day to start of next day)
    const today = new Date()
    today.setHours(0, 0, 0, 0)
    const tomorrow = new Date(today)
    tomorrow.setDate(tomorrow.getDate() + 1)

    console.log(`[${requestId}] tech-visits-today: Querying visits`, {
      technicianId: auth.userId,
      from: today.toISOString(),
      to: tomorrow.toISOString()
    });

    // Fetch visits with related data
    const { data: visits, error } = await supabase
      .from('visits')
      .select(`
        *,
        job:jobs!inner (
          *,
          customer:customers!inner (
            *
          ),
          property:properties (
            *
          )
        )
      `)
      .eq('technician_id', auth.userId)
      .gte('scheduled_start', today.toISOString())
      .lt('scheduled_start', tomorrow.toISOString())
      .order('scheduled_start', { ascending: true })

    if (error) {
      console.error(`[${requestId}] tech-visits-today: Database error`, {
        message: error.message,
        code: error.code,
        details: error.details,
        hint: error.hint
      });
      throw new Error(`Database error: ${error.message}`)
    }

    console.log(`[${requestId}] tech-visits-today: Query successful`, { visitCount: visits?.length || 0 });
    return createSuccessResponse(visits || [])
  } catch (error) {
    console.error(`[${requestId}] tech-visits-today: Error occurred`, {
      error: error instanceof Error ? error.message : String(error),
      stack: error instanceof Error ? error.stack : undefined
    });
    return createErrorResponse(error as Error)
  }
})
