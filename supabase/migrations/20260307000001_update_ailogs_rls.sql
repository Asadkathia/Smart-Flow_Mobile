-- Fix for AI interaction logs creation RLS policy

BEGIN;

DROP POLICY IF EXISTS "Technicians can create AI logs" ON ai_interaction_logs;

CREATE POLICY "Technicians can create AI logs"
ON ai_interaction_logs FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
);

COMMIT;
