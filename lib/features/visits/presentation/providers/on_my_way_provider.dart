import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'on_my_way_provider.g.dart';

/// On My Way Provider
/// 
/// Manages the "On My Way" text sending state.
@riverpod
class OnMyWay extends _$OnMyWay {
  @override
  int build() {
    return 15; // Default selected minutes
  }

  void updateMinutes(int minutes) {
    state = minutes;
  }
}

/// Generate message text based on selected minutes
String generateMessageText(int minutes, String contactName) {
  return "Hello! This is Prime Appliance Service. We will arrive in approximately $minutes minutes.";
}

