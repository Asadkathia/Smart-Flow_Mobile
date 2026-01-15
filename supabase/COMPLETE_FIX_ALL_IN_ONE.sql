-- ============================================
-- COMPLETE FIX: All-in-One Solution
-- ============================================
-- 
-- This script fixes EVERYTHING needed for test@example.com to work:
-- 1. Creates user profile if missing
-- 2. Updates all data associations
-- 3. Verifies the fix
-- 
-- Run this ENTIRE script in Supabase SQL Editor
-- Dashboard → SQL Editor → New Query → Paste ALL → Run
-- ============================================

BEGIN;

-- ============================================
-- STEP 1: Get the auth user ID
-- ============================================
DO $$
DECLARE
    auth_user_id UUID;
    profile_exists BOOLEAN;
BEGIN
    -- Get the auth user ID for test@example.com
    SELECT id INTO auth_user_id
    FROM auth.users
    WHERE email = 'test@example.com';
    
    IF auth_user_id IS NULL THEN
        RAISE EXCEPTION 'Auth user test@example.com not found in auth.users. Please create the auth user first.';
    END IF;
    
    RAISE NOTICE 'Found auth user: % with ID: %', 'test@example.com', auth_user_id;
    
    -- Check if profile exists
    SELECT EXISTS(
        SELECT 1 FROM public.users WHERE id = auth_user_id
    ) INTO profile_exists;
    
    IF NOT profile_exists THEN
        RAISE NOTICE 'User profile MISSING - will be created';
    ELSE
        RAISE NOTICE 'User profile EXISTS - will be updated';
    END IF;
END $$;

-- ============================================
-- STEP 2: Create or Update User Profile
-- ============================================
INSERT INTO public.users (
    id,
    org_id,
    full_name,
    email,
    phone,
    role,
    status
) 
SELECT 
    u.id,
    '00000000-0000-0000-0000-000000000001'::uuid as org_id,
    'Test Technician' as full_name,
    u.email,
    '+1234567890' as phone,
    'technician'::user_role as role,
    'active'::user_status as status
FROM auth.users u
WHERE u.email = 'test@example.com'
ON CONFLICT (id) DO UPDATE SET
    org_id = EXCLUDED.org_id,
    full_name = EXCLUDED.full_name,
    email = EXCLUDED.email,
    phone = EXCLUDED.phone,
    role = EXCLUDED.role,
    status = EXCLUDED.status;

-- ============================================
-- STEP 3: Update Visits to Use Correct Technician
-- ============================================
UPDATE public.visits v
SET technician_id = (
    SELECT id FROM public.users WHERE email = 'test@example.com'
)
WHERE v.org_id = '00000000-0000-0000-0000-000000000001'::uuid
  AND (
      v.technician_id = '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid
      OR v.technician_id IS NULL
      OR v.technician_id NOT IN (SELECT id FROM public.users)
  );

-- ============================================
-- STEP 4: Update Inventory Items to Use Correct Creator
-- ============================================
UPDATE public.inventory_items i
SET created_by = (
    SELECT id FROM public.users WHERE email = 'test@example.com'
)
WHERE i.org_id = '00000000-0000-0000-0000-000000000001'::uuid
  AND (
      i.created_by = '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid
      OR i.created_by IS NULL
      OR i.created_by NOT IN (SELECT id FROM public.users)
  );

COMMIT;

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- 1. Verify user profile
SELECT 
    'USER PROFILE' as check,
    id,
    email,
    role::text,
    status::text,
    org_id
FROM public.users 
WHERE email = 'test@example.com';

-- Expected: 1 row with role='technician', status='active'

-- 2. Verify visits
SELECT 
    'VISITS' as check,
    COUNT(*) as total,
    COUNT(CASE WHEN scheduled_start >= CURRENT_DATE AND scheduled_start < CURRENT_DATE + INTERVAL '1 day' THEN 1 END) as today_count
FROM public.visits
WHERE technician_id = (SELECT id FROM public.users WHERE email = 'test@example.com');

-- Expected: total >= 2, today_count = 2

-- 3. Verify inventory
SELECT 
    'INVENTORY' as check,
    COUNT(*) as total,
    COUNT(CASE WHEN active = true THEN 1 END) as active_count
FROM public.inventory_items
WHERE org_id = '00000000-0000-0000-0000-000000000001'::uuid;

-- Expected: total = 3, active_count = 3

-- 4. Show today's visits in detail
SELECT 
    v.id,
    TO_CHAR(v.scheduled_start, 'YYYY-MM-DD HH24:MI') as scheduled_start,
    TO_CHAR(v.scheduled_end, 'YYYY-MM-DD HH24:MI') as scheduled_end,
    v.status::text,
    u.email as technician_email,
    j.job_number,
    c.name as customer_name
FROM public.visits v
LEFT JOIN public.users u ON v.technician_id = u.id
LEFT JOIN public.jobs j ON v.job_id = j.id
LEFT JOIN public.customers c ON j.customer_id = c.id
WHERE v.technician_id = (SELECT id FROM public.users WHERE email = 'test@example.com')
  AND v.scheduled_start >= CURRENT_DATE
  AND v.scheduled_start < CURRENT_DATE + INTERVAL '1 day'
ORDER BY v.scheduled_start;

-- Expected: 2 rows showing today's visits

-- 5. Show inventory items
SELECT 
    i.id,
    i.name,
    i.sku,
    i.sale_price,
    i.active,
    u.email as created_by_email
FROM public.inventory_items i
LEFT JOIN public.users u ON i.created_by = u.id
WHERE i.org_id = '00000000-0000-0000-0000-000000000001'::uuid
ORDER BY i.name;

-- Expected: 3 rows showing inventory items

-- ============================================
-- SUCCESS INDICATORS
-- ============================================
-- 
-- If all verification queries return expected results:
-- ✅ User profile exists and is active
-- ✅ 2 visits scheduled for today
-- ✅ 3 inventory items exist
-- 
-- Then the Edge Functions SHOULD work!
-- 
-- If they still return 401:
-- 1. Check Supabase Edge Function logs for exact error
-- 2. Verify Edge Functions are using latest code
-- 3. Try redeploying Edge Functions:
--    supabase functions deploy tech-visits-today
--    supabase functions deploy tech-chat-threads
--    supabase functions deploy tech-inventory-items
-- ============================================
