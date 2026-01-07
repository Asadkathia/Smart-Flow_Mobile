import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_provider.g.dart';

/// Signup Password Visibility Provider
/// 
/// Manages password visibility states for signup form.
@riverpod
class SignupPasswordVisibility extends _$SignupPasswordVisibility {
  @override
  SignupPasswordVisibilityState build() {
    return SignupPasswordVisibilityState(
      isPasswordVisible: false,
      isConfirmPasswordVisible: false,
    );
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }
}

/// Signup Password Visibility State
class SignupPasswordVisibilityState {
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  SignupPasswordVisibilityState({
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
  });

  SignupPasswordVisibilityState copyWith({
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return SignupPasswordVisibilityState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }
}



