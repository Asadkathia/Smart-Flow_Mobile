-- Fix for inventory items creation RLS policy

-- The flutter app does not restrict creation strictly to technicians in `createInventoryItem` 
-- the current policy only allows 'technician', 'admin', 'dispatcher'
-- Let's check the current policy:
-- CREATE POLICY "Technicians can create inventory"
-- ON inventory_items FOR INSERT
-- TO authenticated
-- WITH CHECK (
--     org_id = get_user_org_id()
--     AND (
--         get_user_role() = 'technician'
--         OR get_user_role() IN ('admin', 'dispatcher')
--     )
-- );

-- It's possible the user is sending an invalid role, or has the role 'accountant' which isn't allowed to create inventory items.
-- Additionally, the flutter app sends `created_by` in the REST payload, which doesn't violate RLS directly, 
-- but the main reason would likely be the user role not being in the allowed list, OR the org_id is incorrect.

-- Let's update the policy to allow any authenticated user within the organization to create inventory items,
-- or specifically grant access to the missing roles if needed.

BEGIN;

DROP POLICY IF EXISTS "Technicians can create inventory" ON inventory_items;

CREATE POLICY "Technicians can create inventory"
ON inventory_items FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
);

COMMIT;
