import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {

  static SharedPreferences? _pref;
  static const String _userKey = "user_data";

  static Future<SharedPreferences> get _instance async {
    _pref ??= await SharedPreferences.getInstance();
    return _pref!;
  }

  static Future<bool> saveData({required Map<String, String> userdata}) async {
    try {
      final pref = await _instance;
      final encodedMap = jsonEncode(userdata);
      await pref.setString(_userKey, encodedMap);
      return true;
    } catch (e) {
      print("Error saving data: $e");
      return false;
    }
  }

  static Future<Map<String, String>?> getData() async {
    try {
      final pref = await _instance;
      final userData = pref.getString(_userKey);
      if (userData == null) return null;

      final decoded = jsonDecode(userData);
      return Map<String, String>.from(decoded);
    } catch (e) {
      print("Error retrieving data: $e");
      return null;
    }
  }

  /// Optional: Clear saved user data
  static Future<bool> clearData() async {
    try {
      final pref = await _instance;
      return await pref.remove(_userKey);
    } catch (e) {
      print("Error clearing data: $e");
      return false;
    }
  }
}
