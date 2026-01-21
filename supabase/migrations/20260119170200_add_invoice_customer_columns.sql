-- Add missing columns to invoices table for customer information and notes
-- These columns are needed by the mobile app to store customer details from visit

-- Customer information columns
ALTER TABLE invoices ADD COLUMN IF NOT EXISTS customer_name TEXT;
ALTER TABLE invoices ADD COLUMN IF NOT EXISTS customer_email TEXT;
ALTER TABLE invoices ADD COLUMN IF NOT EXISTS customer_phone TEXT;
ALTER TABLE invoices ADD COLUMN IF NOT EXISTS property_address TEXT;
ALTER TABLE invoices ADD COLUMN IF NOT EXISTS visit_title TEXT;

-- Notes and dates
ALTER TABLE invoices ADD COLUMN IF NOT EXISTS notes TEXT;
ALTER TABLE invoices ADD COLUMN IF NOT EXISTS due_date TIMESTAMPTZ;
ALTER TABLE invoices ADD COLUMN IF NOT EXISTS paid_at TIMESTAMPTZ;

-- Create indexes for common queries
CREATE INDEX IF NOT EXISTS idx_invoices_due_date ON invoices(due_date) WHERE due_date IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_invoices_paid_at ON invoices(paid_at) WHERE paid_at IS NOT NULL;
