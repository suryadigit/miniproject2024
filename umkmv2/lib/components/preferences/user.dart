import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String loggedInKey = 'loggedIn';
  static const String userIdKey = 'userId';
  static const String userEmailKey = 'userEmail';

  static Future<void> setUserLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loggedInKey, value);
  }

  static Future<bool> getUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loggedInKey) ?? false;
  }

  static Future<void> setUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  static Future<void> setUserEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userEmailKey, email);
  }

  static Future<String?> getUserEmail() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? savedEmail = prefs.getString(userEmailKey);
      if (savedEmail != null) {
        return savedEmail;
      } else {
        const String apiUrl =
            'https://yhvagkgcvehcbsexctmh.supabase.co/rest/v1/';
        final Response response = await Dio().get(apiUrl);

        if (response.statusCode == 200) {
          final email = response.data['Email'] as String;
          await setUserEmail(email);
          return email;
        } else {
          return null;
        }
      }
    } catch (error) {
      return null;
    }
  }
}
