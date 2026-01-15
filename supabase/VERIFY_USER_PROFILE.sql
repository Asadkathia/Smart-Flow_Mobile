-- ============================================
-- VERIFY: User Profile Exists for test@example.com
-- ============================================
-- 
-- This query checks if the user profile exists correctly
-- Run in Supabase SQL Editor to diagnose the 401 error
-- ============================================

-- 1. Check auth.users table (Supabase Auth)
SELECT 
    id,
    email,
    created_at,
    last_sign_in_at,
    email_confirmed_at
FROM auth.users 
WHERE email = 'test@example.com';

-- Expected: Should return 1 row with ID 82cf187c-c444-434a-9a65-3018b1b3369d

-- 2. Check public.users table (User Profile)
SELECT 
    id,
    org_id,
    full_name,
    email,
    role,
    status,
    created_at,
    updated_at
FROM public.users 
WHERE email = 'test@example.com';

-- Expected: Should return 1 row with:
-- - ID: 82cf187c-c444-434a-9a65-3018b1b3369d
-- - org_id: 00000000-0000-0000-0000-000000000001
-- - role: technician
-- - status: active

-- 3. Check if IDs match between auth.users and public.users
SELECT 
    a.id as auth_id,
    a.email as auth_email,
    p.id as profile_id,
    p.email as profile_email,
    p.role,
    p.status,
    CASE 
        WHEN a.id = p.id THEN '✅ IDs MATCH'
        ELSE '❌ IDs DO NOT MATCH'
    END as id_match_status
FROM auth.users a
LEFT JOIN public.users p ON a.id = p.id
WHERE a.email = 'test@example.com';

-- Expected: Should show ✅ IDs MATCH

-- 4. Count visits for this technician
SELECT 
    COUNT(*) as total_visits,
    COUNT(CASE WHEN scheduled_start >= CURRENT_DATE AND scheduled_start < CURRENT_DATE + INTERVAL '1 day' THEN 1 END) as visits_today
FROM public.visits
WHERE technician_id = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid;

-- Expected: total_visits >= 2, visits_today = 2

-- 5. Show all visits for this technician
SELECT 
    v.id,
    v.scheduled_start,
    v.scheduled_end,
    v.status,
    v.technician_id,
    j.job_number,
    c.name as customer_name
FROM public.visits v
LEFT JOIN public.jobs j ON v.job_id = j.id
LEFT JOIN public.customers c ON j.customer_id = c.id
WHERE v.technician_id = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
ORDER BY v.scheduled_start;

-- Expected: Should show 2 visits

-- 6. Check inventory items
SELECT 
    id,
    name,
    sku,
    sale_price,
    created_by,
    active
FROM public.inventory_items
WHERE org_id = '00000000-0000-0000-0000-000000000001'::uuid
ORDER BY name;

-- Expected: Should show 3 items

-- ============================================
-- DIAGNOSIS
-- ============================================
-- 
-- If query #2 returns 0 rows:
--   → User profile is MISSING - run FIX_DATA_ASSOCIATIONS.sql again
-- 
-- If query #3 shows "IDs DO NOT MATCH":
--   → Auth user and profile user have different IDs - serious issue
-- 
-- If query #4 shows visits_today = 0:
--   → Visits aren't associated with correct technician - run FIX_DATA_ASSOCIATIONS.sql
-- 
-- If all queries return correct results:
--   → Edge Functions may not be using correct auth logic
--   → Check Supabase Edge Function logs
-- ============================================
