class LoginResponse {
  final bool success;
  final String error;

  String username;

  LoginResponse({this.success, this.error});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json["success"],
      error: json.containsKey("error") ? json["error"] : null,
    );
  }
}