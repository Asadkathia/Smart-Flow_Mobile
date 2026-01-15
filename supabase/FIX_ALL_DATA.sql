-- ============================================
-- COMPLETE FIX: Setup Test Data for test@example.com
-- User ID: 82cf187c-c444-434a-9a65-3018b1b3369d
-- ============================================
-- Run this script in Supabase SQL Editor:
-- Dashboard → SQL Editor → New Query → Paste → Run
-- ============================================

-- ============================================
-- STEP 1: Verify User Profile
-- ============================================
DO $$
DECLARE
    user_exists BOOLEAN;
    user_id_val UUID := '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid;
    org_id_val UUID := '00000000-0000-0000-0000-000000000001'::uuid;
BEGIN
    -- Check if user exists
    SELECT EXISTS(SELECT 1 FROM public.users WHERE id = user_id_val) INTO user_exists;
    
    IF NOT user_exists THEN
        -- Create user profile if doesn't exist
        INSERT INTO public.users (
            id,
            org_id,
            full_name,
            email,
            phone,
            role,
            status
        ) VALUES (
            user_id_val,
            org_id_val,
            'Test User',
            'test@example.com',
            '+1234567890',
            'technician',
            'active'
        );
        RAISE NOTICE 'Created user profile for test@example.com';
    ELSE
        -- Update existing user to ensure correct settings
        UPDATE public.users 
        SET 
            org_id = org_id_val,
            role = 'technician',
            status = 'active',
            full_name = COALESCE(full_name, 'Test User'),
            phone = COALESCE(phone, '+1234567890')
        WHERE id = user_id_val;
        RAISE NOTICE 'Updated user profile for test@example.com';
    END IF;
END $$;

-- ============================================
-- STEP 2: Ensure Organization Exists
-- ============================================
INSERT INTO public.organizations (
    id,
    name,
    timezone,
    currency,
    org_prefix,
    plan,
    settings
) VALUES (
    '00000000-0000-0000-0000-000000000001'::uuid,
    'Test Service Company',
    'America/New_York',
    'USD',
    'TEST',
    'pro',
    '{"file_size_limits": {"image": 10485760, "pdf": 26214400, "video": 104857600, "signature": 5242880}}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    settings = EXCLUDED.settings;

-- ============================================
-- STEP 3: Ensure Billing Settings
-- ============================================
INSERT INTO public.billing_settings (
    org_id,
    service_call_fee,
    tax_rate,
    currency
) VALUES (
    '00000000-0000-0000-0000-000000000001'::uuid,
    75.00,
    0.08,
    'USD'
) ON CONFLICT (org_id) DO UPDATE SET
    service_call_fee = EXCLUDED.service_call_fee,
    tax_rate = EXCLUDED.tax_rate;

-- ============================================
-- STEP 4: Update ALL Existing Test Data
-- ============================================
-- Update visits to correct technician_id
UPDATE public.visits 
SET technician_id = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
WHERE technician_id = '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid
   OR technician_id IS NULL;

-- Update inventory items to correct created_by
UPDATE public.inventory_items
SET created_by = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
WHERE created_by = '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid
   OR created_by IS NULL;

-- ============================================
-- STEP 5: Create Test Data if Missing
-- ============================================

-- Create Customer if not exists
INSERT INTO public.customers (
    id,
    org_id,
    name,
    phone,
    email,
    preferred_contact_method
) VALUES (
    '00000000-0000-0000-0000-000000000010'::uuid,
    '00000000-0000-0000-0000-000000000001'::uuid,
    'John Smith',
    '+1987654321',
    'john.smith@example.com',
    'call'
) ON CONFLICT (id) DO NOTHING;

-- Create Property if not exists
INSERT INTO public.properties (
    id,
    org_id,
    customer_id,
    address,
    latitude,
    longitude
) VALUES (
    '00000000-0000-0000-0000-000000000020'::uuid,
    '00000000-0000-0000-0000-000000000001'::uuid,
    '00000000-0000-0000-0000-000000000010'::uuid,
    '123 Main Street, New York, NY 10001',
    40.7128,
    -74.0060
) ON CONFLICT (id) DO NOTHING;

-- Create Sequence Counters if not exists
INSERT INTO public.sequence_counters (
    org_id,
    entity_type,
    current_sequence
) VALUES
    ('00000000-0000-0000-0000-000000000001'::uuid, 'job', 0),
    ('00000000-0000-0000-0000-000000000001'::uuid, 'quote', 0),
    ('00000000-0000-0000-0000-000000000001'::uuid, 'invoice', 0)
ON CONFLICT (org_id, entity_type) DO NOTHING;

-- Create Job if not exists
INSERT INTO public.jobs (
    id,
    org_id,
    job_number,
    customer_id,
    service_type,
    priority,
    notes
) VALUES (
    '00000000-0000-0000-0000-000000000100'::uuid,
    '00000000-0000-0000-0000-000000000001'::uuid,
    'JOB-TEST-0001',
    '00000000-0000-0000-0000-000000000010'::uuid,
    'HVAC Repair',
    'medium',
    'Customer reported AC not working. Need to check compressor and refrigerant levels.'
) ON CONFLICT (id) DO NOTHING;

-- Delete old visits (to recreate with correct dates)
DELETE FROM public.visits WHERE id IN (
    '00000000-0000-0000-0000-000000000200'::uuid,
    '00000000-0000-0000-0000-000000000201'::uuid
);

-- Create Visits for TODAY
INSERT INTO public.visits (
    id,
    org_id,
    job_id,
    technician_id,
    scheduled_start,
    scheduled_end,
    status,
    sequence_order,
    version
) VALUES
    -- Morning visit
    (
        '00000000-0000-0000-0000-000000000200'::uuid,
        '00000000-0000-0000-0000-000000000001'::uuid,
        '00000000-0000-0000-0000-000000000100'::uuid,
        '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid,
        (CURRENT_DATE + INTERVAL '9 hours')::timestamptz,
        (CURRENT_DATE + INTERVAL '11 hours')::timestamptz,
        'scheduled',
        1,
        1
    ),
    -- Afternoon visit
    (
        '00000000-0000-0000-0000-000000000201'::uuid,
        '00000000-0000-0000-0000-000000000001'::uuid,
        '00000000-0000-0000-0000-000000000100'::uuid,
        '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid,
        (CURRENT_DATE + INTERVAL '14 hours')::timestamptz,
        (CURRENT_DATE + INTERVAL '16 hours')::timestamptz,
        'scheduled',
        2,
        1
    );

-- Create Inventory Items if not exists
INSERT INTO public.inventory_items (
    id,
    org_id,
    name,
    sku,
    unit,
    sale_price,
    taxable_default,
    active,
    created_by
) VALUES
    (
        '00000000-0000-0000-0000-000000000300'::uuid,
        '00000000-0000-0000-0000-000000000001'::uuid,
        'Refrigerant R-410A',
        'REF-R410A-1LB',
        'lb',
        25.99,
        true,
        true,
        '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
    ),
    (
        '00000000-0000-0000-0000-000000000301'::uuid,
        '00000000-0000-0000-0000-000000000001'::uuid,
        'AC Filter Replacement',
        'FILTER-STD-1',
        'each',
        15.50,
        true,
        true,
        '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
    ),
    (
        '00000000-0000-0000-0000-000000000302'::uuid,
        '00000000-0000-0000-0000-000000000001'::uuid,
        'Service Call Fee',
        'SVC-CALL',
        'each',
        75.00,
        true,
        true,
        '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
    )
ON CONFLICT (id) DO UPDATE SET
    created_by = EXCLUDED.created_by,
    active = EXCLUDED.active;

-- ============================================
-- STEP 6: Verification Queries
-- ============================================

-- Verify user profile
SELECT 
    'USER PROFILE' as check_type,
    id, 
    email, 
    role,
    status,
    org_id
FROM public.users 
WHERE email = 'test@example.com';

-- Verify visits for today
SELECT 
    'VISITS TODAY' as check_type,
    COUNT(*) as total_visits,
    COUNT(CASE WHEN status = 'scheduled' THEN 1 END) as scheduled_count
FROM public.visits
WHERE technician_id = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
  AND scheduled_start >= CURRENT_DATE
  AND scheduled_start < CURRENT_DATE + INTERVAL '1 day';

-- Verify inventory items
SELECT 
    'INVENTORY ITEMS' as check_type,
    COUNT(*) as total_items,
    COUNT(CASE WHEN active = true THEN 1 END) as active_count
FROM public.inventory_items
WHERE org_id = '00000000-0000-0000-0000-000000000001'::uuid
  AND created_by = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid;

-- Verify chat threads (should be empty initially)
SELECT 
    'CHAT THREADS' as check_type,
    COUNT(*) as total_threads
FROM public.chat_threads
WHERE org_id = '00000000-0000-0000-0000-000000000001'::uuid;

-- Show detailed visits
SELECT 
    'VISIT DETAILS' as info,
    v.id,
    v.scheduled_start,
    v.scheduled_end,
    v.status,
    j.job_number,
    c.name as customer_name,
    p.address
FROM public.visits v
JOIN public.jobs j ON v.job_id = j.id
JOIN public.customers c ON j.customer_id = c.id
LEFT JOIN public.properties p ON j.property_id = p.id
WHERE v.technician_id = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
  AND v.scheduled_start >= CURRENT_DATE
  AND v.scheduled_start < CURRENT_DATE + INTERVAL '1 day'
ORDER BY v.scheduled_start;

-- Show inventory items
SELECT 
    'INVENTORY DETAILS' as info,
    id,
    name,
    sku,
    unit,
    sale_price,
    active
FROM public.inventory_items
WHERE org_id = '00000000-0000-0000-0000-000000000001'::uuid
  AND created_by = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
ORDER BY name;

-- ============================================
-- SUCCESS!
-- ============================================
-- Expected Results:
-- - USER PROFILE: 1 row (test@example.com as technician)
-- - VISITS TODAY: 2 visits, 2 scheduled
-- - INVENTORY ITEMS: 3 items, 3 active
-- - CHAT THREADS: 0 (empty is normal)
-- ============================================
