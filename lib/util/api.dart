class API {
  final String baseUrl = "http://localhost:5000/api";

  String get loginUrl => "$baseUrl/auth/loginOfficial";
  String get forgotPasswordUrl => "$baseUrl/auth/forgotPasswordOfficial";
  String get resetPasswordUrl => "$baseUrl/auth/resetPasswordOfficial";
  String get registerOfficialUrl => "$baseUrl/auth/registerOfficial";
  String get getAllOfficialsUrl => "$baseUrl/admin/getAllOfficials";
  String get toggleOfficialStatusUrl => "$baseUrl/admin/toggleOfficialStatus";
  String get profileUrl => "$baseUrl/admin/getOfficialProfile";

  String get getAllTagsUrl => "$baseUrl/admin/getAllTags";
  String get createTagUrl => "$baseUrl/admin/addTag";
  String get toggleTagStatusUrl => "$baseUrl/admin/toggleTagStatus";


  String get getAllDepartmentsUrl => "$baseUrl/admin/getDepartments";

  String get getAllEventsUrl => "$baseUrl/user/getAllEvents";
  String get createEventUrl => "$baseUrl/admin/createEvent";
  String get updateEventUrl => "$baseUrl/admin/editEventData";
  String get getIndividualEventPrefixUrl => "$baseUrl/user/getEventData";


}
