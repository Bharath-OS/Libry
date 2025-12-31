import '../../features/auth/data/model/user_model.dart';
import '../../features/auth/data/services/userdata.dart';

class Validator {
  static String? emptyValidator(String? value) {
    if (value == null || value.isEmpty || value == " ") {
      return "This field can't be empty";
    }
    return null;
  }

  static String? nameValidator(String? name) {
    if (emptyValidator(name) != null) {
      return emptyValidator(name);
    } else {
      if (name!.length <= 2) {
        return 'Name should have more than 2 characters.';
      } else if (_hasNumbers(name)) {
        return "Name can't contain numbers";
      } else if (_hasSpecialCharacters(name)) {
        return 'Name can\'t contain special characters';
      } else {
        return null;
      }
    }
  }

  static bool _hasNumbers(String input) {
    // Matches any digit 0-9
    final numberRegex = RegExp(r'\d');
    return numberRegex.hasMatch(input);
  }

  static bool _hasSpecialCharacters(String name) {
    // special character patter checks if there is any characters other than a-z and A-z
    final specialCharPattern = RegExp(r"[^a-zA-Z'. -]");
    return specialCharPattern.hasMatch(name);
  }

  static String? passwordValidator(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'Password cannot be empty';
    }

    final passwordRegex = RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d!@#\$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]{8,}\$");

    if (!passwordRegex.hasMatch(password)) {
      return "Password must be at least 8 characters, \ninclude upper & lower case letters, \nand a number";
    }

    return null;
  }


  static String? emailValidator(String? email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9](\.?[a-zA-Z0-9_-])*@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$',
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
    UserModel? user = UserModelService.getData();
    if (user?.email == email) {
      return "The email already existing.\nTry Logging instead";
    }
    return emailValidator(email);
  }

  static String? phoneValidator(String? phone) {
    if (phone == null || phone.isEmpty || phone == " ") {
      return 'Phone number cannot be empty';
    } else if (phone.length != 10) {
      return 'Enter valid phone number';
    } else if (phone.contains(RegExp(r'[a-zA-Z]'))) {
      return 'Phone number should not contain alphabets';
    }
    return null;
  }

  static String? yearValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Year is required';
    }

    final year = int.tryParse(value);
    if (year == null) {
      return "Enter a valid year";
    }

    final currentYear = DateTime.now().year;
    if (year < 1500 || year > currentYear) {
      // return 'Enter a valid year between 1500 and ${currentYear}';
      return 'Enter a valid year';
    }
    return null;
  }

  //Validates numbers
  static String? numberValidator({
    required String? value,
    bool isDouble = false,
  }) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final number = isDouble ? double.tryParse(value) : int.tryParse(value);
    if (number == null) {
      return 'Enter a valid number';
    }
    if (number <= 0) {
      return 'Must be greater than 0';
    }
    return null;
  }

  static String? copiesValidator(String? value, String totalBooks) {
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
    if (totalBooksCount != null) {
      if (totalBooksCount < copiesAvailable) {
        return 'available should be less than total copies';
      }
    }
    return null;
  }

  static String? genreValidator(String? value, List<String> existingGenres) {
    if (value == null || value.isEmpty) {
      return 'Genre is required';
    }
    if (existingGenres.contains(value.trim())) {
      return 'Genre already exists';
    }
    return null;
  }

  static String? languageValidator(
    String? language,
    List<String> existingLanguages,
  ) {
    if (language == null || language.isEmpty) {
      return 'Language is required';
    } else if (existingLanguages.contains(language.trim())) {
      return 'Language already exists';
    } else {
      return null;
    }
  }
}
