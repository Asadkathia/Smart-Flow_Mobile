-- ============================================
-- Storage Buckets Configuration
-- Creates buckets and policies for SmartFlowPro
-- ============================================

-- Create storage buckets
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES 
  ('visits', 'visits', false, 104857600, ARRAY['image/jpeg', 'image/png', 'image/webp', 'video/mp4', 'video/quicktime', 'application/pdf']),
  ('inventory', 'inventory', false, 10485760, ARRAY['image/jpeg', 'image/png', 'image/webp']),
  ('signatures', 'signatures', false, 5242880, ARRAY['image/jpeg', 'image/png', 'image/webp'])
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- Storage Policies: Visits Bucket
-- ============================================

-- Technicians can upload visit media to their org folder
CREATE POLICY "Technicians can upload visit media"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'visits'
    AND (storage.foldername(name))[1] IN (
        SELECT org_id::text FROM users WHERE id = auth.uid()
    )
    AND (storage.foldername(name))[2] = 'visits'
);

-- Technicians can read visit media from their org
CREATE POLICY "Technicians can read visit media"
ON storage.objects FOR SELECT
TO authenticated
USING (
    bucket_id = 'visits'
    AND (storage.foldername(name))[1] IN (
        SELECT org_id::text FROM users WHERE id = auth.uid()
    )
);

-- Admins can delete visit media
CREATE POLICY "Admins can delete visit media"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'visits'
    AND (storage.foldername(name))[1] IN (
        SELECT org_id::text FROM users WHERE id = auth.uid()
    )
    AND EXISTS (
        SELECT 1 FROM users
        WHERE id = auth.uid()
        AND role = 'admin'
    )
);

-- ============================================
-- Storage Policies: Inventory Bucket
-- ============================================

-- Technicians can upload inventory images to their org folder
CREATE POLICY "Technicians can upload inventory images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'inventory'
    AND (storage.foldername(name))[1] IN (
        SELECT org_id::text FROM users WHERE id = auth.uid()
    )
);

-- Users can read inventory images from their org
CREATE POLICY "Users can read inventory images"
ON storage.objects FOR SELECT
TO authenticated
USING (
    bucket_id = 'inventory'
    AND (storage.foldername(name))[1] IN (
        SELECT org_id::text FROM users WHERE id = auth.uid()
    )
);

-- ============================================
-- Storage Policies: Signatures Bucket
-- ============================================

-- Technicians can upload signatures to their org folder
CREATE POLICY "Technicians can upload signatures"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'signatures'
    AND (storage.foldername(name))[1] IN (
        SELECT org_id::text FROM users WHERE id = auth.uid()
    )
    AND (storage.foldername(name))[2] = 'visits'
);

-- Users can read signatures from their org
CREATE POLICY "Users can read signatures"
ON storage.objects FOR SELECT
TO authenticated
USING (
    bucket_id = 'signatures'
    AND (storage.foldername(name))[1] IN (
        SELECT org_id::text FROM users WHERE id = auth.uid()
    )
);
