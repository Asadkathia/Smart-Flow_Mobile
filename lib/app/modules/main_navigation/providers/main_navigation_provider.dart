import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Main Navigation Index Provider
/// 
/// Manages the current selected index for bottom navigation.
/// 0 = Home, 1 = Schedule, 2 = Chat, 3 = AI Assistant, 4 = More
class MainNavigationNotifier extends StateNotifier<int> {
  MainNavigationNotifier() : super(0);

  void changePage(int index) {
    // Ensure index is within valid range (0-4 for 5 tabs)
    if (index >= 0 && index < 5) {
      state = index;
    }
  }

  void goToHome() => state = 0;
  void goToSchedule() => state = 1;
  void goToChat() => state = 2;
  void goToAiAssistant() => state = 3;
  void goToMore() => state = 4;
  
  // Alias for consistency
  void setIndex(int index) {
    changePage(index);
  }
}

/// Main Navigation Provider
final mainNavigationProvider = StateNotifierProvider<MainNavigationNotifier, int>((ref) {
  return MainNavigationNotifier();
});

