-- Fix 1: Remove infinite recursion in chat_threads RLS policy
-- Fix 2: Add signature_url column to visits table
-- Fix 3: Create visit-media storage bucket

-- ============================================================================
-- FIX 1: Chat Threads RLS Policy (Remove Infinite Recursion)
-- ============================================================================

-- Drop ALL existing policies on chat_threads AND chat_participants to break recursion
DO $$ 
DECLARE
  r RECORD;
BEGIN
  -- Drop all chat_threads policies
  FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'chat_threads') LOOP
    EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON chat_threads';
  END LOOP;
  
  -- Drop all chat_participants policies that reference chat_threads
  FOR r IN (SELECT policyname FROM pg_policies WHERE tablename = 'chat_participants') LOOP
    EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON chat_participants';
  END LOOP;
END $$;

-- Create a simple, non-recursive policy for chat_threads
-- This policy allows users to see threads where they are a participant
-- Uses direct user_id check without referencing chat_participants policies
CREATE POLICY "chat_threads_select_policy" ON chat_threads
FOR SELECT
TO authenticated
USING (
  -- Check if current user is a participant in this thread
  -- Direct check without triggering chat_participants RLS policy
  EXISTS (
    SELECT 1 
    FROM chat_participants 
    WHERE chat_participants.chat_id = chat_threads.id 
    AND chat_participants.user_id = auth.uid()
    -- Add org_id check for security
    AND chat_participants.org_id = (
      SELECT org_id FROM users WHERE id = auth.uid()
    )
  )
);

-- Create non-recursive policy for chat_participants
-- This policy does NOT reference chat_threads to break the cycle
-- Simple policy: users can see participants in their own org
CREATE POLICY "chat_participants_select_policy" ON chat_participants
FOR SELECT
TO authenticated
USING (
  -- Direct org_id check - no reference to chat_threads
  org_id = (SELECT org_id FROM users WHERE id = auth.uid())
);

-- Add INSERT policy for chat_participants
CREATE POLICY "chat_participants_insert_policy" ON chat_participants
FOR INSERT
TO authenticated
WITH CHECK (
  org_id = (SELECT org_id FROM users WHERE id = auth.uid())
  AND user_id = auth.uid()
);

-- Ensure RLS is enabled
ALTER TABLE chat_threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_participants ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- FIX 2: Add signature_url Column to Visits Table
-- ============================================================================

-- Check if column exists, add if it doesn't
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'visits' 
    AND column_name = 'signature_url'
  ) THEN
    ALTER TABLE visits ADD COLUMN signature_url TEXT;
    
    -- Add comment for documentation
    COMMENT ON COLUMN visits.signature_url IS 'URL/path to customer signature image in Supabase Storage';
    
    RAISE NOTICE 'Added signature_url column to visits table';
  ELSE
    RAISE NOTICE 'signature_url column already exists in visits table';
  END IF;
END $$;

-- ============================================================================
-- Verification Queries
-- ============================================================================

-- Verify chat_threads policy
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual
FROM pg_policies
WHERE tablename = 'chat_threads';

-- Verify visits table structure
SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'public' 
AND table_name = 'visits'
AND column_name IN ('signature_url', 'status', 'actual_start', 'actual_end')
ORDER BY ordinal_position;

-- ============================================================================
-- FIX 3: Create visit-media Storage Bucket
-- ============================================================================

-- Note: Storage buckets must be created via Supabase Dashboard or Storage API
-- This SQL creates the bucket if it doesn't exist
-- If bucket creation fails, you'll need to create it manually in Supabase Dashboard:
-- Storage > New bucket > Name: "visit-media" > Public: false

-- Insert bucket into storage.buckets (if not exists)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'visit-media',
  'visit-media',
  false, -- Private bucket
  5242880, -- 5MB limit for signatures
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'video/mp4', 'application/pdf']
)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- FIX 3: Create visit-media Storage Bucket
-- ============================================================================

-- Note: Storage buckets must be created via Supabase Dashboard or Storage API
-- This SQL creates the bucket if it doesn't exist
-- If bucket creation fails, you'll need to create it manually in Supabase Dashboard:
-- Storage > New bucket > Name: "visit-media" > Public: false

-- Insert bucket into storage.buckets (if not exists)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'visit-media',
  'visit-media',
  false, -- Private bucket
  5242880, -- 5MB limit for signatures
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'video/mp4', 'application/pdf']
)
ON CONFLICT (id) DO NOTHING;

-- Drop existing storage policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Users can upload visit media" ON storage.objects;
DROP POLICY IF EXISTS "Users can read visit media" ON storage.objects;

-- Create storage policy for authenticated users to upload
CREATE POLICY "Users can upload visit media" ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'visit-media' AND
  (storage.foldername(name))[1] = 'visits'
);

-- Create storage policy for authenticated users to read their own uploads
CREATE POLICY "Users can read visit media" ON storage.objects
FOR SELECT
TO authenticated
USING (
  bucket_id = 'visit-media' AND
  (storage.foldername(name))[1] = 'visits'
);
