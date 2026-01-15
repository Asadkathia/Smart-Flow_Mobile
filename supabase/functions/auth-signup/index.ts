// Edge Function: User Signup (Development/Testing Only)
// Endpoint: POST /v1/auth-signup
// Channel: mobile_technician
// Role: technician (auto-assigned)
//
// NOTE: This is for development/testing. In production, users should be created
// by web admin via invitation system per PRD requirements.

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { createErrorResponse, createSuccessResponse } from '../_shared/auth_guard.ts'

serve(async (req) => {
  try {
    // Only allow POST
    if (req.method !== 'POST') {
      return createErrorResponse(
        new Error('Method not allowed'),
        405
      )
    }

    const {
      email,
      password,
      first_name,
      last_name,
      phone,
      channel,
      org_id
    } = await req.json()

    // Validate required fields
    if (!email || !password || !first_name || !last_name) {
      return createErrorResponse(
        new Error('Missing required fields: email, password, first_name, last_name'),
        400
      )
    }

    // Validate channel (PRD requirement - only mobile_technician allowed for signup)
    if (channel !== 'mobile_technician') {
      return createErrorResponse(
        new Error('Invalid channel. Only mobile_technician is allowed for signup.'),
        400
      )
    }

    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(email)) {
      return createErrorResponse(
        new Error('Invalid email format'),
        400
      )
    }

    // Validate password strength (minimum 8 characters)
    if (password.length < 8) {
      return createErrorResponse(
        new Error('Password must be at least 8 characters long'),
        400
      )
    }

    // Initialize Supabase admin client (using service role key)
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    
    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey)

    // Check if user already exists
    const { data: existingUser } = await supabaseAdmin.auth.admin.listUsers()
    const userExists = existingUser?.users?.some(u => u.email === email)
    
    if (userExists) {
      return createErrorResponse(
        new Error('User with this email already exists'),
        409
      )
    }

    // Use provided org_id or default to test organization
    const targetOrgId = org_id || '00000000-0000-0000-0000-000000000001'

    // Verify organization exists
    const { data: org, error: orgError } = await supabaseAdmin
      .from('organizations')
      .select('id')
      .eq('id', targetOrgId)
      .single()

    if (orgError || !org) {
      return createErrorResponse(
        new Error(`Organization not found: ${targetOrgId}`),
        404
      )
    }

    // Create auth user with auto-confirmed email (for testing)
    const { data: authData, error: authError } = await supabaseAdmin.auth.admin.createUser({
      email: email.toLowerCase().trim(),
      password: password,
      email_confirm: true, // Auto-confirm for testing
      user_metadata: {
        first_name,
        last_name,
        full_name: `${first_name} ${last_name}`.trim(),
      }
    })

    if (authError || !authData.user) {
      return createErrorResponse(
        new Error(`Failed to create auth user: ${authError?.message || 'Unknown error'}`),
        500
      )
    }

    // Create user profile in public.users table
    const fullName = `${first_name} ${last_name}`.trim()
    const { error: profileError } = await supabaseAdmin
      .from('users')
      .insert({
        id: authData.user.id,
        org_id: targetOrgId,
        full_name: fullName,
        email: email.toLowerCase().trim(),
        phone: phone || null,
        role: 'technician', // Auto-assign technician role for mobile signup
        status: 'active', // Auto-activate for testing
      })

    if (profileError) {
      // Cleanup: delete auth user if profile creation fails
      await supabaseAdmin.auth.admin.deleteUser(authData.user.id)
      
      return createErrorResponse(
        new Error(`Failed to create user profile: ${profileError.message}`),
        500
      )
    }

    return createSuccessResponse(
      {
        user_id: authData.user.id,
        email: authData.user.email,
        message: 'User created successfully. You can now login.',
      },
      201
    )
  } catch (error) {
    return createErrorResponse(error as Error)
  }
})
