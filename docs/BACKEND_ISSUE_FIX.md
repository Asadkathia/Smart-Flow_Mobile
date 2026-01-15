# Backend Loading Issue - Root Cause & Fix

## Problem Summary

The backend API calls were failing with 401 errors despite successful authentication. The app would login successfully but fail to load any data.

## Root Cause Analysis

### The Issue
1. **Auth User Exists**: `test@example.com` exists in Supabase Auth (`auth.users`) with ID `82cf187c-c444-434a-9a65-3018b1b3369d`
2. **Missing User Profile**: No corresponding record exists in `public.users` table
3. **Edge Function Validation Fails**: 
   - Edge functions use `authGuard` which validates:
     - JWT token (✅ passes)
     - User profile exists in `public.users` (❌ fails)
     - User has correct role and org_id (❌ can't check without profile)
   - Returns 401 when profile lookup fails

### Why This Happened
- Test data migration created user with email `test.technician@example.com`
- App/user logged in with `test@example.com`
- No automatic profile creation for auth users
- Mismatch between auth user and database profile

## The Fix

### Immediate Fix (Manual)

Run the SQL script in Supabase Dashboard:

1. Go to Supabase Dashboard → SQL Editor
2. Open `/supabase/FIX_TEST_USER.sql`
3. Execute the script

This will:
- Create user profile for `test@example.com`
- Link to test organization
- Assign technician role
- Update related data (visits, inventory)

### Long-term Fix (Automatic)

Migration `20260111000001_auto_create_user_profiles.sql` adds a database trigger that:
- Automatically creates user profiles when auth users are created
- Reads metadata from auth user (org_id, role, full_name)
- Prevents future profile mismatches

## How to Apply the Fix

### Option 1: Using Supabase CLI (Recommended)
```bash
cd /Users/asadkathia/Desktop/smartflowpro

# Apply the migration (requires database password)
supabase db push --linked

# Or apply specific migration
supabase migration up --linked
```

### Option 2: Using Supabase Dashboard (Manual)
1. Open Supabase Dashboard: https://supabase.com/dashboard/project/pbqbsdmwbjpsvxuuwjiv
2. Go to SQL Editor
3. Create new query
4. Copy and paste contents of `supabase/FIX_TEST_USER.sql`
5. Click "Run"
6. Verify the output shows successful inserts

### Option 3: Using Database URL
```bash
# Set your database password
export PGPASSWORD="your-database-password"

# Apply migration
psql -h aws-1-ap-northeast-1.pooler.supabase.com \
     -U postgres.pbqbsdmwbjpsvxuuwjiv \
     -d postgres \
     -f supabase/FIX_TEST_USER.sql
```

## Verification

After applying the fix, verify it worked:

1. **Check User Profile**:
   ```sql
   SELECT id, email, role, status, org_id 
   FROM public.users 
   WHERE email = 'test@example.com';
   ```
   Should return 1 row with:
   - ID: `82cf187c-c444-434a-9a65-3018b1b3369d`
   - Role: `technician`
   - Status: `active`
   - Org ID: `00000000-0000-0000-0000-000000000001`

2. **Test Edge Function**:
   ```bash
   # Get your JWT token from the app logs or Supabase dashboard
   curl -X GET \
     'https://pbqbsdmwbjpsvxuuwjiv.supabase.co/functions/v1/tech-visits-today' \
     -H 'Authorization: Bearer YOUR_JWT_TOKEN' \
     -H 'X-Channel: mobile_technician' \
     -H 'apikey: YOUR_ANON_KEY'
   ```
   Should return 200 with visits data (not 401)

3. **Test in App**:
   - Restart the Flutter app
   - Login with `test@example.com`
   - Navigate to home screen
   - Verify visits load successfully
   - Check chat, inventory tabs load data

## Prevention for Future

### For New Auth Users
The trigger `handle_new_auth_user()` will automatically create profiles IF:
- `org_id` is set in user metadata during signup
- `role` is set in user metadata (defaults to 'technician')
- `full_name` is set in user metadata (falls back to email)

### For Signup Process
Ensure the signup edge function sets metadata:

```typescript
// In auth-signup edge function
const { data: authData, error: authError } = await supabase.auth.signUp({
  email: email,
  password: password,
  options: {
    data: {
      full_name: fullName,
      org_id: orgId,
      role: 'technician'
    }
  }
});
```

### For Manual User Creation
When creating users manually in Supabase Dashboard:
1. Create auth user in Auth → Users
2. Immediately create profile in SQL Editor:
   ```sql
   INSERT INTO public.users (id, org_id, full_name, email, role, status)
   VALUES (
     '<auth-user-id>',
     '<org-id>',
     'Full Name',
     'user@example.com',
     'technician',
     'active'
   );
   ```

## Edge Function Authentication Flow

For reference, here's how edge functions validate requests:

```
1. Request arrives with JWT token
   ↓
2. authGuard validates JWT with Supabase Auth
   ✅ Valid JWT → Continue
   ❌ Invalid JWT → 401 UNAUTHORIZED
   ↓
3. authGuard queries public.users for profile
   ✅ Profile found → Continue
   ❌ Profile missing → 401 UNAUTHORIZED (THIS WAS THE ISSUE)
   ↓
4. Check user status is 'active'
   ✅ Active → Continue
   ❌ Not active → 403 FORBIDDEN
   ↓
5. Check user role matches required role
   ✅ Role matches → Continue
   ❌ Role mismatch → 403 FORBIDDEN
   ↓
6. Check channel header matches
   ✅ Channel valid → Continue
   ❌ Channel invalid → 403 FORBIDDEN
   ↓
7. Return AuthContext with userId, orgId, role, channel
   ↓
8. Edge function executes business logic
```

## Related Files

- **Fix Script**: `/supabase/FIX_TEST_USER.sql`
- **Migration**: `/supabase/migrations/20260111000001_auto_create_user_profiles.sql`
- **Auth Guard**: `/supabase/functions/_shared/auth_guard.ts`
- **Test Data**: `/supabase/migrations/20260110140000_test_data_minimal.sql`

## Testing Checklist

- [ ] FIX_TEST_USER.sql executed successfully
- [ ] Auto-create trigger migration applied
- [ ] User profile exists in public.users
- [ ] App login works with test@example.com
- [ ] Home screen loads visits
- [ ] Chat tab loads messages
- [ ] Inventory tab loads items
- [ ] No 401 errors in logs
- [ ] Token refresh works correctly

## Troubleshooting

### Still Getting 401 Errors?

1. **Check user profile exists**:
   ```sql
   SELECT * FROM public.users WHERE email = 'test@example.com';
   ```

2. **Check auth user UUID matches**:
   ```sql
   SELECT id, email FROM auth.users WHERE email = 'test@example.com';
   ```
   Compare with `public.users.id`

3. **Check user status**:
   ```sql
   SELECT status FROM public.users WHERE email = 'test@example.com';
   ```
   Must be 'active'

4. **Check org_id**:
   ```sql
   SELECT org_id FROM public.users WHERE email = 'test@example.com';
   ```
   Must not be NULL

5. **Check role**:
   ```sql
   SELECT role FROM public.users WHERE email = 'test@example.com';
   ```
   Must be 'technician' for mobile app

### Still Having Issues?

- Check edge function logs: `supabase functions logs tech-visits-today --linked`
- Enable debug logging in app: Set `DEBUG=true` in environment
- Check app logs for detailed error messages
- Verify JWT token is being sent correctly
- Check X-Channel header is set to 'mobile_technician'

## Summary

**Problem**: Auth user without database profile  
**Cause**: Manual auth user creation without profile  
**Fix**: Run FIX_TEST_USER.sql + apply auto-create trigger  
**Prevention**: Trigger automatically creates profiles for new users  

The backend should now work correctly! 🎉
