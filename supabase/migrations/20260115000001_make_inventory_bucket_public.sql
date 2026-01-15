-- Make inventory bucket public
-- Date: 2026-01-15
-- This allows inventory images to be accessed via public URLs without authentication

UPDATE storage.buckets 
SET public = true 
WHERE id = 'inventory';
