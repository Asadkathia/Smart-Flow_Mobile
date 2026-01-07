import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_tab_provider.g.dart';

/// Auth Tab Provider
/// 
/// Manages the selected tab (Login/Signup) in the Auth screen.
@riverpod
class AuthTab extends _$AuthTab {
  @override
  int build() {
    return 0; // Default to Login tab
  }

  void switchTab(int index) {
    if (index >= 0 && index <= 1) {
      state = index;
    }
  }
}

