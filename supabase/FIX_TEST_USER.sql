-- ============================================
-- FIX: Add User Profile for test@example.com
-- ============================================
-- 
-- PROBLEM: The auth user test@example.com exists in auth.users but has no profile in public.users
-- SOLUTION: Create the user profile and update related data
-- 
-- Run this in Supabase SQL Editor:
-- Dashboard → SQL Editor → New Query → Paste this → Run
-- ============================================

-- 1. Verify the auth user exists
SELECT 
    id, 
    email, 
    created_at,
    last_sign_in_at
FROM auth.users 
WHERE email = 'test@example.com';

-- 2. Check if user profile already exists (should return 0 rows initially)
SELECT * FROM public.users WHERE email = 'test@example.com';

-- 3. Insert user profile for test@example.com
INSERT INTO public.users (
    id,
    org_id,
    full_name,
    email,
    phone,
    role,
    status
) VALUES (
    '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid,  -- Must match auth.users.id
    '00000000-0000-0000-0000-000000000001'::uuid,  -- Test organization ID
    'Test Technician',
    'test@example.com',
    '+1234567890',
    'technician',
    'active'
) ON CONFLICT (id) DO UPDATE SET
    org_id = EXCLUDED.org_id,
    full_name = EXCLUDED.full_name,
    email = EXCLUDED.email,
    phone = EXCLUDED.phone,
    role = EXCLUDED.role,
    status = EXCLUDED.status;

-- 4. Update existing test data to use the correct user ID
-- Update visits
UPDATE public.visits 
SET technician_id = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
WHERE technician_id = '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid;

-- Update inventory items
UPDATE public.inventory_items
SET created_by = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
WHERE created_by = '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid;

-- 5. Verify the fix
SELECT 
    u.id,
    u.email,
    u.role,
    u.status,
    u.org_id,
    o.name as org_name
FROM public.users u
LEFT JOIN public.organizations o ON u.org_id = o.id
WHERE u.email = 'test@example.com';

-- 6. Verify visits are assigned to the correct technician
SELECT 
    id,
    scheduled_start,
    status,
    technician_id
FROM public.visits 
WHERE technician_id = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
ORDER BY scheduled_start;

-- ============================================
-- DONE!
-- ============================================
-- The edge functions should now work correctly for test@example.com
-- Test the fix by:
-- 1. Login to the app with test@example.com
-- 2. Navigate to home screen
-- 3. Verify visits load successfully
-- ============================================
