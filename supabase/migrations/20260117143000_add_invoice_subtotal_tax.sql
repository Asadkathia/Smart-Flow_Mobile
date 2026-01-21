-- Migration to add subtotal and tax_amount to invoices table
-- to match InvoiceModel and provide parity with quotes table.

ALTER TABLE public.invoices 
ADD COLUMN IF NOT EXISTS subtotal NUMERIC NOT NULL DEFAULT 0 CHECK (subtotal >= 0),
ADD COLUMN IF NOT EXISTS tax_amount NUMERIC NOT NULL DEFAULT 0 CHECK (tax_amount >= 0);

-- Update existing invoices if any (optional, but good for consistency)
UPDATE public.invoices i
SET 
  subtotal = q.subtotal,
  tax_amount = q.tax_total
FROM public.quotes q
WHERE i.quote_id = q.id 
AND i.subtotal = 0 
AND i.tax_amount = 0;
