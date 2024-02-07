class DataValidator {
  String? deptValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a Department';
    }
    // string number in range 1-22
    final roleRegex = RegExp(r'^[1-9]$|^1[0-9]$|^2[0-2]$');
    if (!roleRegex.hasMatch(value)) {
      return 'Please select a valid Department';
    }
    return null;
  }

  String? roleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a Role';
    }
    final roleRegex = RegExp(r'^[1-8]$');
    if (!roleRegex.hasMatch(value)) {
      return 'Please select a valid Role';
    }
    return null;
  }

  String? phoneValidator(String? value) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (value == null || value.isEmpty) {
      return 'Please enter Phone Number';
    }
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid Phone Number';
    }
    return null;
  }

  String? fullNameValidator(String? value) {
    final fullNameRegex =
        RegExp(r'^[a-zA-Z]+(?:\s[a-zA-Z]+)*(?:\.[a-zA-Z]+)*$');
    if (value == null || value.isEmpty) {
      return 'Please enter Full Name';
    }
    if (!fullNameRegex.hasMatch(value)) {
      return 'Please enter a valid Full Name';
    }
    return null;
  }

  String? emailValidator(String? value) {
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9]+(?:\.[a-zA-Z0-9]+)*@[a-zA-Z0-9]+(?:\.[a-zA-Z0-9]+)*$');
    if (value == null || value.isEmpty) {
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
