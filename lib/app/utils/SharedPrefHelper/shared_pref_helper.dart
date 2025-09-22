import '../../export/exports.dart';

class Sharedprefhelper {
  static setSharedPrefHelper(String key, String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    print("Shared Preferences\n$key : $value");

    pref.setString(key, value);
  }

  static Future<String?> getSharedPrefHelper(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  static saveToken(String token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    print("Token: $token");
    pref.setString('token', token);
  }

  static Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    return token;
  }

  static Future<void> clearPreferences() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    print("Shared Prefernces Cleared");
    pref.clear();
  }
}
