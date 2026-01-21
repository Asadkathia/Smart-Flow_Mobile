-- ============================================
-- Migration: Add Version Fields for Conflict Detection
-- Date: 2026-01-19
-- Purpose: Add version columns to notes and inventory_items
--          to support optimistic locking and conflict detection
-- ============================================

-- Add version column to notes table
ALTER TABLE public.notes
ADD COLUMN IF NOT EXISTS version INTEGER DEFAULT 1 NOT NULL;

-- Add version column to inventory_items table
ALTER TABLE public.inventory_items
ADD COLUMN IF NOT EXISTS version INTEGER DEFAULT 1 NOT NULL;

-- Create index for efficient version checks
CREATE INDEX IF NOT EXISTS idx_notes_version ON notes(id, version);
CREATE INDEX IF NOT EXISTS idx_inventory_items_version ON inventory_items(id, version);

-- Create trigger function to auto-increment version on update
CREATE OR REPLACE FUNCTION increment_version()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version := OLD.version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to notes table
DROP TRIGGER IF EXISTS notes_version_trigger ON notes;
CREATE TRIGGER notes_version_trigger
BEFORE UPDATE ON notes
FOR EACH ROW
EXECUTE FUNCTION increment_version();

-- Apply trigger to inventory_items table
DROP TRIGGER IF EXISTS inventory_items_version_trigger ON inventory_items;
CREATE TRIGGER inventory_items_version_trigger
BEFORE UPDATE ON inventory_items
FOR EACH ROW
EXECUTE FUNCTION increment_version();

-- ============================================
-- Verification query (comment out for migration)
-- ============================================
-- SELECT 
--     table_name,
--     column_name,
--     data_type
-- FROM information_schema.columns 
-- WHERE table_name IN ('notes', 'inventory_items') 
--   AND column_name = 'version';
