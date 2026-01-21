-- Add professional fields to quotes table
ALTER TABLE quotes 
ADD COLUMN IF NOT EXISTS notes TEXT,
ADD COLUMN IF NOT EXISTS terms TEXT,
ADD COLUMN IF NOT EXISTS expiration_date TIMESTAMPTZ;
