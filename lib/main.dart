import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';
import 'shared/presentation/widgets/error_boundary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Validate Supabase configuration before proceeding
  if (!SupabaseConfig.isValid) {
    final errors = SupabaseConfig.validationErrors;
    debugPrint('❌ Supabase Configuration Error:');
    for (final error in errors) {
      debugPrint('   - $error');
    }
    debugPrint('');
    debugPrint('Please set the required environment variables:');
    debugPrint('   - SUPABASE_URL');
    debugPrint('   - SUPABASE_ANON_KEY');
    debugPrint('');
    debugPrint('See .env.example for reference.');
    
    // In production, you might want to show a user-friendly error screen
    // For now, we'll continue but log the error
    if (SupabaseConfig.isProduction) {
      throw Exception('Supabase configuration is invalid. Please check your environment variables.');
    }
  } else {
    debugPrint('✅ Supabase configuration validated successfully');
  }
  
  // Initialize Hive for offline storage
  await Hive.initFlutter();
  
  // Set up global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log error (can be extended with Sentry)
    FlutterError.presentError(details);
    // In production, send to error tracking service
    // Sentry.captureException(details.exception, stackTrace: details.stack);
  };
  
  // Set custom error widget builder
  ErrorWidget.builder = buildErrorWidget;
  
  runApp(
    // Wrap with ProviderScope for Riverpod
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

/// Main Application Widget
/// 
/// Uses GoRouter for navigation and Riverpod for state management.
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return ScreenUtilInit(
      // iPhone 14 Pro screen size (390 x 844)
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return ErrorBoundary(
          child: MaterialApp.router(
            title: 'SmartFlowPro',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: router,
          ),
        );
      },
    );
  }
}
