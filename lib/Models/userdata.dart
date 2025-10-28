import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {

  static SharedPreferences? _pref;
  static const String _userKey = "user_data";
  static const String _logKey = 'logKey';
  static const String _registerKey = 'registerKey';

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

  static Future<bool> clearData() async {
    try {
      final pref = await _instance;
      return await pref.remove(_userKey);
    } catch (e) {
      print("Error clearing data: $e");
      return false;
    }
  }

  static Future<bool?> get isLogged async{
    try{
      final pref = await _instance;
      return pref.getBool(_logKey)??false;
    }
    catch(e){
      return null;
    }
  }
  static Future<void> setLogValue(bool value) async {
    try {
      final pref = await _instance;
      await pref.setBool(_logKey, value);
    } catch (e) {
      print(e);
    }
  }

  static Future<bool?> get isRegistered async{
    try{
      final pref = await _instance;
      return pref.getBool(_registerKey)??false;
    }
    catch(e){
      print(e);
    }
  }

  static Future<void> setRegisterValue(bool value) async{
    try{
      final pref = await _instance;
      await pref.setBool(_registerKey, value);
    }
    catch(e){
      print(e);
    }
  }
}
