-- Add category and description columns to inventory_items table
-- Date: 2026-01-15

ALTER TABLE public.inventory_items 
ADD COLUMN IF NOT EXISTS category TEXT,
ADD COLUMN IF NOT EXISTS description TEXT;

-- Create index on category for faster filtering
CREATE INDEX IF NOT EXISTS idx_inventory_items_category ON inventory_items(category) WHERE category IS NOT NULL;

-- Add comment for documentation
COMMENT ON COLUMN inventory_items.category IS 'Item category for grouping and filtering (e.g., HVAC Parts, Plumbing, Electrical)';
COMMENT ON COLUMN inventory_items.description IS 'Detailed description of the inventory item';
