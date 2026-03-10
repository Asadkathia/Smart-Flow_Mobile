import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_provider.dart';

part 'profile_provider.g.dart';

/// Profile Editing State Provider
/// 
/// Manages whether the profile is in edit mode.
@riverpod
class ProfileEditing extends _$ProfileEditing {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }

  void setEditing(bool value) {
    state = value;
  }
}

/// Profile Provider
/// 
/// Manages profile updates and operations.
@riverpod
class Profile extends _$Profile {
  @override
  FutureOr<void> build() {}

  /// Update user profile
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    // TODO: Implement API call to update profile
    // For now, just update the local user model
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      // Update user model (this will be implemented when auth provider is fully set up)
      // await ref.read(authNotifierProvider.notifier).updateProfile(...);
    }
  }
}

