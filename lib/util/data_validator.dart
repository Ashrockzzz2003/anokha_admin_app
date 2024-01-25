class DataValidator {
  String? emailValidator(String? value) {
    final emailRegex = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.?[a-zA-Z]+)$');
    if (value!.isEmpty) {
      return 'Please enter Email';
    }
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid Email';
    }
    return null;
  }

  String? passwordValidator(String? password) {
    if ((password == null) || (password.isEmpty)) {
      return "Please enter a Password";
    }

    if (password.length < 8) {
      return "Password must be at least 8 characters long";
    }

    if (password.contains(" ")) {
      return "Password cannot have spaces.";
    }

    return null;
  }

  String? otpValidator(String? otp) {
    if ((otp == null) || (otp.isEmpty)) {
      return "Please enter an OTP";
    }

    if (otp.length != 6) {
      return "OTP must be 6 characters long";
    }

    if (otp.contains(" ")) {
      return "OTP cannot have spaces.";
    }

    return null;
  }
}
