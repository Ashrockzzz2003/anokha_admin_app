import 'dart:convert';

import 'package:crypto/crypto.dart';

class Helper {
  String sha256Hash(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  String roleIdToRoleName(String roleId) {
    switch (roleId) {
      case "1":
        return "Super Admin";
      case "2":
        return "Admin";
      case "3":
        return "Finance";
      case "4":
        return "Department Head";
      case "5":
        return "Eventide Attendance Marker";
      case "6":
        return "Global Attendance Marker";
      case "7":
        return "Local Attendance Marker";
      case "8":
        return "Gate Entry Exit Marker";
      default:
        return "Unknown";
    }
  }
}
