class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  static const String signup = '$baseUrl/auth/signup';
  static const String verifyEmail = '$baseUrl/auth/verify';
  static const String signin = '$baseUrl/auth/login';

  static const String feedback = '$baseUrl/feedback';
  static const String myFeedback = '$baseUrl/feedback/my';
  static const String createFeedback = '$baseUrl/feedback/create';
  static const String allFeedbacks = '$baseUrl/feedback/all';
  static String updateFeedback(int id) => '$baseUrl/feedback/$id';
  static String promoteAdmin(String email) =>
      '$baseUrl/auth/promote-admin?email=${Uri.encodeComponent(email)}';

  static String demoteUser(String email) =>
      '$baseUrl/auth/demote-user?email=${Uri.encodeComponent(email)}';
}
