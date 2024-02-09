class API {
  final String baseUrl = "http://localhost:5000/api";

  String get loginUrl => "$baseUrl/auth/loginOfficial";
  String get forgotPasswordUrl => "$baseUrl/auth/forgotPasswordOfficial";
  String get resetPasswordUrl => "$baseUrl/auth/resetPasswordOfficial";
  String get registerOfficialUrl => "$baseUrl/auth/registerOfficial";
  String get getAllOfficialsUrl => "$baseUrl/admin/getAllOfficials";

}
