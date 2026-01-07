import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:smartflowpro/features/ai_assistant/presentation/screens/ai_assistant_screen.dart';
import 'package:smartflowpro/shared/presentation/widgets/sync_indicator.dart';
import 'package:smartflowpro/features/visits/presentation/screens/home_screen.dart';
import 'package:smartflowpro/features/visits/presentation/screens/schedule_screen.dart';
import 'package:smartflowpro/features/settings/presentation/screens/more_screen.dart';
import '../providers/main_navigation_provider.dart';
import '../widgets/custom_bottom_nav_bar.dart';

/// Main Navigation Screen - Riverpod Version
/// 
/// Displays the main app navigation with bottom navigation bar.
/// Manages navigation between Home, Schedule, Chat, AI Assistant, and More screens.
/// Uses Riverpod for state management.
class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainNavigationProvider);

    final pages = <Widget>[
      const HomeScreen(),
      const ScheduleScreen(),
      const ChatListScreen(),
      const AiAssistantScreen(),
      const MoreScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          const SyncIndicator(), // Add sync indicator
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(mainNavigationProvider.notifier).changePage(index),
      ),
    );
  }
}

