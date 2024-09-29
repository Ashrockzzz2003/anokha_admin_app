import 'package:flutter/cupertino.dart';

// String _baseUrl = "https://anokha.amrita.edu/api";
String _baseUrl = "https://anokha.amrita.edu/api";

class API {
  // final String _baseUrl = "http://localhost:5000/api";
  // final String _baseUrl = "https://web.abhinavramakrishnan.tech/api";

  bool setBaseUrl(String url) {
    debugPrint("Setting base url to: $url");
    _baseUrl = url;
    return true;
  }

  String get baseUrl => _baseUrl;

  String get loginUrl => "$_baseUrl/auth/loginOfficial";
  String get forgotPasswordUrl => "$_baseUrl/auth/forgotPasswordOfficial";
  String get resetPasswordUrl => "$_baseUrl/auth/resetPasswordOfficial";
  String get registerOfficialUrl => "$_baseUrl/auth/registerOfficial";
  String get getAllOfficialsUrl => "$_baseUrl/admin/getAllOfficials";
  String get toggleOfficialStatusUrl => "$_baseUrl/admin/toggleOfficialStatus";

  String get profileUrl => "$_baseUrl/admin/getOfficialProfile";
  String get editProfileUrl => "$_baseUrl/admin/editOfficialProfile";

  String get getAllTagsUrl => "$_baseUrl/admin/getAllTags";
  String get createTagUrl => "$_baseUrl/admin/addTag";
  String get toggleTagStatusUrl => "$_baseUrl/admin/toggleTagStatus";

  String get getAllDepartmentsUrl => "$_baseUrl/admin/getDepartments";

  String get getAllEventsUrl => "$_baseUrl/admin/getOfficialEvents";
  String get createEventUrl => "$_baseUrl/admin/createEvent";
  String get updateEventUrl => "$_baseUrl/admin/editEventData";
  String get getIndividualEventPrefixUrl => "$_baseUrl/user/getEventData";

  String get markAttendanceEntryUrl => "$_baseUrl/admin/markEventAttendanceEntry";
  String get markEventAttendanceExitUrl => "$_baseUrl/admin/markEventAttendanceExit";

}
