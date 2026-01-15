# SmartFlowPro Backend Deployment Guide

**Project**: SmartFlowPro  
**Project Ref**: `pbqbsdmwbjpsvxuuwjiv`  
**Date**: January 8, 2026

## Prerequisites

- Supabase CLI installed (`supabase --version`)
- Logged in to Supabase CLI (`supabase login`)
- Project linked (`supabase link --project-ref pbqbsdmwbjpsvxuuwjiv`)
- Flutter SDK installed
- Dart SDK installed

## Step 1: Get Supabase API Keys

1. Go to [Supabase Dashboard](https://supabase.com/dashboard/project/pbqbsdmwbjpsvxuuwjiv)
2. Navigate to **Settings** → **API**
3. Copy the following:
   - **Project URL**: `https://pbqbsdmwbjpsvxuuwjiv.supabase.co`
   - **Anon Key**: (public key, safe for mobile app)
   - **Service Role Key**: (backend only, NEVER expose in mobile app)

## Step 2: Apply Database Migrations

```bash
cd /Users/asadkathia/Desktop/smartflowpro

# Review migrations
ls -la supabase/migrations/

# Apply all migrations to production
supabase db push --project-ref pbqbsdmwbjpsvxuuwjiv
```

**Migrations to apply:**
1. `20260108190902_initial_schema.sql` - All 23 tables
2. `20260108190959_rls_policies.sql` - Row-level security policies
3. `20260108191446_storage_buckets.sql` - Storage buckets and policies

## Step 3: Deploy Edge Functions

```bash
# Deploy individual functions
supabase functions deploy tech-visits-today --project-ref pbqbsdmwbjpsvxuuwjiv
supabase functions deploy tech-visits-start --project-ref pbqbsdmwbjpsvxuuwjiv
supabase functions deploy tech-quotes-create --project-ref pbqbsdmwbjpsvxuuwjiv
supabase functions deploy tech-quotes-finalize --project-ref pbqbsdmwbjpsvxuuwjiv
supabase functions deploy tech-visits-media-upload-url --project-ref pbqbsdmwbjpsvxuuwjiv
supabase functions deploy tech-visits-media-confirm --project-ref pbqbsdmwbjpsvxuuwjiv

# Or deploy all at once (if all functions are ready)
# supabase functions deploy --all --project-ref pbqbsdmwbjpsvxuuwjiv
```

## Step 4: Set Edge Function Secrets

```bash
# Set service role key (required for Edge Functions to access database)
supabase secrets set --project-ref pbqbsdmwbjpsvxuuwjiv \
  SUPABASE_SERVICE_ROLE_KEY=<your-service-role-key>

# Set OpenAI API key (required for AI features)
supabase secrets set --project-ref pbqbsdmwbjpsvxuuwjiv \
  OPENAI_API_KEY=<your-openai-key>

# Optional: Set web search API key (for AI web search feature)
# supabase secrets set --project-ref pbqbsdmwbjpsvxuuwjiv \
#   BRAVE_SEARCH_API_KEY=<your-brave-key>
# OR
# supabase secrets set --project-ref pbqbsdmwbjpsvxuuwjiv \
#   SERP_API_KEY=<your-serp-key>
```

## Step 5: Configure Flutter App

### Option A: Environment Variables (Recommended for Production)

Create a `.env` file (DO NOT commit to git):
```env
SUPABASE_URL=https://pbqbsdmwbjpsvxuuwjiv.supabase.co
SUPABASE_ANON_KEY=<your-anon-key>
ENVIRONMENT=production
```

Run app with:
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://pbqbsdmwbjpsvxuuwjiv.supabase.co \
  --dart-define=SUPABASE_define=SUPABASE_ANON_KEY=<your-anon-key> \
  --dart-define=ENVIRONMENT=production
```

### Option B: Update SupabaseConfig Directly (Development Only)

**⚠️ WARNING**: Only for development. Never commit API keys to git.

Update `lib/core/config/supabase_config.dart`:
```dart
static String get supabaseUrl {
  return 'https://pbqbsdmwbjpsvxuuwjiv.supabase.co';
}

static String get supabaseAnonKey {
  return '<your-anon-key>';
}
```

## Step 6: Test Authentication Flow

1. **Create a test user** (via Supabase Dashboard or Edge Function):
   - Go to Supabase Dashboard → Authentication → Users
   - Create a user with email/password
   - Note the user ID

2. **Create user profile** in database:
   ```sql
   INSERT INTO users (id, org_id, full_name, email, role, status)
   VALUES (
     '<user-id-from-auth>',
     '<org-id>',
     'Test Technician',
     'test@example.com',
     'technician',
     'active'
   );
   ```

3. **Test login** in Flutter app:
   - Run app
   - Enter test user credentials
   - Verify login succeeds

## Step 7: Verify Edge Functions

### Test `tech-visits-today`:
```bash
curl -X GET \
  'https://pbqbsdmwbjpsvxuuwjiv.supabase.co/functions/v1/tech-visits-today' \
  -H 'Authorization: Bearer <jwt-token>' \
  -H 'X-Channel: mobile_technician'
```

### Test `tech-visits-start`:
```bash
curl -X POST \
  'https://pbqbsdmwbjpsvxuuwjiv.supabase.co/functions/v1/tech-visits-start' \
  -H 'Authorization: Bearer <jwt-token>' \
  -H 'X-Channel: mobile_technician' \
  -H 'Content-Type: application/json' \
  -d '{"visit_id": "<visit-id>"}'
```

## Step 8: Verify Storage Buckets

```bash
# List buckets
supabase storage ls --project-ref pbqbsdmwbjpsvxuuwjiv

# Verify buckets exist:
# - visits
# - inventory
# - signatures
```

## Step 9: Enable Realtime (Optional)

Realtime is enabled by default in Supabase. Verify in dashboard:
- Go to **Database** → **Replication**
- Ensure tables have replication enabled:
  - `visits`
  - `chat_messages`
  - `quotes`

## Troubleshooting

### Migration Errors
```bash
# Check migration status
supabase migration list --project-ref pbqbsdmwbjpsvxuuwjiv

# Rollback last migration if needed
supabase migration revert --project-ref pbqbsdmwbjpsvxuuwjiv
```

### Edge Function Errors
```bash
# View function logs
supabase functions logs tech-visits-today --project-ref pbqbsdmwbjpsvxuuwjiv

# Test function locally (requires Docker)
supabase functions serve tech-visits-today
```

### Authentication Issues
- Verify JWT token is valid
- Check user status is 'active'
- Verify user role is 'technician' for mobile app
- Check channel header is 'mobile_technician'

## Next Steps

1. Create test organization and users
2. Create test visits and quotes
3. Test end-to-end flows:
   - Login → View visits → Start visit → Add notes → Complete visit
   - Create quote → Add line items → Finalize quote
   - Upload media → Verify storage
4. Monitor Edge Function logs for errors
5. Set up monitoring and alerts

## Production Checklist

- [ ] All migrations applied
- [ ] All Edge Functions deployed
- [ ] Secrets configured
- [ ] Storage buckets created
- [ ] RLS policies tested
- [ ] Authentication tested
- [ ] Realtime subscriptions tested
- [ ] Error monitoring configured
- [ ] Backup schedule configured
- [ ] Documentation updated
