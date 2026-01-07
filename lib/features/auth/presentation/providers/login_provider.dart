import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_provider.g.dart';

/// Login Provider
/// 
/// Manages login form state including password visibility.
@riverpod
class Login extends _$Login {
  @override
  bool build() {
    return false; // isPasswordVisible
  }

  void togglePasswordVisibility() {
    state = !state;
  }
}

