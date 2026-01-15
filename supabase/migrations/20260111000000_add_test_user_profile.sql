-- ============================================
-- Add User Profile for test@example.com
-- ============================================
-- 
-- This migration adds a user profile for the existing auth user test@example.com
-- The auth user already exists with ID: 82cf187c-c444-434a-9a65-3018b1b3369d
-- We need to create the corresponding profile in the users table.
--
-- ============================================

-- Insert user profile for test@example.com
INSERT INTO public.users (
    id,
    org_id,
    full_name,
    email,
    phone,
    role,
    status
) VALUES (
    '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid,
    '00000000-0000-0000-0000-000000000001'::uuid,  -- Using the test organization
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

-- Update existing test data to use the correct user ID
-- Update visits to be assigned to this technician
UPDATE public.visits 
SET technician_id = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
WHERE technician_id = '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid;

-- Update inventory items created_by to this technician
UPDATE public.inventory_items
SET created_by = '82cf187c-c444-434a-9a65-3018b1b3369d'::uuid
WHERE created_by = '13f79aef-96b3-4295-9fee-262ec6bc35c3'::uuid;
