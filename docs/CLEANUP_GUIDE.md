# Project Cleanup Guide

This guide provides detailed instructions for cleaning up unused code, files, and dependencies after migrating from GetX to Riverpod.

---

## 🎯 Cleanup Goals

1. **Remove all GetX code** - Controllers, bindings, routes, imports
2. **Delete unused files** - Migrated controllers, old bindings, duplicate code
3. **Clean dependencies** - Remove GetX package and unused packages
4. **Organize structure** - Move files to new architecture locations
5. **Improve code quality** - Remove dead code, fix warnings, improve organization

---

## 📋 Cleanup Phases

### Phase 1: Identify What to Remove

#### Step 1: Find All GetX References

Run these commands to identify GetX code:

```bash
# Navigate to project root
cd /Users/asadkathia/Desktop/smartflowpro

# Find GetX imports
echo "🔍 Finding GetX imports..."
grep -r "import 'package:get/get.dart'" lib/ | wc -l
grep -r "import 'package:get/getx.dart'" lib/ | wc -l

# Find GetX controllers
echo "🔍 Finding GetX controllers..."
grep -r "extends GetxController" lib/ | wc -l

# Find GetView classes
echo "🔍 Finding GetView classes..."
grep -r "extends GetView" lib/ | wc -l

# Find Obx widgets
echo "🔍 Finding Obx widgets..."
grep -r "Obx(" lib/ | wc -l

# Find .obs variables
echo "🔍 Finding .obs variables..."
grep -r "\.obs" lib/ | wc -l

# Find Get. navigation
echo "🔍 Finding Get. navigation..."
grep -r "Get\." lib/ | wc -l
```

#### Step 2: List Files to Delete

```bash
# Find all controller files
echo "📁 Controllers to review:"
find lib/app/modules -name "*_controller.dart" -type f

# Find all binding files
echo "📁 Bindings to review:"
find lib/app/modules -name "*_binding.dart" -type f
find lib/app/modules -name "*_bindings.dart" -type f

# Find all GetX route files
echo "📁 Route files to review:"
find lib/app/routes -name "*.dart" -type f
```

---

## 🗑️ Phase 2: Delete Migrated Files

### Controllers to Delete (After Migration)

**⚠️ Only delete after confirming migration is complete!**

```bash
# Create backup first
git add .
git commit -m "Pre-cleanup backup"

# Delete controllers (one by one, after verifying migration)
# Auth controllers
rm lib/app/modules/auth/login/controller/login_controller.dart
rm lib/app/modules/auth/signup/controller/signup_controller.dart
rm lib/app/modules/auth/controller/auth_controller.dart
rm lib/app/modules/auth/forget_password/controller/forget_password_controller.dart
rm lib/app/modules/auth/reset_password/controller/reset_password_controller.dart
rm lib/app/modules/auth/verify_otp/controller/verify_otp_controller.dart

# Feature controllers
rm lib/app/modules/Home/controller/home_page_controller.dart
rm lib/app/modules/Home/controller/map_controller.dart
rm lib/app/modules/job_details/controller/job_details_controller.dart
rm lib/app/modules/schedule/controller/schedule_controller.dart
rm lib/app/modules/create_quotes/controller/create_quotes_controller.dart
rm lib/app/modules/quotes_list/controller/quotes_list_controller.dart
rm lib/app/modules/profile/controller/profile_controller.dart
rm lib/app/modules/more/controller/more_view_controller.dart
rm lib/app/modules/on_my_way/controller/on_my_way_controller.dart
rm lib/app/modules/main_navigation/controller/main_navigation_controller.dart
rm lib/app/modules/splash/controller/splash_controller.dart
```

### Bindings to Delete (All GetX Bindings)

```bash
# Delete all binding files
find lib/app/modules -name "*_binding.dart" -type f -delete
find lib/app/modules -name "*_bindings.dart" -type f -delete
```

### Routes to Update

```bash
# Backup old routes
cp lib/app/routes/app_pages.dart lib/app/routes/app_pages.dart.backup
cp lib/app/routes/app_routes.dart lib/app/routes/app_routes.dart.backup

# After GoRouter is set up, delete old GetX routes
# rm lib/app/routes/app_pages.dart  # Only after GoRouter migration
```

---

## 🧹 Phase 3: Remove GetX Code from Files

### Step 1: Remove GetX Imports

```bash
# Find files with GetX imports
grep -l "import 'package:get" lib/**/*.dart

# For each file, remove the import line
# Manual process or use sed:
find lib -name "*.dart" -type f -exec sed -i '' "/import 'package:get\/get.dart';/d" {} \;
find lib -name "*.dart" -type f -exec sed -i '' "/import 'package:get\/getx.dart';/d" {} \;
```

### Step 2: Replace GetX Patterns

#### Replace Obx() with Consumer/ConsumerWidget

**Before:**
```dart
Obx(() => Text(controller.count.value.toString()))
```

**After:**
```dart
Consumer(
  builder: (context, ref, child) {
    final count = ref.watch(counterProvider);
    return Text(count.toString());
  },
)
```

#### Replace Get. Navigation

**Before:**
```dart
Get.toNamed(AppRoutes.home);
Get.back();
Get.offAllNamed(AppRoutes.auth);
```

**After:**
```dart
context.go('/home');
context.pop();
context.go('/auth');
```

#### Replace Get.snackbar

**Before:**
```dart
Get.snackbar('Title', 'Message');
```

**After:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Message')),
);
// Or use your custom toast
CustomToast.success('Message');
```

### Step 3: Remove .obs Variables

**Before:**
```dart
var count = 0.obs;
var name = ''.obs;
var items = <Item>[].obs;
```

**After:**
```dart
// Use Riverpod providers instead
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
}
```

---

## 📦 Phase 4: Dependency Cleanup

### Step 1: Remove GetX from pubspec.yaml

```yaml
# Remove this line from dependencies:
# get: ^4.7.2
```

### Step 2: Check for Unused Packages

```bash
# Install dependency_validator
dart pub global activate dependency_validator

# Check for unused dependencies
dependency_validator

# Review output and remove unused packages
```

### Step 3: Clean and Reinstall

```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📁 Phase 5: File Structure Reorganization

### Move Files to New Structure

```bash
# Create new directories
mkdir -p lib/core/theme
mkdir -p lib/core/constants
mkdir -p lib/core/utils
mkdir -p lib/core/errors
mkdir -p lib/shared/data/local
mkdir -p lib/shared/data/remote
mkdir -p lib/shared/presentation/widgets

# Move theme files
mv lib/app/utils/app_theme/* lib/core/theme/
mv lib/app/utils/app_theme/app_colors.dart lib/core/theme/
mv lib/app/utils/app_theme/app_text_styles.dart lib/core/theme/

# Move constants
mv lib/app/utils/ApiConstants/* lib/core/constants/

# Move shared preferences
mv lib/app/utils/SharedPrefHelper/* lib/shared/data/local/

# Move network files
mv lib/app/network/* lib/shared/data/remote/

# Move components
mv lib/app/components/* lib/shared/presentation/widgets/

# Remove empty directories
find lib -type d -empty -delete
```

### Update Imports

After moving files, update all imports:

```bash
# Find files importing old paths
grep -r "app/utils/app_theme" lib/
grep -r "app/utils/ApiConstants" lib/
grep -r "app/components" lib/
grep -r "app/network" lib/

# Update imports (example)
find lib -name "*.dart" -type f -exec sed -i '' 's|app/utils/app_theme|core/theme|g' {} \;
find lib -name "*.dart" -type f -exec sed -i '' 's|app/components|shared/presentation/widgets|g' {} \;
```

---

## 🧪 Phase 6: Code Quality Cleanup

### Step 1: Remove Dead Code

```bash
# Run analyzer to find dead code
flutter analyze > analysis_output.txt

# Review and fix:
# - Unused imports
# - Unused variables
# - Unused functions
# - Unused classes
```

### Step 2: Remove Commented Code

```bash
# Find large commented blocks
grep -r "^[[:space:]]*//.*TODO.*Remove" lib/
grep -r "^[[:space:]]*//.*FIXME.*Old" lib/

# Review and remove commented code manually
```

### Step 3: Fix Code Smells

```bash
# Run dart fix
dart fix --apply

# Run linter
flutter pub run flutter_lints:lint
```

### Step 4: Remove Duplicate Code

Manually review and consolidate:
- Duplicate utility functions
- Duplicate widget implementations
- Duplicate constants

---

## 🧪 Phase 7: Testing Cleanup

### Remove Outdated Tests

```bash
# Find test files for deleted controllers
find test -name "*_controller_test.dart" -type f

# Review and delete tests for removed controllers
# Update tests for migrated code
```

### Update Test Imports

```bash
# Update test imports to use Riverpod
find test -name "*.dart" -type f -exec sed -i '' 's|package:get/get.dart|package:flutter_riverpod/flutter_riverpod.dart|g' {} \;
```

---

## ✅ Phase 8: Verification

### Create Cleanup Verification Script

Create `scripts/verify_cleanup.sh`:

```bash
#!/bin/bash

echo "🔍 Verifying cleanup..."

# Check for GetX imports
if grep -r "import 'package:get" lib/ > /dev/null 2>&1; then
    echo "❌ Found GetX imports"
    grep -r "import 'package:get" lib/
    exit 1
else
    echo "✅ No GetX imports found"
fi

# Check for .obs usage
if grep -r "\.obs" lib/ > /dev/null 2>&1; then
    echo "❌ Found .obs usage"
    grep -r "\.obs" lib/
    exit 1
else
    echo "✅ No .obs usage found"
fi

# Check for Obx widgets
if grep -r "Obx(" lib/ > /dev/null 2>&1; then
    echo "❌ Found Obx widgets"
    grep -r "Obx(" lib/
    exit 1
else
    echo "✅ No Obx widgets found"
fi

# Check for Get. navigation
if grep -r "Get\." lib/ > /dev/null 2>&1; then
    echo "❌ Found Get. navigation"
    grep -r "Get\." lib/
    exit 1
else
    echo "✅ No Get. navigation found"
fi

# Check for GetxController
if grep -r "GetxController" lib/ > /dev/null 2>&1; then
    echo "❌ Found GetxController"
    grep -r "GetxController" lib/
    exit 1
else
    echo "✅ No GetxController found"
fi

# Run flutter analyze
echo "🔍 Running flutter analyze..."
flutter analyze

if [ $? -eq 0 ]; then
    echo "✅ Flutter analyze passed"
else
    echo "❌ Flutter analyze found issues"
    exit 1
fi

echo "✅ Cleanup verification complete!"
```

Make it executable:
```bash
chmod +x scripts/verify_cleanup.sh
./scripts/verify_cleanup.sh
```

---

## 📊 Cleanup Progress Tracker

### Week 7: Preparation
- [ ] Identify all GetX code
- [ ] Create cleanup branch
- [ ] Backup current codebase
- [ ] Document cleanup plan

### Week 8, Day 1-2: Active Cleanup
- [ ] Delete migrated controllers
- [ ] Delete all bindings
- [ ] Remove GetX imports
- [ ] Replace GetX patterns

### Week 8, Day 3: Dependency Cleanup
- [ ] Remove GetX from pubspec.yaml
- [ ] Remove unused packages
- [ ] Clean and reinstall

### Week 8, Day 4: Structure Reorganization
- [ ] Move files to new structure
- [ ] Update all imports
- [ ] Remove empty folders

### Week 8, Day 5: Final Verification
- [ ] Run verification script
- [ ] Fix remaining issues
- [ ] Run all tests
- [ ] Final code review

---

## 🛠️ Useful Cleanup Commands

### Find and Count GetX Usage

```bash
# Count GetX imports
grep -r "import 'package:get" lib/ | wc -l

# Count .obs usage
grep -r "\.obs" lib/ | wc -l

# Count Obx widgets
grep -r "Obx(" lib/ | wc -l

# Count Get. navigation
grep -r "Get\." lib/ | wc -l
```

### Batch Replace (Use with Caution!)

```bash
# Replace Get.toNamed with context.go (manual review needed)
find lib -name "*.dart" -type f -exec sed -i '' 's/Get\.toNamed(/context.go(/g' {} \;

# Replace Get.back with context.pop (manual review needed)
find lib -name "*.dart" -type f -exec sed -i '' 's/Get\.back()/context.pop()/g' {} \;
```

**⚠️ Warning**: Always review changes after batch replacements!

### Find Unused Files

```bash
# Find files not imported anywhere
# (Requires custom script or manual review)

# Find empty files
find lib -name "*.dart" -type f -empty

# Find files with only comments
find lib -name "*.dart" -type f -exec sh -c 'if [ $(grep -v "^[[:space:]]*//" "$1" | grep -v "^[[:space:]]*$" | wc -l) -eq 0 ]; then echo "$1"; fi' _ {} \;
```

---

## 📝 Cleanup Checklist Summary

### Must Complete
- [ ] Remove GetX package from pubspec.yaml
- [ ] Delete all GetX controllers (after migration)
- [ ] Delete all GetX bindings
- [ ] Remove all GetX imports
- [ ] Replace all GetX navigation
- [ ] Replace all Obx widgets
- [ ] Remove all .obs variables
- [ ] Update file structure
- [ ] Update all imports
- [ ] Run flutter analyze (zero errors)
- [ ] Run all tests (all passing)

### Should Complete
- [ ] Remove unused packages
- [ ] Remove commented code
- [ ] Remove dead code
- [ ] Consolidate duplicate code
- [ ] Update documentation
- [ ] Clean up assets

### Nice to Have
- [ ] Optimize imports
- [ ] Improve code organization
- [ ] Add missing documentation
- [ ] Improve naming conventions

---

## 🚨 Important Warnings

1. **Always backup before cleanup**
   ```bash
   git add .
   git commit -m "Pre-cleanup backup"
   ```

2. **Test after each cleanup phase**
   ```bash
   flutter test
   flutter run
   ```

3. **Review batch replacements manually**
   - Don't blindly replace all Get. calls
   - Some might need special handling

4. **Keep migration branch separate**
   - Don't merge until cleanup is verified
   - Test thoroughly before merging

5. **Document what you delete**
   - Keep notes of deleted files
   - Update CHANGELOG.md

---

## 📚 Related Documents

- `IMPLEMENTATION_PLAN.md` - Main implementation guide
- `MIGRATION_CHECKLIST.md` - Detailed migration checklist
- `QUICK_START_GUIDE.md` - Getting started guide

---

## ✅ Final Verification

Before marking cleanup as complete, verify:

```bash
# 1. Run verification script
./scripts/verify_cleanup.sh

# 2. Run tests
flutter test

# 3. Run app
flutter run

# 4. Check analysis
flutter analyze

# 5. Check linter
flutter pub run flutter_lints:lint
```

All should pass with zero errors! 🎉

---

**Last Updated**: January 4, 2026  
**Version**: 1.0



