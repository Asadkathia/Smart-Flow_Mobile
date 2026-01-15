-- ============================================
-- Auto-Create User Profiles for New Auth Users
-- ============================================
-- 
-- This migration creates a trigger function that automatically creates
-- a user profile in public.users when a new auth user is created.
-- 
-- This prevents the 401 errors caused by auth users without profiles.
-- 
-- NOTE: This requires the user's metadata to include:
-- - org_id: The organization ID
-- - role: The user's role (admin, dispatcher, accountant, technician)
-- - full_name: The user's full name
-- 
-- For signup, these should be set during registration.
-- ============================================

-- Create function to handle new user creation
CREATE OR REPLACE FUNCTION public.handle_new_auth_user()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
  v_org_id UUID;
  v_role user_role;
  v_full_name TEXT;
BEGIN
  -- Extract metadata from auth user
  -- During signup, the app should set these in user_metadata or app_metadata
  v_org_id := COALESCE(
    (NEW.raw_app_metadata->>'org_id')::UUID,
    (NEW.raw_user_metadata->>'org_id')::UUID
  );
  
  v_role := COALESCE(
    (NEW.raw_app_metadata->>'role')::user_role,
    (NEW.raw_user_metadata->>'role')::user_role,
    'technician'::user_role  -- Default to technician if not specified
  );
  
  v_full_name := COALESCE(
    NEW.raw_user_metadata->>'full_name',
    NEW.raw_app_metadata->>'full_name',
    split_part(NEW.email, '@', 1)  -- Fallback to email username
  );

  -- Only create profile if org_id is provided
  IF v_org_id IS NOT NULL THEN
    -- Insert user profile
    INSERT INTO public.users (
      id,
      org_id,
      full_name,
      email,
      phone,
      role,
      status
    ) VALUES (
      NEW.id,
      v_org_id,
      v_full_name,
      NEW.email,
      NEW.phone,
      v_role,
      'active'
    )
    ON CONFLICT (id) DO UPDATE SET
      email = EXCLUDED.email,
      phone = EXCLUDED.phone,
      updated_at = now();
  END IF;

  RETURN NEW;
END;
$$;

-- Create trigger on auth.users table
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_auth_user();

-- ============================================
-- NOTES:
-- ============================================
-- 1. This trigger only creates profiles for users with org_id in metadata
-- 2. For existing users without profiles, run FIX_TEST_USER.sql
-- 3. The signup process must set user_metadata or app_metadata
-- 4. Default role is 'technician' if not specified
-- ============================================
