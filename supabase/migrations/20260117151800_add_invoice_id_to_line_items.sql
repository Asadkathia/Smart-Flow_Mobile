-- Add invoice_id column to line_items table to support invoice line items
ALTER TABLE line_items 
ADD COLUMN IF NOT EXISTS invoice_id UUID REFERENCES invoices(id) ON DELETE CASCADE;

-- Make quote_id nullable since line items can belong to either quotes or invoices
ALTER TABLE line_items 
ALTER COLUMN quote_id DROP NOT NULL;

-- Add check constraint to ensure line item belongs to either quote or invoice (not both, not neither)
ALTER TABLE line_items
ADD CONSTRAINT line_items_parent_check 
CHECK (
  (quote_id IS NOT NULL AND invoice_id IS NULL) OR 
  (quote_id IS NULL AND invoice_id IS NOT NULL)
);

-- Create index for invoice_id lookups
CREATE INDEX IF NOT EXISTS idx_line_items_invoice_id ON line_items(invoice_id);
