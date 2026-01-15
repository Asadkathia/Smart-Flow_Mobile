import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';
import 'shared/presentation/widgets/error_boundary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase (only if configured)
  if (SupabaseConfig.isValid) {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
      );
      debugPrint('✅ Supabase initialized successfully');
    } catch (e) {
      debugPrint('⚠️ Supabase initialization failed: $e');
      debugPrint('   App will continue with mock data mode');
    }
  } else {
    final errors = SupabaseConfig.validationErrors;
    debugPrint('⚠️ Supabase Configuration Missing:');
    for (final error in errors) {
      debugPrint('   - $error');
    }
    debugPrint('');
    debugPrint('App will use mock data mode.');
    debugPrint('To enable Supabase, set environment variables:');
    debugPrint('   - SUPABASE_URL');
    debugPrint('   - SUPABASE_ANON_KEY');
    debugPrint('');
    
    // In production, throw error if Supabase is required
    if (SupabaseConfig.isProduction) {
      throw Exception('Supabase configuration is required in production. Please check your environment variables.');
    }
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
