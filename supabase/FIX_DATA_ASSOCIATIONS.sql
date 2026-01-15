-- ============================================
-- FIX: Update All Test Data to Use Correct User ID
-- ============================================
-- 
-- PROBLEM: Test data (visits, inventory) is associated with wrong user ID
-- OLD USER ID: 13f79aef-96b3-4295-9fee-262ec6bc35c3 (test.technician@example.com)
-- CORRECT USER ID: 82cf187c-c444-434a-9a65-3018b1b3369d (test@example.com)
-- 
-- This script updates ALL test data to use the correct user ID
-- 
-- Run this in Supabase SQL Editor:
-- Dashboard → SQL Editor → New Query → Paste this → Run
-- ============================================

-- 1. Verify the correct user exists
SELECT 
    id, 
    email, 
    role,
    status,
    org_id
FROM public.users 
WHERE email = 'test@example.com';

-- Expected result: Should show user with ID 82cf187c-c444-434a-9a65-3018b1b3369d

-- 2. Update ALL visits to use correct technician_id
UPDATE public.visits 
SET technician_id = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
WHERE technician_id = '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid
   OR technician_id IS NULL;

-- 3. Update ALL inventory items to use correct created_by
UPDATE public.inventory_items
SET created_by = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
WHERE created_by = '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid
   OR created_by IS NULL;

-- Note: jobs, quotes, and invoices tables don't have created_by columns
-- They are associated via visits (technician_id) or other relationships

-- 4. Verify visits are now assigned to correct technician
SELECT 
    v.id,
    v.scheduled_start,
    v.status,
    v.technician_id,
    u.email as technician_email,
    j.job_number,
    c.name as customer_name
FROM public.visits v
LEFT JOIN public.users u ON v.technician_id = u.id
LEFT JOIN public.jobs j ON v.job_id = j.id
LEFT JOIN public.customers c ON j.customer_id = c.id
WHERE v.technician_id = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
ORDER BY v.scheduled_start;

-- Expected result: Should show 2 visits for today

-- 5. Verify inventory items are now assigned to correct user
SELECT 
    id,
    name,
    sku,
    sale_price,
    created_by,
    (SELECT email FROM public.users WHERE id = created_by) as created_by_email
FROM public.inventory_items
WHERE org_id = '00000000-0000-0000-0000-000000000001'::uuid
ORDER BY name;

-- Expected result: Should show 3 inventory items, all with created_by = 82cf187c-c444-434a-9a65-3018b1b3369d

-- 6. Count visits scheduled for today
SELECT 
    COUNT(*) as visits_today,
    COUNT(CASE WHEN status = 'scheduled' THEN 1 END) as scheduled_count,
    COUNT(CASE WHEN status = 'in_progress' THEN 1 END) as in_progress_count,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_count
FROM public.visits
WHERE technician_id = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
  AND scheduled_start >= CURRENT_DATE
  AND scheduled_start < CURRENT_DATE + INTERVAL '1 day';

-- Expected result: visits_today = 2, scheduled_count = 2

-- ============================================
-- DONE!
-- ============================================
-- All test data is now associated with test@example.com
-- The app should now load:
-- - 2 visits scheduled for today
-- - 3 inventory items
-- - Chat threads (if any exist)
-- ============================================
