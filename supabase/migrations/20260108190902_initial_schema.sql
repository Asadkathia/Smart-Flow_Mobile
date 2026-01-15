-- ============================================
-- SmartFlowPro Database Schema v1.0
-- Project: SmartFlowPro
-- Project Ref: pbqbsdmwbjpsvxuuwjiv
-- Date: 2026-01-08
-- ============================================

-- ============================================
-- Extensions
-- ============================================
-- Use gen_random_uuid() from pgcrypto (built-in) instead of uuid-ossp
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";
-- Note: postgis may not be available in all Supabase instances, using basic location support
-- CREATE EXTENSION IF NOT EXISTS "postgis";

-- ============================================
-- 1. Organizations Table
-- ============================================
CREATE TABLE public.organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    timezone TEXT NOT NULL DEFAULT 'UTC',
    currency TEXT NOT NULL DEFAULT 'USD',
    org_prefix TEXT UNIQUE NOT NULL CHECK (org_prefix ~ '^[A-Z0-9]{1,10}$'),
    plan TEXT,
    settings JSONB DEFAULT '{}'::jsonb,
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_organizations_prefix ON organizations(org_prefix);

-- ============================================
-- 2. Users Table (Employees)
-- ============================================
CREATE TYPE user_role AS ENUM ('admin', 'dispatcher', 'accountant', 'technician');
CREATE TYPE user_status AS ENUM ('active', 'suspended', 'deactivated');

CREATE TABLE public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    role user_role NOT NULL,
    status user_status DEFAULT 'active',
    last_login_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(org_id, email)
);

CREATE INDEX idx_users_org_id ON users(org_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_status ON users(status);

-- ============================================
-- 3. Customers Table
-- ============================================
CREATE TYPE contact_method AS ENUM ('call', 'sms');

CREATE TABLE public.customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    email TEXT,
    preferred_contact_method contact_method DEFAULT 'call',
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_customers_org_id ON customers(org_id);
CREATE INDEX idx_customers_phone ON customers(phone);
CREATE INDEX idx_customers_email ON customers(email);

-- ============================================
-- 4. Properties Table
-- ============================================
CREATE TABLE public.properties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    address TEXT NOT NULL,
    latitude DOUBLE PRECISION CHECK (latitude >= -90 AND latitude <= 90),
    longitude DOUBLE PRECISION CHECK (longitude >= -180 AND longitude <= 180),
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_properties_org_id ON properties(org_id);
CREATE INDEX idx_properties_customer_id ON properties(customer_id);
CREATE INDEX idx_properties_location ON properties(latitude, longitude) WHERE latitude IS NOT NULL AND longitude IS NOT NULL;

-- ============================================
-- 5. Jobs Table
-- ============================================
CREATE TYPE job_priority AS ENUM ('low', 'medium', 'high');

CREATE TABLE public.jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    job_number TEXT NOT NULL,
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
    service_type TEXT NOT NULL,
    priority job_priority DEFAULT 'medium',
    notes TEXT,
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(org_id, job_number)
);

CREATE INDEX idx_jobs_org_id ON jobs(org_id);
CREATE INDEX idx_jobs_customer_id ON jobs(customer_id);
CREATE INDEX idx_jobs_number ON jobs(job_number);
CREATE INDEX idx_jobs_priority ON jobs(priority);

-- ============================================
-- 6. Visits Table (Primary Operational Entity)
-- ============================================
CREATE TYPE visit_status AS ENUM ('scheduled', 'in_progress', 'paused', 'completed', 'cancelled');

CREATE TABLE public.visits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE RESTRICT,
    technician_id UUID REFERENCES users(id) ON DELETE SET NULL,
    scheduled_start TIMESTAMPTZ NOT NULL,
    scheduled_end TIMESTAMPTZ NOT NULL,
    actual_start TIMESTAMPTZ,
    actual_end TIMESTAMPTZ,
    status visit_status DEFAULT 'scheduled',
    status_reason TEXT,
    sequence_order INTEGER,
    version INTEGER DEFAULT 1,
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now(),
    CHECK (scheduled_end > scheduled_start),
    CHECK (actual_end IS NULL OR actual_start IS NOT NULL)
);

CREATE INDEX idx_visits_org_id ON visits(org_id);
CREATE INDEX idx_visits_technician_id ON visits(technician_id);
CREATE INDEX idx_visits_status ON visits(status);
CREATE INDEX idx_visits_scheduled_range ON visits(scheduled_start, scheduled_end);
CREATE INDEX idx_visits_job_id ON visits(job_id);

-- ============================================
-- 7. Notes Table
-- ============================================
CREATE TABLE public.notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    visit_id UUID NOT NULL REFERENCES visits(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    body TEXT NOT NULL,
    version INTEGER DEFAULT 1,
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_notes_org_id ON notes(org_id);
CREATE INDEX idx_notes_visit_id ON notes(visit_id);
CREATE INDEX idx_notes_author_id ON notes(author_id);
CREATE INDEX idx_notes_created_at ON notes(created_at DESC);

-- ============================================
-- 8. InventoryItems Table
-- ============================================
CREATE TABLE public.inventory_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    sku TEXT,
    unit TEXT NOT NULL,
    sale_price NUMERIC NOT NULL CHECK (sale_price >= 0),
    taxable_default BOOLEAN DEFAULT true,
    active BOOLEAN DEFAULT true,
    image_path TEXT,
    ai_suggested_price NUMERIC CHECK (ai_suggested_price >= 0),
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_inventory_items_org_id ON inventory_items(org_id);
CREATE INDEX idx_inventory_items_active ON inventory_items(active) WHERE active = true;
CREATE INDEX idx_inventory_items_sku ON inventory_items(sku) WHERE sku IS NOT NULL;
CREATE INDEX idx_inventory_items_created_by ON inventory_items(created_by);
-- Partial unique index for SKU uniqueness within org (only when SKU is not null)
CREATE UNIQUE INDEX idx_inventory_items_org_sku_unique ON inventory_items(org_id, sku) WHERE sku IS NOT NULL;

-- ============================================
-- 9. BillingSettings Table
-- ============================================
CREATE TABLE public.billing_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID UNIQUE NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    service_call_fee NUMERIC NOT NULL CHECK (service_call_fee >= 0),
    tax_rate NUMERIC NOT NULL CHECK (tax_rate >= 0 AND tax_rate <= 1),
    currency TEXT,
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_billing_settings_org_id ON billing_settings(org_id);

-- ============================================
-- 10. Quotes Table
-- ============================================
CREATE TYPE quote_status AS ENUM ('draft', 'finalized', 'invoiced');

CREATE TABLE public.quotes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    visit_id UUID NOT NULL REFERENCES visits(id) ON DELETE RESTRICT,
    quote_number TEXT NOT NULL,
    status quote_status DEFAULT 'draft',
    taxable BOOLEAN DEFAULT true,
    subtotal NUMERIC NOT NULL DEFAULT 0 CHECK (subtotal >= 0),
    discount_total NUMERIC NOT NULL DEFAULT 0 CHECK (discount_total >= 0),
    tax_total NUMERIC NOT NULL DEFAULT 0 CHECK (tax_total >= 0),
    grand_total NUMERIC NOT NULL DEFAULT 0 CHECK (grand_total >= 0),
    locked_at TIMESTAMPTZ,
    locked_by UUID REFERENCES users(id) ON DELETE SET NULL,
    version INTEGER DEFAULT 1,
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(org_id, quote_number)
);

CREATE INDEX idx_quotes_org_id ON quotes(org_id);
CREATE INDEX idx_quotes_visit_id ON quotes(visit_id);
CREATE INDEX idx_quotes_number ON quotes(quote_number);
CREATE INDEX idx_quotes_status ON quotes(status);

-- ============================================
-- 11. LineItems Table
-- ============================================
CREATE TYPE line_item_type AS ENUM ('service', 'material', 'service_call_fee', 'discount');

CREATE TABLE public.line_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    quote_id UUID NOT NULL REFERENCES quotes(id) ON DELETE CASCADE,
    type line_item_type NOT NULL,
    reference_id UUID REFERENCES inventory_items(id) ON DELETE SET NULL,
    description TEXT NOT NULL,
    unit TEXT NOT NULL,
    qty NUMERIC NOT NULL CHECK (qty > 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price >= 0),
    taxable BOOLEAN DEFAULT true,
    version INTEGER DEFAULT 1,
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_line_items_org_id ON line_items(org_id);
CREATE INDEX idx_line_items_quote_id ON line_items(quote_id);
CREATE INDEX idx_line_items_reference_id ON line_items(reference_id) WHERE reference_id IS NOT NULL;
CREATE INDEX idx_line_items_type ON line_items(type);

-- ============================================
-- 12. Invoices Table
-- ============================================
CREATE TYPE invoice_status AS ENUM ('draft', 'unpaid', 'partially_paid', 'paid', 'void', 'refunded');

CREATE TABLE public.invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    visit_id UUID NOT NULL REFERENCES visits(id) ON DELETE RESTRICT,
    quote_id UUID REFERENCES quotes(id) ON DELETE SET NULL,
    invoice_number TEXT NOT NULL,
    status invoice_status DEFAULT 'draft',
    total NUMERIC NOT NULL DEFAULT 0 CHECK (total >= 0),
    version INTEGER DEFAULT 1,
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(org_id, invoice_number)
);

CREATE INDEX idx_invoices_org_id ON invoices(org_id);
CREATE INDEX idx_invoices_visit_id ON invoices(visit_id);
CREATE INDEX idx_invoices_quote_id ON invoices(quote_id) WHERE quote_id IS NOT NULL;
CREATE INDEX idx_invoices_number ON invoices(invoice_number);
CREATE INDEX idx_invoices_status ON invoices(status);

-- ============================================
-- 13. Payments Table
-- ============================================
CREATE TYPE payment_method AS ENUM ('cash', 'bank_transfer', 'card', 'stripe_link');

CREATE TABLE public.payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    invoice_id UUID NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    amount NUMERIC NOT NULL CHECK (amount > 0),
    method payment_method NOT NULL,
    reference TEXT,
    received_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    received_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_payments_org_id ON payments(org_id);
CREATE INDEX idx_payments_invoice_id ON payments(invoice_id);
CREATE INDEX idx_payments_received_by ON payments(received_by);
CREATE INDEX idx_payments_received_at ON payments(received_at DESC);

-- ============================================
-- 14. ChatThreads Table
-- ============================================
CREATE TYPE chat_type AS ENUM ('direct', 'group');

CREATE TABLE public.chat_threads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    type chat_type NOT NULL,
    title TEXT,
    created_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_chat_threads_org_id ON chat_threads(org_id);
CREATE INDEX idx_chat_threads_created_by ON chat_threads(created_by);
CREATE INDEX idx_chat_threads_type ON chat_threads(type);

-- ============================================
-- 15. ChatParticipants Table
-- ============================================
CREATE TYPE chat_participant_role AS ENUM ('member', 'admin');

CREATE TABLE public.chat_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    chat_id UUID NOT NULL REFERENCES chat_threads(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_in_chat chat_participant_role DEFAULT 'member',
    joined_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(chat_id, user_id)
);

CREATE INDEX idx_chat_participants_org_id ON chat_participants(org_id);
CREATE INDEX idx_chat_participants_chat_id ON chat_participants(chat_id);
CREATE INDEX idx_chat_participants_user_id ON chat_participants(user_id);

-- ============================================
-- 16. ChatMessages Table
-- ============================================
CREATE TABLE public.chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    chat_id UUID NOT NULL REFERENCES chat_threads(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    message_body TEXT NOT NULL CHECK (char_length(message_body) <= 5000),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_chat_messages_org_id ON chat_messages(org_id);
CREATE INDEX idx_chat_messages_chat_id ON chat_messages(chat_id);
CREATE INDEX idx_chat_messages_sender_id ON chat_messages(sender_id);
CREATE INDEX idx_chat_messages_created_at ON chat_messages(created_at DESC);

-- ============================================
-- 17. AIInteractionLogs Table
-- ============================================
CREATE TABLE public.ai_interaction_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    technician_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    visit_id UUID REFERENCES visits(id) ON DELETE SET NULL,
    prompt TEXT NOT NULL,
    response TEXT NOT NULL,
    model TEXT NOT NULL,
    tokens_in INTEGER,
    tokens_out INTEGER,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_ai_interaction_logs_org_id ON ai_interaction_logs(org_id);
CREATE INDEX idx_ai_interaction_logs_technician_id ON ai_interaction_logs(technician_id);
CREATE INDEX idx_ai_interaction_logs_visit_id ON ai_interaction_logs(visit_id) WHERE visit_id IS NOT NULL;
CREATE INDEX idx_ai_interaction_logs_created_at ON ai_interaction_logs(created_at DESC);

-- ============================================
-- 18. AuditLogs Table
-- ============================================
CREATE TABLE public.audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    entity TEXT NOT NULL,
    entity_id UUID NOT NULL,
    action TEXT NOT NULL,
    performed_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    payload JSONB,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_audit_logs_org_id ON audit_logs(org_id);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity, entity_id);
CREATE INDEX idx_audit_logs_performed_by ON audit_logs(performed_by);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at DESC);

-- ============================================
-- 19. VisitMedia Table
-- ============================================
CREATE TYPE file_type AS ENUM ('image', 'video', 'pdf');

CREATE TABLE public.visit_media (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    visit_id UUID NOT NULL REFERENCES visits(id) ON DELETE CASCADE,
    uploaded_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    file_path TEXT NOT NULL,
    file_type file_type NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_visit_media_org_id ON visit_media(org_id);
CREATE INDEX idx_visit_media_visit_id ON visit_media(visit_id);
CREATE INDEX idx_visit_media_uploaded_by ON visit_media(uploaded_by);

-- ============================================
-- 20. VisitSignatures Table
-- ============================================
CREATE TABLE public.visit_signatures (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    visit_id UUID NOT NULL REFERENCES visits(id) ON DELETE CASCADE,
    signed_by TEXT NOT NULL,
    signature_path TEXT NOT NULL,
    signed_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(visit_id)
);

CREATE INDEX idx_visit_signatures_org_id ON visit_signatures(org_id);
CREATE INDEX idx_visit_signatures_visit_id ON visit_signatures(visit_id);

-- ============================================
-- 21. EmployeeInvitations Table
-- ============================================
CREATE TYPE invitation_status AS ENUM ('pending', 'accepted', 'expired');

CREATE TABLE public.employee_invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    phone TEXT,
    full_name TEXT,
    role user_role NOT NULL,
    invited_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    token TEXT UNIQUE NOT NULL,
    status invitation_status DEFAULT 'pending',
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_employee_invitations_org_id ON employee_invitations(org_id);
CREATE INDEX idx_employee_invitations_email ON employee_invitations(email);
CREATE INDEX idx_employee_invitations_token ON employee_invitations(token);
CREATE INDEX idx_employee_invitations_status ON employee_invitations(status);

-- ============================================
-- 22. QuoteApprovals Table (Optional)
-- ============================================
CREATE TYPE approval_status AS ENUM ('approved', 'rejected');
CREATE TYPE approval_method AS ENUM ('call', 'sms');

CREATE TABLE public.quote_approvals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    quote_id UUID NOT NULL REFERENCES quotes(id) ON DELETE CASCADE,
    approval_status approval_status NOT NULL,
    method approval_method NOT NULL,
    recorded_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    recorded_at TIMESTAMPTZ DEFAULT now(),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_quote_approvals_org_id ON quote_approvals(org_id);
CREATE INDEX idx_quote_approvals_quote_id ON quote_approvals(quote_id);
CREATE INDEX idx_quote_approvals_recorded_by ON quote_approvals(recorded_by);

-- ============================================
-- 23. SequenceCounters Table (Internal)
-- ============================================
CREATE TABLE public.sequence_counters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    entity_type TEXT NOT NULL CHECK (entity_type IN ('quote', 'invoice', 'job')),
    current_sequence INTEGER DEFAULT 0 CHECK (current_sequence >= 0),
    updated_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(org_id, entity_type)
);

CREATE INDEX idx_sequence_counters_org_id ON sequence_counters(org_id);
CREATE INDEX idx_sequence_counters_entity_type ON sequence_counters(entity_type);

-- ============================================
-- Database Functions & Triggers
-- ============================================

-- Auto-update updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at triggers to all tables
CREATE TRIGGER update_organizations_updated_at BEFORE UPDATE ON organizations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON customers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_properties_updated_at BEFORE UPDATE ON properties FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_jobs_updated_at BEFORE UPDATE ON jobs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_visits_updated_at BEFORE UPDATE ON visits FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_notes_updated_at BEFORE UPDATE ON notes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_inventory_items_updated_at BEFORE UPDATE ON inventory_items FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_billing_settings_updated_at BEFORE UPDATE ON billing_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_quotes_updated_at BEFORE UPDATE ON quotes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_line_items_updated_at BEFORE UPDATE ON line_items FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_invoices_updated_at BEFORE UPDATE ON invoices FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_chat_threads_updated_at BEFORE UPDATE ON chat_threads FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_visit_signatures_updated_at BEFORE UPDATE ON visit_signatures FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Sequence counter function (atomic increment)
CREATE OR REPLACE FUNCTION get_next_sequence(
    p_org_id UUID,
    p_entity_type TEXT
)
RETURNS INTEGER AS $$
DECLARE
    v_next_seq INTEGER;
BEGIN
    -- Insert or update with atomic increment
    INSERT INTO sequence_counters (org_id, entity_type, current_sequence)
    VALUES (p_org_id, p_entity_type, 0)
    ON CONFLICT (org_id, entity_type)
    DO UPDATE SET 
        current_sequence = sequence_counters.current_sequence + 1,
        updated_at = now()
    RETURNING current_sequence INTO v_next_seq;
    
    RETURN v_next_seq;
END;
$$ LANGUAGE plpgsql;

-- Generate quote number function
CREATE OR REPLACE FUNCTION generate_quote_number(p_org_id UUID)
RETURNS TEXT AS $$
DECLARE
    v_org_prefix TEXT;
    v_sequence INTEGER;
BEGIN
    -- Get org prefix
    SELECT org_prefix INTO v_org_prefix
    FROM organizations WHERE id = p_org_id;
    
    IF v_org_prefix IS NULL THEN
        RAISE EXCEPTION 'Organization prefix not found for org_id: %', p_org_id;
    END IF;
    
    -- Get next sequence (atomic increment)
    SELECT get_next_sequence(p_org_id, 'quote') INTO v_sequence;
    
    -- Format: QT-{prefix}-{sequence:04d}
    RETURN 'QT-' || v_org_prefix || '-' || lpad(v_sequence::TEXT, 4, '0');
END;
$$ LANGUAGE plpgsql;

-- Generate invoice number function
CREATE OR REPLACE FUNCTION generate_invoice_number(p_org_id UUID)
RETURNS TEXT AS $$
DECLARE
    v_org_prefix TEXT;
    v_sequence INTEGER;
BEGIN
    SELECT org_prefix INTO v_org_prefix
    FROM organizations WHERE id = p_org_id;
    
    IF v_org_prefix IS NULL THEN
        RAISE EXCEPTION 'Organization prefix not found for org_id: %', p_org_id;
    END IF;
    
    SELECT get_next_sequence(p_org_id, 'invoice') INTO v_sequence;
    
    RETURN 'INV-' || v_org_prefix || '-' || lpad(v_sequence::TEXT, 4, '0');
END;
$$ LANGUAGE plpgsql;

-- Generate job number function
CREATE OR REPLACE FUNCTION generate_job_number(p_org_id UUID)
RETURNS TEXT AS $$
DECLARE
    v_org_prefix TEXT;
    v_sequence INTEGER;
BEGIN
    SELECT org_prefix INTO v_org_prefix
    FROM organizations WHERE id = p_org_id;
    
    IF v_org_prefix IS NULL THEN
        RAISE EXCEPTION 'Organization prefix not found for org_id: %', p_org_id;
    END IF;
    
    SELECT get_next_sequence(p_org_id, 'job') INTO v_sequence;
    
    RETURN 'JOB-' || v_org_prefix || '-' || lpad(v_sequence::TEXT, 4, '0');
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- Row Level Security (RLS) - Enable on all tables
-- ============================================
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE visits ENABLE ROW LEVEL SECURITY;
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE billing_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE quotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE line_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_interaction_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE visit_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE visit_signatures ENABLE ROW LEVEL SECURITY;
ALTER TABLE employee_invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE quote_approvals ENABLE ROW LEVEL SECURITY;
ALTER TABLE sequence_counters ENABLE ROW LEVEL SECURITY;

-- ============================================
-- RLS Policies (Basic - Full policies in separate migration)
-- ============================================
-- Note: Comprehensive RLS policies will be added in a separate migration file
-- for better organization and maintainability.

-- Basic org-level isolation policy (applied to all tables)
-- Full role-based and channel-based policies will be implemented in Phase 2

-- Example: Users can only see their own org's data
CREATE POLICY "Users can view their org data"
ON organizations FOR SELECT
TO authenticated
USING (
    id IN (SELECT org_id FROM users WHERE id = auth.uid())
);

-- Similar basic policies will be added for all tables
-- Full implementation continues in next migration...
