class API {
  final String baseUrl = "https://web.abhinavramakrishnan.tech/api";

  String get loginUrl => "$baseUrl/auth/loginAdmin";
  String get forgotPasswordUrl => "$baseUrl/auth/forgotPasswordAdmin";
  String get resetPasswordUrl => "$baseUrl/auth/resetPasswordAdmin";
}
