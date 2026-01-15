# 🔧 Backend Fix Checklist

## ⚠️ Issue
App fails to load data - all API calls returning empty or errors

## ✅ Root Cause  
Test data uses wrong user ID (`13f79aef...` instead of `82cf187c...`)

## 🎯 Solution (5 minutes)

### Step 1: Open Supabase Dashboard
- [ ] Go to: https://supabase.com/dashboard/project/pbqbsdmwbjpsvxuuwjiv/sql
- [ ] Click **"New query"** button

### Step 2: Run Fix Script
- [ ] Open file: `supabase/FIX_ALL_DATA.sql`
- [ ] Copy ALL content (Cmd+A, Cmd+C)
- [ ] Paste into SQL Editor
- [ ] Click **"Run"** (or Cmd+Enter)

### Step 3: Verify Results
At the bottom of SQL output, you should see:

```
CHECK_TYPE      | VALUE
----------------|------------------
USER PROFILE    | test@example.com, role=technician, status=active
VISITS TODAY    | 2 visits, 2 scheduled
INVENTORY ITEMS | 3 items, 3 active
CHAT THREADS    | 0 threads (normal - empty at start)
```

If you see these results: ✅ **Database is fixed!**

### Step 4: Rebuild & Test App
```bash
flutter run --device-id=521454CD-4748-415C-B573-C147AAB6F57D \
  --dart-define=SUPABASE_URL=https://pbqbsdmwbjpsvxuuwjiv.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBicWJzZG13Ympwc3Z4dXV3aml2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc4ODc4NjEsImV4cCI6MjA4MzQ2Mzg2MX0.B8nBfimuhwOINBw-y9n2tj0EwcbBP5rEyx8JaY77jcI \
  --dart-define=ENVIRONMENT=production \
  --dart-define=USE_MOCK_DATA=false
```

### Step 5: Verify App Works
- [ ] Login with:
  - Email: `test@example.com`
  - Password: `Test123456!`
- [ ] Home screen shows **2 visits** for today
- [ ] Inventory tab shows **3 items**
- [ ] AI assistant responds to questions
- [ ] Chat loads (empty list is normal)

## 📁 Files Created

- ✅ `supabase/FIX_ALL_DATA.sql` - **RUN THIS SCRIPT**
- 📄 `DATABASE_FIX_INSTRUCTIONS.md` - Detailed guide
- 📄 `ROOT_CAUSE_ANALYSIS.md` - Technical analysis
- 📄 `FIX_CHECKLIST.md` - This file

## 🐛 What Was Wrong?

```
❌ Before Fix:
- Auth user:  82cf187c-c444-434a-9a65-3018b1b3369d (test@example.com)
- Test data:  13f79aef-96b3-4295-9fee-262ec6bc35c3 (test.technician@example.com)
- Result:     All queries return empty (user ID mismatch)

✅ After Fix:
- Auth user:  82cf187c-c444-434a-9a65-3018b1b3369d (test@example.com)
- Test data:  82cf187c-c444-434a-9a65-3018b1b3369d (updated)
- Result:     Queries return data for correct user
```

## ❓ Troubleshooting

### If SQL fails:
1. Check you're logged into correct Supabase project
2. Verify project ref: `pbqbsdmwbjpsvxuuwjiv`
3. Try copying script in smaller chunks

### If app still fails:
1. Check Edge Function logs: https://supabase.com/dashboard/project/pbqbsdmwbjpsvxuuwjiv/functions
2. Look for 401/403 errors (auth issue)
3. Look for 500 errors (database query issue)
4. Verify user profile in public.users table

### If no visits show:
1. Visits are created for "today" - check timezone
2. Run query manually:
   ```sql
   SELECT * FROM visits 
   WHERE technician_id = '82cf187c-c444-434a-9a65-3018b1b3369d'
   AND scheduled_start >= CURRENT_DATE;
   ```

---

**Ready to fix?** → Run Step 1-3 now! ⬆️
