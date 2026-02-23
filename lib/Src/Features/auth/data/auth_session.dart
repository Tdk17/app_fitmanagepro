import 'package:shared_preferences/shared_preferences.dart';

class AuthSession {
  static const _kToken = 'sessionToken';
  static const _kRole = 'role';
  static const _kEmail = 'email';
  static const _kName = 'name';
  static const _kId = 'userId';

  Future<void> save({
    required String sessionToken,
    String? role,
    String? email,
    String? name,
    String? id,
  }) async {
    // web pode falhar se plugin não estiver ok; se quiser, eu coloco fallback em memória
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kToken, sessionToken);
    if (role != null) await prefs.setString(_kRole, role);
    if (email != null) await prefs.setString(_kEmail, email);
    if (name != null) await prefs.setString(_kName, name);
    if (id != null) await prefs.setString(_kId, id);
  }

  Future<String?> token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kToken);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kRole);
    await prefs.remove(_kEmail);
    await prefs.remove(_kName);
    await prefs.remove(_kId);
  }

  Future<String?> name() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kName);
  }

  Future<String?> email() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kEmail);
  }

  Future<String?> role() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kRole);
  }
}
