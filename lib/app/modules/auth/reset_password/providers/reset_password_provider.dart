import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reset Password Visibility State
class ResetPasswordVisibilityState {
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  const ResetPasswordVisibilityState({
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  ResetPasswordVisibilityState copyWith({
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return ResetPasswordVisibilityState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }
}

/// Reset Password Visibility Notifier
class ResetPasswordVisibilityNotifier extends StateNotifier<ResetPasswordVisibilityState> {
  ResetPasswordVisibilityNotifier() : super(const ResetPasswordVisibilityState());

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible);
  }
}

/// Reset Password Visibility Provider
final resetPasswordVisibilityProvider =
    StateNotifierProvider.autoDispose<ResetPasswordVisibilityNotifier, ResetPasswordVisibilityState>((ref) {
  return ResetPasswordVisibilityNotifier();
});

/// Reset Password Loading State Provider
final resetPasswordLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);



