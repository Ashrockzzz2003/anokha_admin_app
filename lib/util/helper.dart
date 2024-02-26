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

  List<String> departmentNameList = [
    "Electrical and Electronics Engineering",
    "Mechanical Engineering",
    "Cyber Security",
    "Mathematics",
    "Electronics and Communication Engineering",
    "Computer Science and Engineering",
    "Social Work",
    "Civil Engineering",
    "Agriculture",
    "English",
    "Chemical Engineering",
    "Aerospace Engineering",
    "Computer Engineering and Networking",
    "Team Media - Club",
    "Amrita Centre for Entrepreneurship",
    "Department of Science",
    "Nivesha - Club",
    "Department of Mass Communication",
    "Elite - Club",
    "Corporate and Industry Relations",
    "Eventide",
    "Toastmasters - Club"
  ];


  Map<String, String> deptNameToId = {
    "Electrical and Electronics Engineering": "1",
    "Mechanical Engineering": "2",
    "Cyber Security": "3",
    "Mathematics": "4",
    "Electronics and Communication Engineering": "5",
    "Computer Science and Engineering": "6",
    "Social Work": "7",
    "Civil Engineering": "8",
    "Agriculture": "9",
    "English": "10",
    "Chemical Engineering": "11",
    "Aerospace Engineering": "12",
    "Computer Engineering and Networking": "13",
    "Team Media - Club": "14",
    "Amrita Centre for Entrepreneurship": "15",
    "Department of Science": "16",
    "Nivesha - Club": "17",
    "Department of Mass Communication": "18",
    "Elite - Club": "19",
    "Corporate and Industry Relations": "20",
    "Eventide": "21",
    "Toastmasters - Club": "22"
  };
}
