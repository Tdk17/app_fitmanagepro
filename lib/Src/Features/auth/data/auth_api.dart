import 'package:app_fitmanagerpro/Src/App/model/user_model.dart';
import 'package:app_fitmanagerpro/Src/Db/auth_endPoints.dart';
import 'package:app_fitmanagerpro/Src/Db/http_manager..dart';

class CrefValidationResult {
  final bool isValid;
  final String? name;
  final String? status;
  final String? uf;

  CrefValidationResult({
    required this.isValid,
    this.name,
    this.status,
    this.uf,
  });

  factory CrefValidationResult.fromJson(Map<String, dynamic> json) {
    return CrefValidationResult(
      isValid: json['isValid'] == true,
      name: json['name']?.toString(),
      status: json['status']?.toString(),
      uf: json['uf']?.toString(),
    );
  }
}

class AuthApi {
  AuthApi(this._http);

  final HttpManager _http;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final result = await _http.restRequest(
      url: AuthEndpoints.login,
      method: HttpMethod.post,
      body: {'email': email, 'password': password},
    );

    if (_hasError(result)) throw Exception(_errorMessage(result));

    final data = _unwrapResultMap(result);
    return UserModel.fromJson(data);
  }

  Future<CrefValidationResult> validateCref({
    required String crefNumber,
    String? uf,
  }) async {
    final result = await _http.restRequest(
      url: AuthEndpoints.validateCref,
      method: HttpMethod.post,
      body: {
        // ✅ ajuste aqui conforme sua Cloud Function espera:
        // se a function espera "crefNumber", troque a key.
        'crefNumber': crefNumber,
        'uf': uf,
      },
    );

    if (_hasError(result)) throw Exception(_errorMessage(result));

    final data = _unwrapResultMap(result);
    return CrefValidationResult.fromJson(data);
  }

  /// ✅ CADASTRO DO PROFESSOR (igual sua tela)
  Future<UserModel> signupPersonal({
    required String name,
    required String email,
    required String password,
    required String city,
    required String niche,
    required String crefNumber,
    String? crefUf,
  }) async {
    final result = await _http.restRequest(
      url: AuthEndpoints.signupPersonal,
      method: HttpMethod.post,
      body: {
        "name": name,
        "email": email,
        "password": password,
        "city": city,
        "niche": niche,
        "crefNumber": crefNumber,
        "crefUf": crefUf,
      },
    );

    if (_hasError(result)) throw Exception(_errorMessage(result));

    final data = _unwrapResultMap(result);
    return UserModel.fromJson(data);
  }

  // ----------------- Helpers -----------------

  bool _hasError(Map<String, dynamic> map) {
    // alguns managers setam { error: true, message: ... }
    if (map['error'] == true) return true;

    // Parse costuma retornar: { "code": 141, "error": "..." }
    if (map.containsKey('code') && map.containsKey('error')) return true;

    // alguns backends: { "error": "..." }
    if (map['error'] is String) return true;

    return false;
  }

  String _errorMessage(Map<String, dynamic> map) {
    if (map['message'] != null) return map['message'].toString();
    if (map['error'] != null) return map['error'].toString();
    return 'Erro na requisição';
  }

  Map<String, dynamic> _unwrapResultMap(Map<String, dynamic> map) {
    // Parse Cloud geralmente vem: { "result": { ... } }
    final r = map['result'];
    if (r is Map<String, dynamic>) return r;
    if (r is Map) return r.cast<String, dynamic>();

    // alguns backends: { "user": {...} }
    final u = map['user'];
    if (u is Map<String, dynamic>) return u;
    if (u is Map) return u.cast<String, dynamic>();

    // se veio flat
    return map;
  }

  Future<int> getStudentsActiveCount({required String sessionToken}) async {
    final res = await _http.restRequest(
      url: AuthEndpoints.dashboardGet,
      method: HttpMethod.post,
      headers: {"X-Parse-Session-Token": sessionToken},
      body: const {},
    );

    print("getStudentsActiveCount response: $res");

    final result = res["result"];

    if (result == null) return 0;

    final kpis = result["kpis"];
    if (kpis == null) return 0;

    return (kpis["activeStudents"] ?? 0) as int;
  }

  Future<List<Map<String, dynamic>>> getStudents({
    required String sessionToken,
  }) async {
    final result = await _http.restRequest(
      url: AuthEndpoints
          .studentsList, // ex: https://parseapi.back4app.com/functions/students-list
      method: HttpMethod.post,
      headers: {"X-Parse-Session-Token": sessionToken},
      body: const {},
    );

    if (_hasError(result)) throw Exception(_errorMessage(result));

    // Parse Cloud: { "result": [ {...}, {...} ] }
    final r = result["result"];

    if (r is List) {
      return r.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    }

    // fallback: se veio flat
    if (result is Map<String, dynamic> && result["students"] is List) {
      final s = result["students"] as List;
      return s.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    }

    return const [];
  }

  Future<void> saveWorkout({
    required String sessionToken,
    required String studentProfileId,
    required String day,
    required String title,
    required List<Map<String, dynamic>> exercises,
  }) async {
    await _http.restRequest(
      url: AuthEndpoints.workoutSave,
      method: HttpMethod.post,
      headers: {"X-Parse-Session-Token": sessionToken},
      body: {
        "studentProfileId": studentProfileId,
        "day": day,
        "title": title,
        "exercises": exercises,
      },
    );
  }
}
