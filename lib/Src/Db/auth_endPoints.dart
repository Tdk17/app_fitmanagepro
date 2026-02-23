const String baseUrl = 'https://parseapi.back4app.com/functions';

abstract class AuthEndpoints {
  static const String login = '$baseUrl/login'; // <- sua Cloud Function
  static const String register = '$baseUrl/register'; // <- se tiver
  static const String deshboard = '$baseUrl/dashboard-get'; // <- opcional
  static const String signupPersonal = '$baseUrl/signup-personal';
  static const String createStudentV2 = '$baseUrl/create-student-v2';
  static const String dashboardGet = '$baseUrl/dashboard-get';
  static const String studentsList = '$baseUrl/students-list';
  static const String sendCharge = '$baseUrl/send-charge';
  static const String getStudents = '$baseUrl/get-students';
  static const String workoutSave = '$baseUrl/workout-save';
  // ✅ sua cloud function de validação
  static const String validateCref = '$baseUrl/validate_cref';
}
