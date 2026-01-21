import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../shared/presentation/widgets/animations.dart' as app_animations;

import '../features/auth/presentation/providers/auth_provider.dart';
// All legacy modules have been migrated to feature-based structure:
// - Splash -> core/splash ✓
// - Main navigation -> shared/navigation ✓
// - More/Settings -> features/settings/presentation/screens ✓
// - Auth screens -> features/auth/presentation/screens ✓
// - Visits screens (Home, Schedule, Job Details, On My Way) -> features/visits/presentation/screens ✓
// - Quotes screens (Create Quotes, Quotes List) -> features/quotes/presentation/screens ✓
// - Profile -> features/auth/presentation/screens ✓
import '../core/splash/splash_screen.dart';
// Auth screens - migrated to features/auth/presentation/screens
import '../features/auth/presentation/screens/auth_screen.dart';
import '../features/auth/presentation/screens/forget_password_screen.dart' show ForgotPasswordScreen;
import '../features/auth/presentation/screens/verify_otp_screen.dart';
import '../features/auth/presentation/screens/reset_password_screen.dart';
import '../shared/navigation/screens/main_navigation_screen.dart';
// Visits screens - migrated to features/visits/presentation/screens
import '../features/visits/presentation/screens/job_details_screen.dart';
import '../features/visits/presentation/screens/on_my_way_screen.dart';
// Quotes screens - migrated to features/quotes/presentation/screens
import '../features/quotes/presentation/screens/create_quotes_screen.dart';
import '../features/quotes/presentation/screens/quotes_list_screen.dart';
import '../features/quotes/presentation/screens/quote_details_screen.dart';
// Profile screen - migrated to features/auth/presentation/screens
import '../features/auth/presentation/screens/profile_screen.dart';
import '../features/inventory/presentation/screens/inventory_list_screen.dart';
import '../features/inventory/presentation/screens/add_inventory_item_screen.dart';
import '../features/inventory/presentation/screens/ai_detect_inventory_screen.dart';
import '../features/invoices/presentation/screens/invoice_list_screen.dart';
import '../features/chat/presentation/screens/chat_list_screen.dart';
import '../features/chat/presentation/screens/chat_thread_screen.dart';
import '../features/ai_assistant/presentation/screens/ai_assistant_screen.dart';
import '../shared/presentation/screens/conflict_resolution_screen.dart';
import '../features/inventory/presentation/screens/inventory_details_screen.dart';
import '../features/invoices/presentation/screens/invoice_preview_screen.dart';
import '../features/visits/presentation/screens/completed_visits_screen.dart';

/// Route paths as constants
class AppRoutePaths {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String forgetPassword = '/forget-password';
  static const String verifyOtp = '/verify-otp';
  static const String resetPassword = '/reset-password';
  static const String mainNavigation = '/main';
  static const String home = '/main/home';
  static const String schedule = '/main/schedule';
  static const String jobDetails = '/job-details/:id';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String onMyWay = '/on-my-way';
  static const String createQuotes = '/create-quotes';
  static const String quotesList = '/quotes-list';
  static const String inventoryList = '/inventory';
  static const String addInventoryItem = '/inventory/add';
  static const String aiDetectInventory = '/inventory/ai-detect';
  static const String invoiceList = '/invoices';
  static const String chatList = '/chat';
  static const String chatThread = '/chat/:chatId';
  static const String aiAssistant = '/ai-assistant';
  static const String conflictResolution = '/conflicts';
  static const String quoteDetails = '/quote/:id';
  static const String inventoryDetails = '/inventory/:id';
  static const String invoicePreview = '/invoice/:id/preview';
  static const String completedVisits = '/visits/completed';
}

/// Navigation helper extension
extension GoRouterExtension on BuildContext {
  /// Navigate to job details
  void goToJobDetails(String jobId) {
    push('/job-details/$jobId');
  }

  /// Navigate to chat thread
  void goToChatThread(String chatId, String chatName) {
    push('/chat/$chatId', extra: {'chatName': chatName});
  }

  /// Navigate to on my way screen
  void goToOnMyWay({
    required String visitId,
    required String customerName,
    required String address,
    required double latitude,
    required double longitude,
  }) {
    push(AppRoutePaths.onMyWay, extra: {
      'visitId': visitId,
      'customerName': customerName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  /// Navigate to create quotes
  void goToCreateQuotes(String visitId) {
    push(AppRoutePaths.createQuotes, extra: {'visitId': visitId});
  }

  /// Navigate to conflict resolution screen
  void goToConflictResolution() {
    push(AppRoutePaths.conflictResolution);
  }

  /// Navigate to quote details
  void goToQuoteDetails(String quoteId) {
    push('/quote/$quoteId');
  }

  /// Navigate to inventory item details
  void goToInventoryDetails(String itemId) {
    push('/inventory/$itemId');
  }

  /// Navigate to add inventory item (manual entry)
  void goToAddInventoryItem() {
    push(AppRoutePaths.addInventoryItem);
  }

  /// Navigate to AI detect inventory
  void goToAiDetectInventory() {
    push(AppRoutePaths.aiDetectInventory);
  }

  /// Navigate to invoice preview
  void goToInvoicePreview(String invoiceId) {
    push('/invoice/$invoiceId/preview');
  }

  /// Navigate to completed visits
  void goToCompletedVisits() {
    push(AppRoutePaths.completedVisits);
  }

  /// Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(message, isError: true);
  }
}

/// GoRouter configuration provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutePaths.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation == AppRoutePaths.auth ||
          state.matchedLocation == AppRoutePaths.forgetPassword ||
          state.matchedLocation == AppRoutePaths.verifyOtp ||
          state.matchedLocation == AppRoutePaths.resetPassword;
      final isSplash = state.matchedLocation == AppRoutePaths.splash;

      // Allow splash screen always
      if (isSplash) return null;

      // If not logged in and not on auth routes, redirect to auth
      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutePaths.auth;
      }

      // If logged in and on auth routes, redirect to main
      if (isLoggedIn && isAuthRoute) {
        return AppRoutePaths.mainNavigation;
      }

      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutePaths.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: AppRoutePaths.auth,
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.forgetPassword,
        name: 'forgetPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.verifyOtp,
        name: 'verifyOtp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return VerifyOtpScreen(
            email: extra?['email'] ?? '',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.resetPassword,
        name: 'resetPassword',
        builder: (context, state) => ResetPasswordScreen(),
      ),

      // Main Navigation (Home, Schedule, Chat, AI, More)
      GoRoute(
        path: AppRoutePaths.mainNavigation,
        name: 'mainNavigation',
        builder: (context, state) => const MainNavigationScreen(),
      ),

      // Job Details
      GoRoute(
        path: AppRoutePaths.jobDetails,
        name: 'jobDetails',
        pageBuilder: (context, state) {
          final jobId = state.pathParameters['id'] ?? '';
          return CustomTransitionPage(
            key: state.pageKey,
            child: JobDetailsScreen(visitId: jobId),
            transitionsBuilder: app_animations.AppPageTransitions.slideTransition,
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),

      // Profile
      GoRoute(
        path: AppRoutePaths.profile,
        name: 'profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProfileScreen(),
          transitionsBuilder: app_animations.AppPageTransitions.slideTransition,
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),

      // On My Way
      GoRoute(
        path: AppRoutePaths.onMyWay,
        name: 'onMyWay',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: OnMyWayScreen(
              visitId: extra?['visitId'] ?? '',
              customerName: extra?['customerName'] ?? '',
              address: extra?['address'] ?? '',
              latitude: extra?['latitude'] ?? 0.0,
              longitude: extra?['longitude'] ?? 0.0,
            ),
            transitionsBuilder: app_animations.AppPageTransitions.slideTransition,
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),

      // Create Quotes
      GoRoute(
        path: AppRoutePaths.createQuotes,
        name: 'createQuotes',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: CreateQuotesScreen(
              visitId: extra?['visitId'] ?? '',
            ),
            transitionsBuilder: app_animations.AppPageTransitions.slideTransition,
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),

      // Quotes List
      GoRoute(
        path: AppRoutePaths.quotesList,
        name: 'quotesList',
        builder: (context, state) => const QuotesListScreen(),
      ),

      // Inventory
      GoRoute(
        path: AppRoutePaths.inventoryList,
        name: 'inventoryList',
        builder: (context, state) => const InventoryListScreen(),
      ),

      // Add Inventory Item (Manual Entry)
      GoRoute(
        path: AppRoutePaths.addInventoryItem,
        name: 'addInventoryItem',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AddInventoryItemScreen(),
          transitionsBuilder: app_animations.AppPageTransitions.slideTransition,
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),

      // AI Detect Inventory
      GoRoute(
        path: AppRoutePaths.aiDetectInventory,
        name: 'aiDetectInventory',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AiDetectInventoryScreen(),
          transitionsBuilder: app_animations.AppPageTransitions.slideTransition,
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),

      // Invoices
      GoRoute(
        path: AppRoutePaths.invoiceList,
        name: 'invoiceList',
        builder: (context, state) => const InvoiceListScreen(),
      ),

      // Chat List
      GoRoute(
        path: AppRoutePaths.chatList,
        name: 'chatList',
        builder: (context, state) => const ChatListScreen(),
      ),

      // Chat Thread
      GoRoute(
        path: AppRoutePaths.chatThread,
        name: 'chatThread',
        pageBuilder: (context, state) {
          final chatId = state.pathParameters['chatId'] ?? '';
          final extra = state.extra as Map<String, dynamic>?;
          final chatName = extra?['chatName'] ?? 'Chat';
          return CustomTransitionPage(
            key: state.pageKey,
            child: ChatThreadScreen(chatId: chatId, chatName: chatName),
            transitionsBuilder: app_animations.AppPageTransitions.slideTransition,
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),

      // AI Assistant
      GoRoute(
        path: AppRoutePaths.aiAssistant,
        name: 'aiAssistant',
        builder: (context, state) => const AiAssistantScreen(),
      ),

      // Conflict Resolution
      GoRoute(
        path: AppRoutePaths.conflictResolution,
        name: 'conflictResolution',
        builder: (context, state) => const ConflictResolutionScreen(),
      ),

      // Quote Details
      GoRoute(
        path: AppRoutePaths.quoteDetails,
        name: 'quoteDetails',
        pageBuilder: (context, state) {
          final quoteId = state.pathParameters['id'] ?? '';
          return CustomTransitionPage(
            key: state.pageKey,
            child: QuoteDetailsScreen(quoteId: quoteId),
            transitionsBuilder: app_animations.AppPageTransitions.slideTransition,
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),

      // Inventory Details
      GoRoute(
        path: AppRoutePaths.inventoryDetails,
        name: 'inventoryDetails',
        pageBuilder: (context, state) {
          final itemId = state.pathParameters['id'] ?? '';
          return CustomTransitionPage(
            key: state.pageKey,
            child: InventoryDetailsScreen(itemId: itemId),
            transitionsBuilder: app_animations.AppPageTransitions.slideTransition,
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),

      // Invoice Preview
      GoRoute(
        path: AppRoutePaths.invoicePreview,
        name: 'invoicePreview',
        pageBuilder: (context, state) {
          final invoiceId = state.pathParameters['id'] ?? '';
          return CustomTransitionPage(
            key: state.pageKey,
            child: InvoicePreviewScreen(invoiceId: invoiceId),
            transitionsBuilder: app_animations.AppPageTransitions.slideTransition,
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),

      // Completed Visits
      GoRoute(
        path: AppRoutePaths.completedVisits,
        name: 'completedVisits',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CompletedVisitsScreen(),
          transitionsBuilder: app_animations.AppPageTransitions.slideTransition,
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.matchedLocation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutePaths.mainNavigation),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Navigator key for accessing navigator from anywhere
final navigatorKey = GlobalKey<NavigatorState>();

