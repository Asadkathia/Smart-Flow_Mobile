// Shared Authentication & Authorization Guard
// Validates JWT tokens and enforces role + channel access

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

export interface AuthContext {
  userId: string
  orgId: string
  role: 'admin' | 'dispatcher' | 'accountant' | 'technician'
  channel: 'web_admin' | 'mobile_technician'
}

export async function authGuard(
  req: Request,
  allowedRoles: string[],
  allowedChannels: string[]
): Promise<AuthContext> {
  const requestId = crypto.randomUUID();
  console.log(`[${requestId}] authGuard: Starting authentication`);
  
  // Extract JWT from Authorization header
  const authHeader = req.headers.get('Authorization')
  console.log(`[${requestId}] authGuard: Auth header present: ${!!authHeader}`);
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    console.error(`[${requestId}] authGuard: Missing/invalid Authorization header`);
    throw new Error('Missing or invalid Authorization header')
  }

  const token = authHeader.replace('Bearer ', '')
  console.log(`[${requestId}] authGuard: Token extracted (length: ${token.length})`);
  
  // Initialize Supabase client with service role key
  const supabaseUrl = Deno.env.get('SUPABASE_URL')!
  const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  
  if (!supabaseUrl || !supabaseServiceKey) {
    console.error(`[${requestId}] authGuard: Missing env vars`);
    throw new Error('Server configuration error')
  }
  
  const supabase = createClient(supabaseUrl, supabaseServiceKey)
  
  // Verify JWT with Supabase Auth
  console.log(`[${requestId}] authGuard: Verifying JWT...`);
  const { data: { user }, error: authError } = await supabase.auth.getUser(token)
  
  if (authError || !user) {
    console.error(`[${requestId}] authGuard: JWT verification failed`, {
      error: authError?.message,
      code: authError?.status,
      hasUser: !!user
    });
    throw new Error(`Invalid or expired token: ${authError?.message || 'No user'}`)
  }

  console.log(`[${requestId}] authGuard: JWT verified`, { userId: user.id, email: user.email });

  // Get user profile from database
  console.log(`[${requestId}] authGuard: Fetching profile for user ${user.id}...`);
  const { data: profile, error: profileError } = await supabase
    .from('users')
    .select('org_id, role, status')
    .eq('id', user.id)
    .single()

  if (profileError) {
    console.error(`[${requestId}] authGuard: Profile lookup failed`, {
      error: profileError.message,
      code: profileError.code,
      details: profileError.details,
      hint: profileError.hint
    });
    throw new Error(`User profile not found: ${profileError.message}`)
  }

  if (!profile) {
    console.error(`[${requestId}] authGuard: Profile is null for user ${user.id}`);
    throw new Error('User profile not found')
  }

  console.log(`[${requestId}] authGuard: Profile found`, {
    orgId: profile.org_id,
    role: profile.role,
    status: profile.status
  });

  if (profile.status !== 'active') {
    console.error(`[${requestId}] authGuard: User not active (status: ${profile.status})`);
    throw new Error('User account is not active')
  }

  // Check role permission
  if (!allowedRoles.includes(profile.role)) {
    console.error(`[${requestId}] authGuard: Role check failed`, {
      userRole: profile.role,
      allowedRoles
    });
    throw new Error(`Insufficient permissions. Required roles: ${allowedRoles.join(', ')}`)
  }

  // Check channel (from X-Channel header or infer from role)
  const channelHeader = req.headers.get('X-Channel')
  let channel: 'web_admin' | 'mobile_technician'
  
  if (channelHeader) {
    channel = channelHeader as 'web_admin' | 'mobile_technician'
  } else {
    // Infer channel from role (technician = mobile, others = web_admin)
    channel = profile.role === 'technician' ? 'mobile_technician' : 'web_admin'
  }
  
  console.log(`[${requestId}] authGuard: Channel determined`, { channelHeader, channel });
  
  if (!allowedChannels.includes(channel)) {
    console.error(`[${requestId}] authGuard: Channel check failed`, { channel, allowedChannels });
    throw new Error(`Invalid channel for this endpoint. Required channels: ${allowedChannels.join(', ')}`)
  }

  // Validate role-channel compatibility
  if (profile.role === 'technician' && channel !== 'mobile_technician') {
    console.error(`[${requestId}] authGuard: Role-channel mismatch`);
    throw new Error('Technicians can only access mobile_technician channel')
  }
  
  if (profile.role !== 'technician' && channel !== 'web_admin') {
    console.error(`[${requestId}] authGuard: Role-channel mismatch`);
    throw new Error('Non-technician roles can only access web_admin channel')
  }

  console.log(`[${requestId}] authGuard: Authentication successful`, {
    userId: user.id,
    orgId: profile.org_id,
    role: profile.role,
    channel
  });

  return {
    userId: user.id,
    orgId: profile.org_id,
    role: profile.role,
    channel: channel
  }
}

// Helper to create error response
export function createErrorResponse(
  error: Error,
  statusCode: number = 500
): Response {
  const isAuthError = error.message.includes('token') || 
                      error.message.includes('permission') ||
                      error.message.includes('channel') ||
                      error.message.includes('active')
  
  const code = isAuthError 
    ? (error.message.includes('token') ? 'UNAUTHORIZED' : 'FORBIDDEN')
    : 'INTERNAL_ERROR'
  
  return new Response(
    JSON.stringify({
      error: {
        code,
        message: error.message
      },
      meta: {
        request_id: crypto.randomUUID(),
        ts: new Date().toISOString()
      }
    }),
    {
      status: isAuthError ? (code === 'UNAUTHORIZED' ? 401 : 403) : statusCode,
      headers: { 'Content-Type': 'application/json' }
    }
  )
}

// Helper to create success response
export function createSuccessResponse(
  data: any,
  statusCode: number = 200
): Response {
  return new Response(
    JSON.stringify({
      data,
      meta: {
        request_id: crypto.randomUUID(),
        ts: new Date().toISOString()
      }
    }),
    {
      status: statusCode,
      headers: { 'Content-Type': 'application/json' }
    }
  )
}
