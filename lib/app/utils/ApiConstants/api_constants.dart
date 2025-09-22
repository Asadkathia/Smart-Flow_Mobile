class ApiConstants {
  static const String BASE_URL = 'https://api.mail.tm/';
}

class ApiUrls {
  static const String domains = '${ApiConstants.BASE_URL}domains';
  static const String generateEmail = '${ApiConstants.BASE_URL}accounts';
  static const String getToken = '${ApiConstants.BASE_URL}token';
  static const String getAllMessages = "${ApiConstants.BASE_URL}messages";
  static const String getMessageDetails = "${ApiConstants.BASE_URL}messages/";
}
