import '../../export/exports.dart';

class CustomToast {
  static void show(
    String message, {
    Color bgColor = AppColors.darkGrey,
    Color textColor = AppColors.whiteColor,
  }) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: 14,
      gravity: ToastGravity.BOTTOM,
      toastLength: message.length < 30 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
    );
  }

  static void success(String message) {
    show(message, bgColor: AppColors.successColor, textColor: Colors.white);
  }

  static void error(String message) {
    show(message, bgColor: AppColors.errorColor, textColor: Colors.white);
  }

  static void info(String message) {
    show(message, bgColor: AppColors.blackColor, textColor: Colors.white);
  }
}
