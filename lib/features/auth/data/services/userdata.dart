import 'package:flutter/material.dart';
import 'package:libry/features/auth/data/model/user_model.dart';
import 'package:libry/features/auth/data/model/keys.dart';

class UserModelService {
  static bool saveData({required UserModel user}) {
    try {
      userDataBoxNew.put(
        DatabaseKeys.userDataKey,
        UserModel(name: user.name, email: user.email, password: user.password),
      );
      setRegisterValue(true);
      setLogValue(true);
      return true;
    } catch (e) {
      return false;
    }
  }

  //Retrieves the user data from Hive Database
  static UserModel? getData() {
    try {
      UserModel user =
          userDataBoxNew.get(DatabaseKeys.userDataKey) ??
          UserModel(name: "Guest", email: "guest@gmail.com");
      return user;
    } catch (e) {
      debugPrint('Exception caught: $e');
      return null;
    }
  }

  static String get getUserModelName {
    try {
      UserModel user = userDataBoxNew.get(DatabaseKeys.userDataKey);
      return user.name;
    } catch (e) {
      debugPrint("Exception: $e");
      return "No Name";
    }
  }

  //Clears the user data from Hive Database
  static bool? clearData() {
    try {
      userDataBoxNew.clear();
      return true;
    } catch (e) {
      debugPrint(e as String?);
      return false;
    }
  }

  //Returns the user Log status
  static bool get isLogged {
    return statusBox.get(DatabaseKeys.loginKey, defaultValue: false);
  }

  //Sets the user log status
  static bool setLogValue(bool value) {
    try {
      statusBox.put(DatabaseKeys.loginKey, value);
      return true;
    } catch (e) {
      debugPrint(e as String?);
      return false;
    }
  }

  //Returns the user register status
  static bool get isRegistered {
    return statusBox.get(DatabaseKeys.registerKey, defaultValue: false);
  }

  //Sets the user register status
  static bool setRegisterValue(bool value) {
    try {
      statusBox.put(DatabaseKeys.registerKey, value);
      return true;
    } catch (e) {
      debugPrint(e as String?);
      return false;
    }
  }

  //Editing user data
  static bool editData({required UserModel user}) {
    try{
      final updatedUserModel = UserModel(
        name: user.name,
        email: user.email,
        password: user.password,
      );
      userDataBoxNew.put(DatabaseKeys.userDataKey, updatedUserModel);
      return true;
     }
     catch(e){
      debugPrint('Error editing user data: $e');
      return false;
     }
  }
}
