-- Update line_items RLS policies to support both quote and invoice line items

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view quote line items" ON line_items;
DROP POLICY IF EXISTS "Technicians can manage line items" ON line_items;

-- Create updated SELECT policy for both quote and invoice line items
CREATE POLICY "Users can view line items"
ON line_items FOR SELECT
TO authenticated
USING (
    org_id = get_user_org_id()
    AND (
        -- Line items belonging to quotes
        (quote_id IS NOT NULL AND EXISTS (
            SELECT 1 FROM quotes 
            WHERE quotes.id = line_items.quote_id
        ))
        OR
        -- Line items belonging to invoices
        (invoice_id IS NOT NULL AND EXISTS (
            SELECT 1 FROM invoices 
            WHERE invoices.id = line_items.invoice_id
        ))
    )
);

-- Create updated INSERT/UPDATE/DELETE policy for technicians
CREATE POLICY "Technicians can manage line items"
ON line_items FOR ALL
TO authenticated
USING (
    org_id = get_user_org_id()
    AND (
        -- For quote line items: must be draft quote owned by technician
        (quote_id IS NOT NULL AND EXISTS (
            SELECT 1 FROM quotes 
            WHERE quotes.id = line_items.quote_id
            AND quotes.status = 'draft'
            AND EXISTS (
                SELECT 1 FROM visits 
                WHERE visits.id = quotes.visit_id 
                AND visits.technician_id = auth.uid()
            )
        ))
        OR
        -- For invoice line items: must be draft invoice owned by technician
        (invoice_id IS NOT NULL AND EXISTS (
            SELECT 1 FROM invoices 
            WHERE invoices.id = line_items.invoice_id
            AND invoices.status = 'draft'
            AND EXISTS (
                SELECT 1 FROM visits 
                WHERE visits.id = invoices.visit_id 
                AND visits.technician_id = auth.uid()
            )
        ))
    )
)
WITH CHECK (
    org_id = get_user_org_id()
    AND (
        -- For quote line items: must be draft quote
        (quote_id IS NOT NULL AND EXISTS (
            SELECT 1 FROM quotes 
            WHERE quotes.id = line_items.quote_id
            AND quotes.status = 'draft'
        ))
        OR
        -- For invoice line items: must be draft invoice
        (invoice_id IS NOT NULL AND EXISTS (
            SELECT 1 FROM invoices 
            WHERE invoices.id = line_items.invoice_id
            AND invoices.status = 'draft'
        ))
    )
);
