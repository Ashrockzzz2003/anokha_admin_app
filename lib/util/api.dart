class API {
  final String baseUrl = "https://web.abhinavramakrishnan.tech/api";

  String get loginUrl => "$baseUrl/auth/loginOfficial";
  String get forgotPasswordUrl => "$baseUrl/auth/forgotPasswordOfficial";
  String get resetPasswordUrl => "$baseUrl/auth/resetPasswordOfficial";
  String get registerOfficialUrl => "$baseUrl/auth/registerOfficial";

}
