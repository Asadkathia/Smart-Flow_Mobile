
-- ============================================
-- SmartFlowPro Minimal Test Data
-- Project: SmartFlowPro
-- Project Ref: pbqbsdmwbjpsvxuuwjiv
-- Date: 2026-01-10
-- ============================================
-- 
-- This migration inserts minimal test data for testing the mobile app.
-- Auth user UUID: 13f79aef-96b3-4295-9fee-262ec6bc35c3
-- Auth user email: test.technician@example.com
-- ============================================

-- ============================================
-- 1. Organization
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
) ON CONFLICT (id) DO NOTHING;

-- ============================================
-- 2. Billing Settings (Required for quotes)
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
-- 3. User (Technician)
-- ============================================
INSERT INTO public.users (
    id,
    org_id,
    full_name,
    email,
    phone,
    role,
    status
) VALUES (
    '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid,
    '00000000-0000-0000-0000-000000000001'::uuid,
    'Test Technician',
    'test.technician@example.com',
    '+1234567890',
    'technician',
    'active'
) ON CONFLICT (org_id, email) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    phone = EXCLUDED.phone,
    role = EXCLUDED.role,
    status = EXCLUDED.status;

-- ============================================
-- 4. Customer
-- ============================================
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

-- ============================================
-- 5. Property
-- ============================================
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

-- ============================================
-- 6. Sequence Counters (Initialize for number generation)
-- ============================================
INSERT INTO public.sequence_counters (
    org_id,
    entity_type,
    current_sequence
) VALUES
    ('00000000-0000-0000-0000-000000000001'::uuid, 'job', 0),
    ('00000000-0000-0000-0000-000000000001'::uuid, 'quote', 0),
    ('00000000-0000-0000-0000-000000000001'::uuid, 'invoice', 0)
ON CONFLICT (org_id, entity_type) DO NOTHING;

-- ============================================
-- 7. Job
-- ============================================
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

-- ============================================
-- 8. Visits (Today - scheduled for testing)
-- ============================================
-- Visit 1: Scheduled for today (morning)
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
) VALUES (
    '00000000-0000-0000-0000-000000000200'::uuid,
    '00000000-0000-0000-0000-000000000001'::uuid,
    '00000000-0000-0000-0000-000000000100'::uuid,
    '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid,
    (CURRENT_DATE + INTERVAL '9 hours')::timestamptz,
    (CURRENT_DATE + INTERVAL '11 hours')::timestamptz,
    'scheduled',
    1,
    1
) ON CONFLICT (id) DO NOTHING;

-- Visit 2: Scheduled for today (afternoon)
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
) VALUES (
    '00000000-0000-0000-0000-000000000201'::uuid,
    '00000000-0000-0000-0000-000000000001'::uuid,
    '00000000-0000-0000-0000-000000000100'::uuid,
    '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid,
    (CURRENT_DATE + INTERVAL '14 hours')::timestamptz,
    (CURRENT_DATE + INTERVAL '16 hours')::timestamptz,
    'scheduled',
    2,
    1
) ON CONFLICT (id) DO NOTHING;

-- ============================================
-- 9. Inventory Items (Minimal - for testing)
-- ============================================
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
        '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid
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
        '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid
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
        '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid
    )
ON CONFLICT (id) DO NOTHING;


