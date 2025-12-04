import 'package:libry/database/userdata.dart';

import '../models/user_model.dart';

class Validator {
  static String? emptyValidator(String? value) {
    if (value == null || value.isEmpty || value == " ") {
      return "This field can't be empty";
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password == null || password.isEmpty || password == " ") {
      return 'Password cannot be empty';
    }
    // final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
    // if(!passwordRegex.hasMatch(password)){
    //   return "Invalid password";
    // }
    else if (password.length <= 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  static String? emailValidator(String? email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );
    if (email == null || email.isEmpty || email == " ") {
      return 'Email cannot be empty';
    } else if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? registerEmailValidator(String? email) {
    User? user = UserDatabase.getData();
    if (user?.email == email) {
      return "The email already existing.\nTry Logging instead";
    }
    return emailValidator(email);
  }

  static String? phoneValidator(String? phone) {
    if (phone == null || phone.isEmpty || phone == " ") {
      return 'Phone number cannot be empty';
    } else if (phone.length != 10) {
      return 'Phone number should be 10 digit';
    } else if (phone.contains(RegExp(r'[a-zA-Z]'))) {
      return 'Phone number should not contain alphabets';
    }
    return null;
  }

  static String? yearValidator(String? value){
    if (value == null || value.isEmpty) {
      return 'Year is required';
    }

    final year = int.tryParse(value);
    if(year == null){
      return "Enter a valid year";
    }

    final currentYear = DateTime.now().year;
    if(year < 1500 || year >= currentYear){
      return 'Enter a valid year between 1500 and ${currentYear}';
    }
    return null;
  }

  //Validates numbers
  static String? numberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return 'Enter a valid number';
    }
    if (number <= 0) {
      return 'Must be greater than 0';
    }
    return null;
  }

  static String? copiesValidator(String? value, String totalBooks){
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final copiesAvailable = int.tryParse(value);
    final totalBooksCount = int.tryParse(totalBooks);
    if (copiesAvailable == null) {
      return 'Enter a valid number';
    }
    if (copiesAvailable <= 0) {
      return 'Must be greater than 0';
    }
    if(totalBooksCount != null){
      if(totalBooksCount < copiesAvailable){
        return 'available should be less than total copies';
      }
    }
    return null;
  }
}
