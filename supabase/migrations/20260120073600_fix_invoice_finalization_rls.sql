-- Migration: Fix Invoice Finalization RLS Policy
-- Date: 2026-01-20
-- Description: Split invoice update policy to allow technicians to finalize draft invoices
--              (change status from 'draft' to 'unpaid')

-- Drop the existing policy that prevents finalization
DROP POLICY IF EXISTS "Technicians can update draft invoices" ON invoices;

-- Policy 1: Allow technicians to edit draft invoices (status stays 'draft')
CREATE POLICY "Technicians can edit draft invoices"
ON invoices FOR UPDATE
TO authenticated
USING (
    org_id = get_user_org_id()
    AND status = 'draft'
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = invoices.visit_id 
        AND visits.technician_id = auth.uid()
    )
)
WITH CHECK (
    org_id = get_user_org_id()
    AND status = 'draft'  -- Status must remain 'draft' for edits
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = invoices.visit_id 
        AND visits.technician_id = auth.uid()
    )
);

-- Policy 2: Allow technicians to finalize draft invoices (draft → unpaid)
CREATE POLICY "Technicians can finalize draft invoices"
ON invoices FOR UPDATE
TO authenticated
USING (
    org_id = get_user_org_id()
    AND status = 'draft'  -- Can only finalize if currently draft
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = invoices.visit_id 
        AND visits.technician_id = auth.uid()
    )
)
WITH CHECK (
    org_id = get_user_org_id()
    AND status IN ('draft', 'unpaid')  -- Allow draft → unpaid transition
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = invoices.visit_id 
        AND visits.technician_id = auth.uid()
    )
);

-- Note: The "Accountants can manage payments" policy (lines 400-410 in rls_policies.sql)
-- already allows admins/accountants to update invoices for payment recording.
-- This migration only affects technician permissions.
