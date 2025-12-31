import 'package:flutter/material.dart';
import 'package:libry/features/auth/data/model/user_model.dart';
import 'package:libry/features/auth/data/services/userdata.dart';

import '../../home/views/main_screen.dart';

class AuthViewModel with ChangeNotifier {
  late UserModel _user;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthViewModel({required UserModel user}) {
    _user = user;
  }

  String? registerUser({
    required UserModel user,
    required BuildContext context,
  }) {
    _isLoading = true;
    notifyListeners();

    bool isSuccess = UserModelService.saveData(user: user);

    _isLoading = false;
    notifyListeners();
    if (isSuccess) {
      return null;
    } else {
      return "Something went wrong. Try again later.";
    }
  }

  String? loginUser({required String email, required String password}) {
    _isLoading = true;
    notifyListeners();
    bool isSuccess = false;
    final savedUser = UserModelService.getData();
    if (savedUser != null &&
        savedUser.email == email &&
        savedUser.password == password) {
      isSuccess = UserModelService.setLogValue(true);
      if (isSuccess) {
        _isLoading = false;
        notifyListeners();
        return null;
      }
      else{
        return "Something went wrong. Try again later";
      }
    } else {
      return "Invalid credentials";
    }
  }

  String? editUser({required UserModel updatedUser}){
    final result = UserModelService.editData(user: updatedUser);
    notifyListeners();
    if(result){
      return "Profile updated successfully";
    }
    else{
      return "Failed to update profile";
    }
  }
}
