# GetX to Riverpod Migration Checklist

## Pre-Migration Setup

- [ ] Backup current codebase
- [ ] Create new branch: `feature/riverpod-migration`
- [ ] Update pubspec.yaml with Riverpod dependencies
- [ ] Run `flutter pub get`
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`

## Phase 1: Setup (Week 1)

### Day 1-2: Dependencies & Structure
- [ ] Add Riverpod to pubspec.yaml
- [ ] Add code generation packages
- [ ] Add networking packages (Dio, Retrofit)
- [ ] Add local storage packages (Hive)
- [ ] Wrap app with ProviderScope
- [ ] Create core folder structure
- [ ] Create features folder structure
- [ ] Create shared folder structure

### Day 3-4: Core Infrastructure
- [ ] Create API client with Dio
- [ ] Set up Retrofit for type-safe API
- [ ] Create API interceptors
- [ ] Set up Hive for offline storage
- [ ] Create offline queue service
- [ ] Create connectivity provider
- [ ] Set up error handling

### Day 5: Theme & Constants
- [ ] Move AppTheme to core/theme/
- [ ] Move AppColors to core/theme/
- [ ] Move AppTextStyles to core/theme/
- [ ] Create API endpoints constants
- [ ] Create storage keys constants

## Phase 2: Data Layer (Week 2)

### Models to Create (PRD Aligned)

#### Core Models
- [ ] OrganizationModel (Section 3.1)
- [ ] UserModel (Section 3.2)
- [ ] CustomerModel (Section 3.3)
- [ ] PropertyModel (Section 3.4)
- [ ] JobModel (Section 3.5) - update existing

#### Visit Models
- [ ] VisitModel (Section 3.6)
- [ ] NoteModel (Section 3.7)
- [ ] VisitMediaModel (Section 3.19)
- [ ] VisitSignatureModel (Section 3.20)

#### Inventory & Billing
- [ ] InventoryItemModel (Section 3.8)
- [ ] BillingSettingsModel (Section 3.9)

#### Quote & Invoice Models
- [ ] QuoteModel (Section 3.10)
- [ ] LineItemModel (Section 3.11)
- [ ] InvoiceModel (Section 3.12)
- [ ] PaymentModel (Section 3.13)

#### Chat Models
- [ ] ChatThreadModel (Section 3.14)
- [ ] ChatParticipantModel (Section 3.15)
- [ ] ChatMessageModel (Section 3.16)

#### Other Models
- [ ] AIInteractionLogModel (Section 3.17)
- [ ] AuditLogModel (Section 3.18)
- [ ] EmployeeInvitationModel (Section 3.21)
- [ ] QuoteApprovalModel (Section 3.22 - optional)

### Repositories to Create

- [ ] AuthRepository
- [ ] VisitRepository
- [ ] NoteRepository
- [ ] QuoteRepository
- [ ] InvoiceRepository
- [ ] InventoryRepository
- [ ] ChatRepository
- [ ] AIRepository
- [ ] MediaRepository

## Phase 3: Feature Migration

### Auth Feature (Week 3, Days 1-2)

**Files to Migrate:**
- [ ] LoginController → AuthProvider
- [ ] SignupController → SignupProvider
- [ ] AuthController → AuthStateProvider
- [ ] LoginView → LoginScreen (with ConsumerWidget)
- [ ] SignupView → SignupScreen (with ConsumerWidget)
- [ ] VerifyOtpView → VerifyOtpScreen (with ConsumerWidget)

**GetX to Remove:**
- [ ] Remove `Get.toNamed()` → Replace with `context.go()`
- [ ] Remove `Get.back()` → Replace with `context.pop()`
- [ ] Remove `Get.snackbar()` → Replace with custom toast
- [ ] Remove `.obs` → Replace with Riverpod state
- [ ] Remove `Obx()` → Replace with `ref.watch()`

### Visits Feature (Week 3, Days 3-5)

**Controllers to Migrate:**
- [ ] HomePageController → TodayVisitsProvider
- [ ] JobDetailsController → VisitDetailsProvider
- [ ] MapController → MapStateProvider

**Views to Migrate:**
- [ ] HomeView → HomeScreen (keep existing UI)
- [ ] JobDetailsView → VisitDetailsScreen (keep existing UI)
- [ ] Create new: VisitsListScreen

**Widgets to Update:**
- [ ] JobCardWidget → VisitCard (update data binding)
- [ ] MapWidget (update to use providers)
- [ ] JobDetailsHeader (update to use providers)
- [ ] JobDetailsVisitTab (add content)
- [ ] JobDetailsDetailsTab (add content)
- [ ] JobDetailsNotesTab (connect to provider)

### Schedule Feature (Week 6, Days 4-5)

**Controllers to Migrate:**
- [ ] ScheduleController → ScheduleProvider

**Views to Migrate:**
- [ ] ScheduleView → ScheduleScreen
- [ ] DayViewWidget (connect to provider)
- [ ] ListViewWidget (connect to provider)
- [ ] MapViewWidget (connect to provider)

### Quotes Feature (Week 5, Days 1-2)

**Controllers to Migrate:**
- [ ] CreateQuotesController → QuoteBuilderProvider
- [ ] QuotesListController → QuotesListProvider

**Views to Migrate:**
- [ ] CreateQuotesView → CreateQuoteScreen
- [ ] QuotesListView → QuotesListScreen

**Keep Existing Widgets:**
- [ ] CreateQuotesLineItem (reusable)
- [ ] CreateQuotesSectionHeader (reusable)
- [ ] All quote dialogs (reusable)

### Profile & More (Week 8, Day 5)

**Controllers to Migrate:**
- [ ] ProfileController → ProfileProvider
- [ ] MoreViewController → SettingsProvider

**Views to Migrate:**
- [ ] ProfileView → ProfileScreen
- [ ] MoreView → MoreScreen

## New Features to Build

### Inventory Management (Week 5, Days 3-5)
- [ ] Create InventoryListScreen
- [ ] Create AddInventoryScreen
- [ ] Create InventoryItemCard widget
- [ ] Implement manual entry flow
- [ ] Implement AI auto-detection flow
- [ ] Add image upload

### Invoice Management (Week 6, Days 1-3)
- [ ] Create InvoiceListScreen
- [ ] Create InvoicePreviewScreen
- [ ] Create InvoiceDraftScreen
- [ ] Implement draft creation
- [ ] Implement preview generation
- [ ] Add finalization

### Signature Capture (Week 4, Day 5)
- [ ] Add signature package
- [ ] Create SignatureCaptureWidget
- [ ] Add to Visit Details
- [ ] Connect to completion flow

### Chat System (Week 7, Days 1-3)
- [ ] Create ChatThreadListScreen
- [ ] Create ChatConversationScreen
- [ ] Create MessageBubble widget
- [ ] Implement message sending
- [ ] Add realtime updates

### AI Assistant (Week 7, Days 4-5)
- [ ] Create AIAssistantScreen
- [ ] Create AIMessageBubble widget
- [ ] Implement chat interface
- [ ] Add image upload
- [ ] Add suggestion chips

## Router Setup

### Create GoRouter Configuration
- [ ] Create app_router.dart
- [ ] Define all routes
- [ ] Create route guards
- [ ] Set up deep linking
- [ ] Add transition animations

### Routes to Define
- [ ] `/` → Splash
- [ ] `/auth` → Auth screens
- [ ] `/home` → Home/Map
- [ ] `/schedule` → Schedule
- [ ] `/visits` → Visits List
- [ ] `/visits/:id` → Visit Details
- [ ] `/quotes` → Quotes List
- [ ] `/quotes/create` → Create Quote
- [ ] `/inventory` → Inventory List
- [ ] `/invoices` → Invoice List
- [ ] `/chat` → Chat List
- [ ] `/chat/:id` → Chat Conversation
- [ ] `/ai-assist` → AI Assistant
- [ ] `/profile` → Profile
- [ ] `/more` → More/Settings

## Cleanup Tasks

### Phase 1: Remove GetX Dependencies
- [ ] Remove `get:` from pubspec.yaml
- [ ] Remove all `Get.` imports
- [ ] Remove `GetxController` extends
- [ ] Remove `GetView` extends
- [ ] Remove `Obx()` widgets
- [ ] Remove `.obs` reactive variables
- [ ] Remove `GetPage` routes
- [ ] Remove `GetMaterialApp`

### Phase 2: Update Navigation
- [ ] Replace all `Get.toNamed()` with `context.go()`
- [ ] Replace all `Get.back()` with `context.pop()`
- [ ] Replace all `Get.offAllNamed()` with `context.go()` + clearStack
- [ ] Update all route parameters to path params

### Phase 3: Update State Management
- [ ] Replace all `Obx()` with `Consumer` or `ConsumerWidget`
- [ ] Replace all `.value` with `ref.watch()` or `ref.read()`
- [ ] Replace all `.obs` with Riverpod state
- [ ] Update all controllers to providers

### Phase 4: Delete Migrated Files

#### Controllers to Delete (After Migration)
- [ ] `lib/app/modules/auth/login/controller/login_controller.dart`
- [ ] `lib/app/modules/auth/signup/controller/signup_controller.dart`
- [ ] `lib/app/modules/auth/controller/auth_controller.dart`
- [ ] `lib/app/modules/auth/forget_password/controller/forget_password_controller.dart`
- [ ] `lib/app/modules/auth/reset_password/controller/reset_password_controller.dart`
- [ ] `lib/app/modules/auth/verify_otp/controller/verify_otp_controller.dart`
- [ ] `lib/app/modules/Home/controller/home_page_controller.dart`
- [ ] `lib/app/modules/Home/controller/map_controller.dart`
- [ ] `lib/app/modules/job_details/controller/job_details_controller.dart`
- [ ] `lib/app/modules/schedule/controller/schedule_controller.dart`
- [ ] `lib/app/modules/create_quotes/controller/create_quotes_controller.dart`
- [ ] `lib/app/modules/quotes_list/controller/quotes_list_controller.dart`
- [ ] `lib/app/modules/profile/controller/profile_controller.dart`
- [ ] `lib/app/modules/more/controller/more_view_controller.dart`
- [ ] `lib/app/modules/on_my_way/controller/on_my_way_controller.dart`
- [ ] `lib/app/modules/main_navigation/controller/main_navigation_controller.dart`
- [ ] `lib/app/modules/splash/controller/splash_controller.dart`

#### Bindings to Delete (All GetX Bindings)
- [ ] `lib/app/modules/auth/binding/auth_binding.dart`
- [ ] `lib/app/modules/auth/forget_password/bindings/forget_password_binding.dart`
- [ ] `lib/app/modules/auth/reset_password/binding/reset_password_binding.dart`
- [ ] `lib/app/modules/auth/verify_otp/binding/verify_otp_binding.dart`
- [ ] `lib/app/modules/Home/bindings/home_binding.dart`
- [ ] `lib/app/modules/job_details/bindings/job_details_bindings.dart`
- [ ] `lib/app/modules/schedule/bindings/schedule_binding.dart`
- [ ] `lib/app/modules/create_quotes/bindings/create_quotes_binding.dart`
- [ ] `lib/app/modules/quotes_list/bindings/quotes_list_bindings.dart`
- [ ] `lib/app/modules/profile/bindings/profile_bindings.dart`
- [ ] `lib/app/modules/more/bindings/more_view_bindings.dart`
- [ ] `lib/app/modules/on_my_way/bindings/on_my_way_bindings.dart`
- [ ] `lib/app/modules/main_navigation/bindings/main_navigation_binding.dart`
- [ ] `lib/app/modules/splash/bindings/splash_bindings.dart`

#### Routes to Update/Delete
- [ ] `lib/app/routes/app_pages.dart` (replace with GoRouter)
- [ ] `lib/app/routes/app_routes.dart` (update to GoRouter format)

### Phase 5: Remove Unused Code

#### Unused Imports
- [ ] Run `dart fix --apply` to auto-remove unused imports
- [ ] Manually review and remove any remaining unused imports
- [ ] Check for circular imports

#### Dead Code
- [ ] Remove unused functions
- [ ] Remove unused variables
- [ ] Remove unused classes
- [ ] Remove unused enums
- [ ] Remove unused constants

#### Commented Code
- [ ] Remove all commented-out code blocks
- [ ] Remove TODO comments that are no longer relevant
- [ ] Remove FIXME comments that are resolved
- [ ] Keep only active TODO comments with clear purpose

#### Duplicate Code
- [ ] Identify duplicate utility functions
- [ ] Consolidate duplicate widgets
- [ ] Merge duplicate constants
- [ ] Remove duplicate model definitions

### Phase 6: File Structure Cleanup

#### Move Files to New Structure
- [ ] Move `lib/app/utils/app_theme/` → `lib/core/theme/`
- [ ] Move `lib/app/utils/ApiConstants/` → `lib/core/constants/`
- [ ] Move `lib/app/utils/SharedPrefHelper/` → `lib/shared/data/local/`
- [ ] Move `lib/app/components/` → `lib/shared/presentation/widgets/`
- [ ] Move `lib/app/network/` → `lib/shared/data/remote/`

#### Remove Empty Folders
- [ ] Find and remove empty directories
- [ ] Clean up unused folder structure
- [ ] Organize remaining files

#### Update Exports
- [ ] Update `lib/app/export/exports.dart`
- [ ] Remove exports for deleted files
- [ ] Add exports for new structure
- [ ] Create feature-specific export files

### Phase 7: Asset Cleanup

#### Unused Assets
- [ ] Identify unused images in `assets/`
- [ ] Remove unused icons
- [ ] Remove unused fonts (if any)
- [ ] Update `pubspec.yaml` asset declarations

#### Generated Files
- [ ] Clean build artifacts: `flutter clean`
- [ ] Remove old generated files
- [ ] Regenerate with build_runner

### Phase 8: Dependency Cleanup

#### Remove Unused Packages
- [ ] Review `pubspec.yaml` dependencies
- [ ] Remove packages only used by GetX
- [ ] Remove packages not in new architecture
- [ ] Verify all remaining packages are used
- [ ] Run `flutter pub get` after cleanup

#### Update Package Versions
- [ ] Update all packages to latest compatible versions
- [ ] Resolve any version conflicts
- [ ] Test after version updates

### Phase 9: Code Quality

#### Run Analysis
- [ ] Run `flutter analyze` and fix all issues
- [ ] Run `dart fix --apply` for auto-fixes
- [ ] Run linter and fix all warnings
- [ ] Ensure zero warnings/errors

#### Code Smells
- [ ] Refactor long methods (>50 lines)
- [ ] Split large classes (>500 lines)
- [ ] Reduce deep nesting
- [ ] Replace magic numbers with constants
- [ ] Improve naming conventions

### Phase 10: Testing Cleanup

#### Remove Outdated Tests
- [ ] Delete tests for removed controllers
- [ ] Delete tests for removed views
- [ ] Update tests for migrated code
- [ ] Remove outdated test mocks

#### Update Test Files
- [ ] Update test imports
- [ ] Update test setup for Riverpod
- [ ] Add tests for new providers
- [ ] Ensure all tests pass

### Phase 11: Documentation Cleanup

#### Update Documentation
- [ ] Update README.md with new architecture
- [ ] Update code comments
- [ ] Update API documentation
- [ ] Update CHANGELOG.md

#### Remove Outdated Docs
- [ ] Remove old architecture diagrams
- [ ] Remove outdated setup guides
- [ ] Update migration documentation

### Cleanup Verification Commands

```bash
# 1. Check for GetX references
grep -r "import 'package:get" lib/ && echo "❌ Found GetX" || echo "✅ Clean"

# 2. Check for .obs usage
grep -r "\.obs" lib/ && echo "❌ Found .obs" || echo "✅ Clean"

# 3. Check for Obx widgets
grep -r "Obx(" lib/ && echo "❌ Found Obx" || echo "✅ Clean"

# 4. Check for Get. navigation
grep -r "Get\." lib/ && echo "❌ Found Get." || echo "✅ Clean"

# 5. Check for GetxController
grep -r "GetxController" lib/ && echo "❌ Found GetxController" || echo "✅ Clean"

# 6. Run analysis
flutter analyze

# 7. Check for unused imports
dart analyze lib/ | grep "unused_import"

# 8. Check for dead code
dart analyze lib/ | grep "dead_code"
```

### Final Cleanup Checklist

Before marking cleanup as complete:

- [ ] ✅ No GetX imports in codebase
- [ ] ✅ No `.obs` variables found
- [ ] ✅ No `Obx()` widgets found
- [ ] ✅ No `Get.` navigation calls
- [ ] ✅ No `GetxController` classes
- [ ] ✅ No `GetView` classes
- [ ] ✅ All old controllers deleted
- [ ] ✅ All old bindings deleted
- [ ] ✅ Old routes replaced with GoRouter
- [ ] ✅ No unused imports
- [ ] ✅ No dead code
- [ ] ✅ No commented-out code
- [ ] ✅ File structure organized
- [ ] ✅ All tests passing
- [ ] ✅ Code analysis passes
- [ ] ✅ Linter passes
- [ ] ✅ App runs without errors
- [ ] ✅ Documentation updated

## Testing

### Unit Tests
- [ ] Test all repositories
- [ ] Test all providers
- [ ] Test all models
- [ ] Test offline queue
- [ ] Test connectivity handling

### Integration Tests
- [ ] Test auth flow
- [ ] Test visit management
- [ ] Test quote creation
- [ ] Test offline sync
- [ ] Test error handling

### Widget Tests
- [ ] Test all major screens
- [ ] Test navigation
- [ ] Test form validation
- [ ] Test error states
- [ ] Test loading states

## Performance Optimization

- [ ] Implement pagination for large lists
- [ ] Add image caching
- [ ] Optimize provider rebuilds
- [ ] Add list view optimizations
- [ ] Profile app performance

## Documentation

- [ ] Update README with new architecture
- [ ] Document provider usage
- [ ] Document offline sync
- [ ] Document error handling
- [ ] Create developer guide

## Final Checks

- [ ] All GetX references removed
- [ ] All features working
- [ ] No runtime errors
- [ ] No type errors
- [ ] All tests passing
- [ ] Code coverage >80%
- [ ] Performance acceptable
- [ ] Offline mode working
- [ ] Error handling robust

## Deployment Preparation

- [ ] Update version number
- [ ] Update changelog
- [ ] Run final tests
- [ ] Create release build
- [ ] Test on physical devices
- [ ] Prepare release notes

---

## Notes & Tips

### Common Migration Patterns

**GetX Observable:**
```dart
// Before
var count = 0.obs;

// After
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  
  void increment() => state++;
}
```

**GetX Navigation:**
```dart
// Before
Get.toNamed(AppRoutes.home, arguments: {'id': '123'});

// After
context.go('/home/123');
```

**GetX Controller:**
```dart
// Before
class MyController extends GetxController {
  var data = <Item>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
}

// After
@riverpod
class MyData extends _$MyData {
  @override
  Future<List<Item>> build() async {
    return fetchData();
  }
}
```

### Useful Commands

```bash
# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean and rebuild
flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Check coverage
flutter test --coverage
```

---

**Last Updated**: January 4, 2026

