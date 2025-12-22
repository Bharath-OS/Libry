import 'package:flutter/material.dart';
import 'package:libry/features/auth/data/model/user_model.dart';
import 'package:libry/features/auth/data/services/userdata.dart';

import '../view/main_screen.dart';

class AuthViewModel with ChangeNotifier {
  late UserModel _user;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthViewModel({required UserModel user}) {
    _user = user;
  }

  bool registerUser({required UserModel user, required BuildContext context}) {
    _isLoading = true;
    notifyListeners();

    bool isSuccess = UserModelService.saveData(user: user, context: context);

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  bool loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    _isLoading = true;
    notifyListeners();
    bool isSuccess = false;
    final savedUser = UserModelService.getData();
    if (savedUser != null &&
        savedUser.email == email &&
        savedUser.password == password) {
      isSuccess = UserModelService.setLogValue(true);
    }
    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }
}
