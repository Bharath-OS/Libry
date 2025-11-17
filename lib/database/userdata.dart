import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/adapters.dart';
import 'package:libry/models/user_model.dart';
import 'package:libry/models/Keys/keys.dart';

class UserDatabase {
  // static bool initializeDatabase(){
  //   if(!Hive.isBoxOpen('userDataBox')) {
  //     Hive.initFlutter();
  //     return true;
  //   }
  //   else return false;
  // }
  //Saves the user data to Hive Database
  static bool saveData({required User user}) {
    try {
      userDataBox.put(
        UserDatabaseKey.userDataKey,
        User(
          name: user.name,
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

  //Retrieves the user data from Hive Database
  static User? getData() {
    try {
      User UserDatabase = userDataBox.get(UserDatabaseKey.userDataKey);
      return UserDatabase;
    } catch (e) {
      debugPrint(e as String?);
      return null;
    }
  }

  static String get getUserName {
    try {
      User user = userDataBox.get(UserDatabaseKey.userDataKey);
      return user.name;
    }
    catch(e){
      debugPrint("Exception: $e");
      return "No Name";
    }
  }

  //Clears the user data from Hive Database
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

  //Returns the user Log status
  static bool get isLogged {
    return statusBox.get(UserDatabaseKey.loginKey, defaultValue: false);
  }

  //Sets the user log status
  static bool setLogValue(bool value) {
    try {
      statusBox.put(UserDatabaseKey.loginKey, value);
      return true;
    } catch (e) {
      debugPrint(e as String?);
      return false;
    }
  }

  //Returns the user register status
  static bool get isRegistered {
    return statusBox.get(UserDatabaseKey.registerKey, defaultValue: false);
  }

  //Sets the user register status
  static bool setRegisterValue(bool value) {
    try {
      statusBox.put(UserDatabaseKey.registerKey, value);
      return true;
    } catch (e) {
      debugPrint(e as String?);
      return false;
    }
  }

  static bool editData({required String userName, required String email}){
    User? user = getData();
    if(user!=null){
      user.name = userName;
      user.email = email;
      userDataBox.put(UserDatabaseKey.userDataKey, user);
      return true;
    }
    else{
      return false;
    }
  }
}
