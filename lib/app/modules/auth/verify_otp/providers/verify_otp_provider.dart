import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// OTP Timer State
class OtpTimerState {
  final int secondsRemaining;
  final bool isTimerActive;

  const OtpTimerState({
    required this.secondsRemaining,
    required this.isTimerActive,
  });

  OtpTimerState copyWith({
    int? secondsRemaining,
    bool? isTimerActive,
  }) {
    return OtpTimerState(
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isTimerActive: isTimerActive ?? this.isTimerActive,
    );
  }
}

/// OTP Timer Notifier
class OtpTimerNotifier extends StateNotifier<OtpTimerState> {
  Timer? _timer;

  OtpTimerNotifier() : super(const OtpTimerState(secondsRemaining: 60, isTimerActive: true)) {
    startTimer();
  }

  void startTimer() {
    state = state.copyWith(secondsRemaining: 60, isTimerActive: true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining > 0) {
        state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
      } else {
        _timer?.cancel();
        state = state.copyWith(isTimerActive: false);
      }
    });
  }

  void reset() {
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// OTP Timer Provider
final otpTimerProvider = StateNotifierProvider.autoDispose<OtpTimerNotifier, OtpTimerState>((ref) {
  return OtpTimerNotifier();
});



