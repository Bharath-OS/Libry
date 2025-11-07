import 'package:flutter/material.dart';
import 'package:libry/models/user.dart';
import 'package:libry/models/Keys/keys.dart';

class UserData {
  static bool saveData({required User user}) {
    try {
      userDataBox.put(
        UserDatabaseKey.userDataKey,
        User(
          name: user.name,
          libId: user.libId,
          email: user.email,
          password: user.password,
        ),
      );
      setRegisterValue(true);
      return true;
    } catch (e) {
      debugPrint(e as String?);
      return false;
    }
  }

  static User? getData() {
    try {
      User userData = userDataBox.get(UserDatabaseKey.userDataKey);
      return userData;
    } catch (e) {
      debugPrint(e as String?);
      return null;
    }
  }

  static bool? clearData() {
    try {
      userDataBox.clear();
      print("Successfully cleared the data");
      return true;
    } catch (e) {
      debugPrint(e as String?);
      return false;
    }
  }

  static bool? get isLogged {
    try {
      return userDataBox.get(UserDatabaseKey.loginKey, defaultValue: false);
    } catch (e) {
      debugPrint(e as String?);
      return null;
    }
  }

  static bool setLogValue(bool value) {
    try {
      userDataBox.put(UserDatabaseKey.loginKey, value);
      return true;
    } catch (e) {
      debugPrint(e as String?);
      return false;
    }
  }

  static bool? get isRegistered {
    // if(!Hive.isBoxOpen(UserDatabaseKey.userDataKey)) return null;
    try {
      return userDataBox.get(UserDatabaseKey.registerKey, defaultValue: false);
    } catch (e) {
      debugPrint(e as String?);
      return null;
    }
  }

  static bool setRegisterValue(bool value) {
    try {
      userDataBox.put(UserDatabaseKey.registerKey, value);
      return true;
    } catch (e) {
      debugPrint(e as String?);
      return false;
    }
  }
}
