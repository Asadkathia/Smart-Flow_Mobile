-- ============================================
-- SmartFlowPro RLS Policies
-- Comprehensive Row Level Security policies for all tables
-- Per PRD Section 4: Role-Based Access Control
-- ============================================

-- ============================================
-- Helper Function: Get User Org ID
-- ============================================
CREATE OR REPLACE FUNCTION get_user_org_id()
RETURNS UUID AS $$
BEGIN
    RETURN (SELECT org_id FROM users WHERE id = auth.uid());
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- Helper Function: Get User Role
-- ============================================
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS user_role AS $$
BEGIN
    RETURN (SELECT role FROM users WHERE id = auth.uid());
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- Organizations Policies
-- ============================================
DROP POLICY IF EXISTS "Users can view their org data" ON organizations;
CREATE POLICY "Users can view their org data"
ON organizations FOR SELECT
TO authenticated
USING (id = get_user_org_id());

CREATE POLICY "Users can update their org"
ON organizations FOR UPDATE
TO authenticated
USING (id = get_user_org_id())
WITH CHECK (id = get_user_org_id());

-- ============================================
-- Users Policies
-- ============================================
CREATE POLICY "Users can view org members"
ON users FOR SELECT
TO authenticated
USING (org_id = get_user_org_id());

CREATE POLICY "Admins can manage users"
ON users FOR ALL
TO authenticated
USING (
    org_id = get_user_org_id() 
    AND get_user_role() IN ('admin', 'dispatcher')
)
WITH CHECK (
    org_id = get_user_org_id() 
    AND get_user_role() IN ('admin', 'dispatcher')
);

-- ============================================
-- Customers Policies
-- ============================================
CREATE POLICY "Users can view org customers"
ON customers FOR SELECT
TO authenticated
USING (org_id = get_user_org_id());

CREATE POLICY "Admins can manage customers"
ON customers FOR ALL
TO authenticated
USING (
    org_id = get_user_org_id() 
    AND get_user_role() IN ('admin', 'dispatcher')
)
WITH CHECK (
    org_id = get_user_org_id() 
    AND get_user_role() IN ('admin', 'dispatcher')
);

-- ============================================
-- Properties Policies
-- ============================================
CREATE POLICY "Users can view org properties"
ON properties FOR SELECT
TO authenticated
USING (org_id = get_user_org_id());

CREATE POLICY "Admins can manage properties"
ON properties FOR ALL
TO authenticated
USING (
    org_id = get_user_org_id() 
    AND get_user_role() IN ('admin', 'dispatcher')
)
WITH CHECK (
    org_id = get_user_org_id() 
    AND get_user_role() IN ('admin', 'dispatcher')
);

-- ============================================
-- Jobs Policies
-- ============================================
CREATE POLICY "Users can view org jobs"
ON jobs FOR SELECT
TO authenticated
USING (org_id = get_user_org_id());

CREATE POLICY "Admins can manage jobs"
ON jobs FOR ALL
TO authenticated
USING (
    org_id = get_user_org_id() 
    AND get_user_role() IN ('admin', 'dispatcher')
)
WITH CHECK (
    org_id = get_user_org_id() 
    AND get_user_role() IN ('admin', 'dispatcher')
);

-- ============================================
-- Visits Policies (Critical - Technician Access)
-- ============================================
CREATE POLICY "Technicians can view assigned visits"
ON visits FOR SELECT
TO authenticated
USING (
    org_id = get_user_org_id()
    AND (
        technician_id = auth.uid()
        OR get_user_role() IN ('admin', 'dispatcher')
    )
);

CREATE POLICY "Technicians can update assigned visits"
ON visits FOR UPDATE
TO authenticated
USING (
    org_id = get_user_org_id()
    AND technician_id = auth.uid()
)
WITH CHECK (
    org_id = get_user_org_id()
    AND technician_id = auth.uid()
);

CREATE POLICY "Admins can create visits"
ON visits FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND get_user_role() IN ('admin', 'dispatcher')
);

CREATE POLICY "Admins can delete visits"
ON visits FOR DELETE
TO authenticated
USING (
    org_id = get_user_org_id()
    AND get_user_role() IN ('admin', 'dispatcher')
);

-- ============================================
-- Notes Policies
-- ============================================
CREATE POLICY "Users can view visit notes"
ON notes FOR SELECT
TO authenticated
USING (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = notes.visit_id 
        AND (
            visits.technician_id = auth.uid()
            OR get_user_role() IN ('admin', 'dispatcher')
        )
    )
);

CREATE POLICY "Technicians can create notes"
ON notes FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND author_id = auth.uid()
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = notes.visit_id 
        AND visits.technician_id = auth.uid()
    )
);

CREATE POLICY "Users can update own notes"
ON notes FOR UPDATE
TO authenticated
USING (
    org_id = get_user_org_id()
    AND author_id = auth.uid()
)
WITH CHECK (
    org_id = get_user_org_id()
    AND author_id = auth.uid()
);

-- ============================================
-- Inventory Items Policies
-- ============================================
CREATE POLICY "Users can view org inventory"
ON inventory_items FOR SELECT
TO authenticated
USING (org_id = get_user_org_id());

CREATE POLICY "Technicians can create inventory"
ON inventory_items FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND (
        get_user_role() = 'technician'
        OR get_user_role() IN ('admin', 'dispatcher')
    )
);

CREATE POLICY "Users can update inventory"
ON inventory_items FOR UPDATE
TO authenticated
USING (org_id = get_user_org_id())
WITH CHECK (org_id = get_user_org_id());

CREATE POLICY "Admins can deactivate inventory"
ON inventory_items FOR UPDATE
TO authenticated
USING (
    org_id = get_user_org_id()
    AND get_user_role() IN ('admin', 'dispatcher')
)
WITH CHECK (
    org_id = get_user_org_id()
    AND get_user_role() IN ('admin', 'dispatcher')
);

-- ============================================
-- Billing Settings Policies
-- ============================================
CREATE POLICY "Users can view billing settings"
ON billing_settings FOR SELECT
TO authenticated
USING (org_id = get_user_org_id());

CREATE POLICY "Admins can manage billing"
ON billing_settings FOR ALL
TO authenticated
USING (
    org_id = get_user_org_id()
    AND get_user_role() = 'admin'
)
WITH CHECK (
    org_id = get_user_org_id()
    AND get_user_role() = 'admin'
);

-- ============================================
-- Quotes Policies
-- ============================================
CREATE POLICY "Technicians can view assigned visit quotes"
ON quotes FOR SELECT
TO authenticated
USING (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = quotes.visit_id 
        AND (
            visits.technician_id = auth.uid()
            OR get_user_role() IN ('admin', 'dispatcher', 'accountant')
        )
    )
);

CREATE POLICY "Technicians can create quotes"
ON quotes FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = quotes.visit_id 
        AND visits.technician_id = auth.uid()
    )
);

CREATE POLICY "Technicians can update draft quotes"
ON quotes FOR UPDATE
TO authenticated
USING (
    org_id = get_user_org_id()
    AND status = 'draft'
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = quotes.visit_id 
        AND visits.technician_id = auth.uid()
    )
)
WITH CHECK (
    org_id = get_user_org_id()
    AND status = 'draft'
);

CREATE POLICY "Technicians can delete draft quotes"
ON quotes FOR DELETE
TO authenticated
USING (
    org_id = get_user_org_id()
    AND status = 'draft'
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = quotes.visit_id 
        AND visits.technician_id = auth.uid()
    )
);

-- ============================================
-- Line Items Policies
-- ============================================
CREATE POLICY "Users can view quote line items"
ON line_items FOR SELECT
TO authenticated
USING (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM quotes 
        WHERE quotes.id = line_items.quote_id
    )
);

CREATE POLICY "Technicians can manage line items"
ON line_items FOR ALL
TO authenticated
USING (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM quotes 
        WHERE quotes.id = line_items.quote_id
        AND quotes.status = 'draft'
        AND EXISTS (
            SELECT 1 FROM visits 
            WHERE visits.id = quotes.visit_id 
            AND visits.technician_id = auth.uid()
        )
    )
)
WITH CHECK (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM quotes 
        WHERE quotes.id = line_items.quote_id
        AND quotes.status = 'draft'
    )
);

-- ============================================
-- Invoices Policies
-- ============================================
CREATE POLICY "Users can view org invoices"
ON invoices FOR SELECT
TO authenticated
USING (org_id = get_user_org_id());

CREATE POLICY "Technicians can create invoices"
ON invoices FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = invoices.visit_id 
        AND visits.technician_id = auth.uid()
    )
);

CREATE POLICY "Technicians can update draft invoices"
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
    AND status = 'draft'
);

CREATE POLICY "Accountants can manage payments"
ON invoices FOR UPDATE
TO authenticated
USING (
    org_id = get_user_org_id()
    AND get_user_role() IN ('admin', 'accountant')
)
WITH CHECK (
    org_id = get_user_org_id()
    AND get_user_role() IN ('admin', 'accountant')
);

-- ============================================
-- Payments Policies
-- ============================================
CREATE POLICY "Users can view payments"
ON payments FOR SELECT
TO authenticated
USING (org_id = get_user_org_id());

CREATE POLICY "Accountants can record payments"
ON payments FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND get_user_role() IN ('admin', 'accountant')
    AND received_by = auth.uid()
);

-- ============================================
-- Chat Threads Policies
-- ============================================
CREATE POLICY "Users can view org chats"
ON chat_threads FOR SELECT
TO authenticated
USING (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM chat_participants 
        WHERE chat_participants.chat_id = chat_threads.id 
        AND chat_participants.user_id = auth.uid()
    )
);

CREATE POLICY "Users can create direct chats"
ON chat_threads FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND created_by = auth.uid()
    AND type = 'direct'
);

CREATE POLICY "Admins can create group chats"
ON chat_threads FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND created_by = auth.uid()
    AND get_user_role() = 'admin'
);

-- ============================================
-- Chat Participants Policies
-- ============================================
CREATE POLICY "Users can view chat participants"
ON chat_participants FOR SELECT
TO authenticated
USING (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM chat_threads 
        WHERE chat_threads.id = chat_participants.chat_id
    )
);

CREATE POLICY "Users can join chats"
ON chat_participants FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND user_id = auth.uid()
);

CREATE POLICY "Chat admins can manage participants"
ON chat_participants FOR ALL
TO authenticated
USING (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM chat_participants cp
        WHERE cp.chat_id = chat_participants.chat_id
        AND cp.user_id = auth.uid()
        AND cp.role_in_chat = 'admin'
    )
);

-- ============================================
-- Chat Messages Policies
-- ============================================
CREATE POLICY "Users can view chat messages"
ON chat_messages FOR SELECT
TO authenticated
USING (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM chat_participants 
        WHERE chat_participants.chat_id = chat_messages.chat_id 
        AND chat_participants.user_id = auth.uid()
    )
);

CREATE POLICY "Users can send messages"
ON chat_messages FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND sender_id = auth.uid()
    AND EXISTS (
        SELECT 1 FROM chat_participants 
        WHERE chat_participants.chat_id = chat_messages.chat_id 
        AND chat_participants.user_id = auth.uid()
    )
);

-- ============================================
-- AI Interaction Logs Policies
-- ============================================
CREATE POLICY "Technicians can view own AI logs"
ON ai_interaction_logs FOR SELECT
TO authenticated
USING (
    org_id = get_user_org_id()
    AND (
        technician_id = auth.uid()
        OR get_user_role() IN ('admin', 'dispatcher')
    )
);

CREATE POLICY "Technicians can create AI logs"
ON ai_interaction_logs FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND technician_id = auth.uid()
);

-- ============================================
-- Audit Logs Policies (Admin Only)
-- ============================================
CREATE POLICY "Admins can view audit logs"
ON audit_logs FOR SELECT
TO authenticated
USING (
    org_id = get_user_org_id()
    AND get_user_role() = 'admin'
);

CREATE POLICY "System can create audit logs"
ON audit_logs FOR INSERT
TO authenticated
WITH CHECK (org_id = get_user_org_id());

-- ============================================
-- Visit Media Policies
-- ============================================
CREATE POLICY "Users can view visit media"
ON visit_media FOR SELECT
TO authenticated
USING (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = visit_media.visit_id 
        AND (
            visits.technician_id = auth.uid()
            OR get_user_role() IN ('admin', 'dispatcher')
        )
    )
);

CREATE POLICY "Technicians can upload media"
ON visit_media FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND uploaded_by = auth.uid()
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = visit_media.visit_id 
        AND visits.technician_id = auth.uid()
    )
);

CREATE POLICY "Admins can delete media"
ON visit_media FOR DELETE
TO authenticated
USING (
    org_id = get_user_org_id()
    AND get_user_role() = 'admin'
);

-- ============================================
-- Visit Signatures Policies
-- ============================================
CREATE POLICY "Users can view signatures"
ON visit_signatures FOR SELECT
TO authenticated
USING (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = visit_signatures.visit_id 
        AND (
            visits.technician_id = auth.uid()
            OR get_user_role() IN ('admin', 'dispatcher')
        )
    )
);

CREATE POLICY "Technicians can create signatures"
ON visit_signatures FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = visit_signatures.visit_id 
        AND visits.technician_id = auth.uid()
    )
);

CREATE POLICY "Technicians can update signatures"
ON visit_signatures FOR UPDATE
TO authenticated
USING (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = visit_signatures.visit_id 
        AND visits.technician_id = auth.uid()
    )
)
WITH CHECK (
    org_id = get_user_org_id()
    AND EXISTS (
        SELECT 1 FROM visits 
        WHERE visits.id = visit_signatures.visit_id 
        AND visits.technician_id = auth.uid()
    )
);

-- ============================================
-- Employee Invitations Policies
-- ============================================
CREATE POLICY "Admins can view invitations"
ON employee_invitations FOR SELECT
TO authenticated
USING (
    org_id = get_user_org_id()
    AND get_user_role() = 'admin'
);

CREATE POLICY "Admins can create invitations"
ON employee_invitations FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND get_user_role() = 'admin'
    AND invited_by = auth.uid()
);

CREATE POLICY "Admins can update invitations"
ON employee_invitations FOR UPDATE
TO authenticated
USING (
    org_id = get_user_org_id()
    AND get_user_role() = 'admin'
)
WITH CHECK (
    org_id = get_user_org_id()
    AND get_user_role() = 'admin'
);

-- ============================================
-- Quote Approvals Policies
-- ============================================
CREATE POLICY "Users can view quote approvals"
ON quote_approvals FOR SELECT
TO authenticated
USING (org_id = get_user_org_id());

CREATE POLICY "Admins can record approvals"
ON quote_approvals FOR INSERT
TO authenticated
WITH CHECK (
    org_id = get_user_org_id()
    AND get_user_role() IN ('admin', 'dispatcher')
    AND recorded_by = auth.uid()
);

-- ============================================
-- Sequence Counters Policies (Internal Only)
-- ============================================
CREATE POLICY "System can manage sequences"
ON sequence_counters FOR ALL
TO authenticated
USING (org_id = get_user_org_id())
WITH CHECK (org_id = get_user_org_id());
