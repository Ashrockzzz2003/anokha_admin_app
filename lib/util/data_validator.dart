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

  // EventDataValidator

  /*
  * {
    "eventName":"test-event",
    "eventDescription":"This is a test event",
    "eventMarkdownDescription":"MD DESC",
    "eventDate":"2023-03-08",
    "eventTime":"15:00:00",
    "eventVenue":"Amriteshwari Hall",
    "eventImageURL":"https://i.imgur.com/iQy8GLM.jpg",
    "eventPrice":400,
    "maxSeats":100,
    "minTeamSize":2,
    "maxTeamSize":5,
    "isWorkshop":"0",
    "isTechnical":"1",
    "isGroup":"1",
    "isPerHeadPrice":"0",
    "isRefundable":"1",
    "needGroupData":"1",
    "eventDepartmentId":3,
    "tags":[1,2]
    } */

  String? eventNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Event Name';
    }

    return null;
  }

  String? eventDescriptionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Event Description';
    }

    return null;
  }

  String? eventMarkdownDescriptionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Event Markdown Description';
    }

    return null;
  }

  String? eventDateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Event Date';
    }

    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(value)) {
      return 'Please enter a valid Event Date';
    }

    return null;
  }

  String? eventTimeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Event Time';
    }

    return null;
  }

  String? eventVenueValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Event Venue';
    }

    return null;
  }

  String? eventImageURLValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Event Image URL';
    }

    return null;
  }

  String? eventPriceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Event Price';
    }

    final priceRegex = RegExp(r'^\d+$');
    if (!priceRegex.hasMatch(value)) {
      return 'Please enter a valid Event Price';
    }

    return null;
  }

  String? maxSeatsValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Max Seats';
    }

    final maxSeatsRegex = RegExp(r'^\d+$');
    if (!maxSeatsRegex.hasMatch(value)) {
      return 'Please enter a valid Max Seats';
    }

    return null;
  }

  String? minTeamSizeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Min Team Size';
    }

    final minTeamSizeRegex = RegExp(r'^\d+$');
    if (!minTeamSizeRegex.hasMatch(value)) {
      return 'Please enter a valid Min Team Size';
    }

    return null;
  }

  String? maxTeamSizeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Max Team Size';
    }

    final maxTeamSizeRegex = RegExp(r'^\d+$');
    if (!maxTeamSizeRegex.hasMatch(value)) {
      return 'Please enter a valid Max Team Size';
    }

    return null;
  }

  String? isWorkshopValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select Is Workshop';
    }

    final isWorkshopRegex = RegExp(r'^[0-1]$');
    if (!isWorkshopRegex.hasMatch(value)) {
      return 'Please select a valid Is Workshop';
    }

    return null;
  }

  String? isTechnicalValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select Is Technical';
    }

    final isTechnicalRegex = RegExp(r'^[0-1]$');
    if (!isTechnicalRegex.hasMatch(value)) {
      return 'Please select a valid Is Technical';
    }

    return null;
  }

  String? isGroupValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select Is Group';
    }

    final isGroupRegex = RegExp(r'^[0-1]$');
    if (!isGroupRegex.hasMatch(value)) {
      return 'Please select a valid Is Group';
    }

    return null;
  }

  String? isPerHeadPriceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select Is Per Head Price';
    }

    final isPerHeadPriceRegex = RegExp(r'^[0-1]$');
    if (!isPerHeadPriceRegex.hasMatch(value)) {
      return 'Please select a valid Is Per Head Price';
    }

    return null;
  }

  String? isRefundableValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select Is Refundable';
    }

    final isRefundableRegex = RegExp(r'^[0-1]$');
    if (!isRefundableRegex.hasMatch(value)) {
      return 'Please select a valid Is Refundable';
    }

    return null;
  }

  String? needGroupDataValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select Need Group Data';
    }

    final needGroupDataRegex = RegExp(r'^[0-1]$');
    if (!needGroupDataRegex.hasMatch(value)) {
      return 'Please select a valid Need Group Data';
    }

    return null;
  }

  String? tagListValidator(List<String>? value) {
    if (value == null || value.isEmpty) {
      return 'Please select Tags';
    }

    return null;
  }
}
