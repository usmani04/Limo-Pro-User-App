import 'package:shared_preferences/shared_preferences.dart';

class TokenHandler {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  static Future<void> saveEmail(String mail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', mail);
  }
}
