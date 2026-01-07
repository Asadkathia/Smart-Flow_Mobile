# Quick Start Guide - Riverpod Migration

This guide will help you get started with the Riverpod migration immediately.

---

## 🚀 Getting Started (30 minutes)

### Step 1: Backup & Branch (5 minutes)

```bash
# Create a backup
cd /Users/asadkathia/Desktop/smartflowpro
git add .
git commit -m "Pre-migration backup"

# Create migration branch
git checkout -b feature/riverpod-migration
```

### Step 2: Update Dependencies (10 minutes)

1. Open `pubspec.yaml`
2. **Remove this line:**
   ```yaml
   get: ^4.7.2
   ```

3. **Add these dependencies under `dependencies:`:**
   ```yaml
   # State Management
   flutter_riverpod: ^2.5.1
   riverpod_annotation: ^2.3.5
   
   # Routing
   go_router: ^13.2.0
   
   # Networking
   dio: ^5.4.3
   retrofit: ^4.1.0
   
   # JSON
   json_annotation: ^4.8.1
   freezed_annotation: ^2.4.1
   
   # Local Storage
   hive: ^2.2.3
   hive_flutter: ^1.1.0
   
   # Connectivity
   connectivity_plus: ^5.0.2
   
   # Image handling
   image_picker: ^1.0.7
   signature: ^5.5.0
   
   # Utilities
   equatable: ^2.0.5
   uuid: ^4.3.3
   ```

4. **Add these under `dev_dependencies:`:**
   ```yaml
   # Code Generation
   build_runner: ^2.4.8
   riverpod_generator: ^2.4.0
   json_serializable: ^6.7.1
   freezed: ^2.4.7
   retrofit_generator: ^8.1.0
   hive_generator: ^2.0.1
   ```

5. **Run:**
   ```bash
   flutter pub get
   ```

### Step 3: Wrap App with ProviderScope (5 minutes)

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/export/exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for offline storage
  await Hive.initFlutter();
  
  runApp(
    // Wrap with ProviderScope
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GetMaterialApp(  // Keep for now, will migrate later
          title: 'SmartFlowPro',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
```

### Step 4: Create Folder Structure (10 minutes)

Run these commands:

```bash
# Navigate to lib
cd lib

# Create core folders
mkdir -p core/constants
mkdir -p core/errors
mkdir -p core/utils

# Create features folder
mkdir -p features/auth/data/models
mkdir -p features/auth/data/repositories
mkdir -p features/auth/presentation/providers
mkdir -p features/auth/presentation/screens
mkdir -p features/auth/presentation/widgets

mkdir -p features/visits/data/models
mkdir -p features/visits/data/repositories
mkdir -p features/visits/presentation/providers
mkdir -p features/visits/presentation/screens
mkdir -p features/visits/presentation/widgets

# Create shared folders
mkdir -p shared/data/local
mkdir -p shared/data/remote
mkdir -p shared/presentation/providers
mkdir -p shared/presentation/widgets

# Create router folder
mkdir -p router
```

---

## 📝 Your First Migration: Home Screen

Let's migrate the Home screen as a practical example (20 minutes).

### Step 1: Create Visit Model

Create `lib/features/visits/data/models/visit_model.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'visit_model.freezed.dart';
part 'visit_model.g.dart';

@freezed
class VisitModel with _$VisitModel {
  const factory VisitModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId,
    @JsonKey(name: 'job_id') required String jobId,
    @JsonKey(name: 'technician_id') required String technicianId,
    required String title,
    required String address,
    required String customerName,
    @JsonKey(name: 'scheduled_start') required DateTime scheduledStart,
    @JsonKey(name: 'scheduled_end') required DateTime scheduledEnd,
    required VisitStatus status,
    required double latitude,
    required double longitude,
  }) = _VisitModel;

  factory VisitModel.fromJson(Map<String, dynamic> json) =>
      _$VisitModelFromJson(json);
}

enum VisitStatus {
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('paused')
  paused,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}
```

### Step 2: Create Visit Provider

Create `lib/features/visits/presentation/providers/visits_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/visit_model.dart';

part 'visits_provider.g.dart';

// For now, use dummy data (will connect to API later)
@riverpod
class TodayVisits extends _$TodayVisits {
  @override
  Future<List<VisitModel>> build() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return dummy data
    return [
      VisitModel(
        id: '1',
        orgId: 'org_1',
        jobId: 'job_1',
        technicianId: 'tech_1',
        title: 'LG Washer Repair',
        address: '15244 North 11th Street, Phoenix, AZ',
        customerName: 'Linda Fritz-Salazar',
        scheduledStart: DateTime.now(),
        scheduledEnd: DateTime.now().add(const Duration(hours: 3)),
        status: VisitStatus.scheduled,
        latitude: 33.6318,
        longitude: -112.0362,
      ),
      VisitModel(
        id: '2',
        orgId: 'org_1',
        jobId: 'job_2',
        technicianId: 'tech_1',
        title: 'Samsung Refrigerator Service',
        address: '123 Main Street, Scottsdale, AZ',
        customerName: 'John Doe',
        scheduledStart: DateTime.now().add(const Duration(hours: 3)),
        scheduledEnd: DateTime.now().add(const Duration(hours: 5)),
        status: VisitStatus.inProgress,
        latitude: 33.4734,
        longitude: -111.8988,
      ),
    ];
  }
  
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Simulate refresh
      await Future.delayed(const Duration(milliseconds: 500));
      return build();
    });
  }
}
```

### Step 3: Generate Code

```bash
# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# If you get errors, make sure all files are saved and try again
```

### Step 4: Update Home View to Use Riverpod

Update `lib/app/modules/Home/view/home_view.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../export/exports.dart';
import '../../../../features/visits/presentation/providers/visits_provider.dart';

// Change from GetView to ConsumerWidget
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider
    final visitsAsync = ref.watch(todayVisitsProvider);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingSection(context),
              SizedBox(
                height: 0.5.sh,
                width: 1.sw,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Map - will update later
                    MapWidget(jobs: []), // TODO: Convert to use VisitModel
                    // Fade overlays
                    IgnorePointer(
                      child: Column(
                        children: [
                          Container(
                            height: 36.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.backgroundColor,
                                  AppColors.backgroundColor.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            height: 36.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  AppColors.backgroundColor,
                                  AppColors.backgroundColor.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUpNextHeader(),
                    SizedBox(height: 15.h),
                    // Use Riverpod state
                    visitsAsync.when(
                      data: (visits) => _buildScheduledJobsList(visits),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stack) => Center(
                        child: Text('Error: $error'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.verticalSpace,
          Text(
            'Saturday, September 13th',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryTextColor,
            ),
          ),
          5.verticalSpace,
          Text(
            'Good evening, Tony',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpNextHeader() {
    return Text(
      'Up Next',
      style: AppTextStyles.heading4.copyWith(color: AppColors.primaryTextColor),
    );
  }

  Widget _buildScheduledJobsList(List visits) {
    return SizedBox(
      height: 140.h,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: visits
              .map(
                (visit) => Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: SizedBox(
                    width: 300.w,
                    child: VisitCardWidget(visit: visit),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
```

### Step 5: Test

```bash
# Run the app
flutter run

# You should see the home screen with Riverpod managing state!
```

---

## 🎯 Next Steps

Now that you have the foundation, follow this order:

### Week 1: Complete Setup
1. ✅ Dependencies added
2. ✅ ProviderScope wrapped
3. ✅ Folder structure created
4. ✅ First provider working
5. ⏳ Create API client
6. ⏳ Set up offline storage
7. ⏳ Create connectivity provider

### Week 2: Create All Models
Follow the list in `MIGRATION_CHECKLIST.md` under "Models to Create"

### Week 3+: Migrate Features
1. Auth
2. Visits
3. Quotes
4. Schedule
5. Profile

---

## 🐛 Troubleshooting

### Build Runner Errors

```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Import Errors

Make sure you've run code generation:
```bash
flutter pub run build_runner watch
```

### GetX Conflicts

During migration, both GetX and Riverpod will coexist. That's okay!
- New features use Riverpod
- Old features keep GetX (for now)
- Gradually migrate old to new

---

## 📚 Learning Resources

- [Riverpod Official Docs](https://riverpod.dev)
- [Riverpod YouTube Playlist](https://www.youtube.com/playlist?list=PLMnCubK5rYSL2lBZdAGMhVX3bfuN1dHgD)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Freezed Documentation](https://pub.dev/packages/freezed)

---

## 💡 Pro Tips

1. **Run build_runner in watch mode** while developing:
   ```bash
   flutter pub run build_runner watch
   ```

2. **Use Riverpod snippets** in VS Code:
   - Install "Flutter Riverpod Snippets" extension
   - Type `riverpod` to see available snippets

3. **Test incrementally**: Don't migrate everything at once. Do one feature at a time.

4. **Keep both systems**: It's okay to have GetX and Riverpod coexist during migration.

5. **Use DevTools**: Riverpod has excellent DevTools support for debugging.

---

## ✅ Success Checklist

- [ ] Dependencies installed
- [ ] ProviderScope wrapping app
- [ ] Folder structure created
- [ ] First provider working
- [ ] Code generation running
- [ ] Home screen showing data
- [ ] Ready to continue migration

---

**Need help?** Check `IMPLEMENTATION_PLAN.md` for the full 8-week roadmap!

**Last Updated**: January 4, 2026



