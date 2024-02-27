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

  List<String> roleNameList = [
    "All",
    "Super Admin",
    "Admin",
    "Finance",
    "Department Head",
    "Eventide Attendance Marker",
    "Global Attendance Marker",
    "Local Attendance Marker",
    "Gate Entry Exit Marker"
  ];

  String roleNameToRoleId(String roleName) {
    switch (roleName) {
      case "Super Admin":
        return "1";
      case "Admin":
        return "2";
      case "Finance":
        return "3";
      case "Department Head":
        return "4";
      case "Eventide Attendance Marker":
        return "5";
      case "Global Attendance Marker":
        return "6";
      case "Local Attendance Marker":
        return "7";
      case "Gate Entry Exit Marker":
        return "8";
      default:
        return "Unknown";
    }
  }
}
