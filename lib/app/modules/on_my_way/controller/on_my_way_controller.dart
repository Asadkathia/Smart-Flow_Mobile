import '../../../export/exports.dart';

class OnMyWayController extends GetxController {
  // Observable for selected minutes
  final RxInt selectedMinutes = 15.obs;

  // Contact information
  final String contactName = "Donald Richards";
  final String contactType = "Primary Contact";

  // Available time options
  final List<int> timeOptions = [5, 10, 15, 30, 45, 60];

  // Get the message text
  String get messageText =>
      "Hello! This is Prime Appliance Service. We will arrive in approximately ${selectedMinutes.value} minutes.";

  // Method to update selected minutes
  void updateMinutes(int minutes) {
    selectedMinutes.value = minutes;
  }
}
