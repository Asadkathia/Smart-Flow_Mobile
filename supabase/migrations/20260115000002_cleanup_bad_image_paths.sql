-- Clean up bad image_path data
-- Date: 2026-01-15
-- This removes image paths that point to non-existent files or have the string 'null'

-- Set image_path to NULL for items with string 'null' or invalid paths
UPDATE inventory_items 
SET image_path = NULL 
WHERE image_path = 'null' 
   OR image_path LIKE '%75484b74-e882-4ec6-96ec-9871739fe133%';

-- Also clean up the specific problematic item
UPDATE inventory_items 
SET image_path = NULL 
WHERE id = 'b3c44d35-ed99-4724-b3e9-395bb9212a58';
