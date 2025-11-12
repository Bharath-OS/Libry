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
    if (email == null || email.isEmpty || email == " ") {
      return 'Email cannot be empty';
    }
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? phoneValidator(String? phone){
    if (phone == null || phone.isEmpty || phone == " ") {
      return 'Phone number cannot be empty';
    }
    else if(phone.length != 10){
      return 'Phone number should be 10 digit';
    }
    else if(phone.contains(RegExp(r'[a-zA-Z]'))){
      return 'Phone number should not contain alphabets';
    }
    return null;
  }
}
