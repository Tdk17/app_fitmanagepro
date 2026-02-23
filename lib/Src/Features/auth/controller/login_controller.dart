import 'package:app_fitmanagerpro/Src/App/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_api.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_session.dart';

class LoginController extends ChangeNotifier {
  LoginController({required AuthApi api, required AuthSession session})
    : _api = api,
      _session = session;

  final AuthApi _api;
  final AuthSession _session;

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;
  bool obscure = true;
  String? error;

  void toggleObscure() {
    obscure = !obscure;
    notifyListeners();
  }

  void clearError() {
    if (error == null) return;
    error = null;
    notifyListeners();
  }

  bool _validate() {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    if (email.isEmpty || !email.contains('@')) {
      error = "Digite um e-mail válido.";
      notifyListeners();
      return false;
    }
    if (pass.length < 6) {
      error = "Senha inválida.";
      notifyListeners();
      return false;
    }
    return true;
  }

  Future<UserModel?> login() async {
    clearError();
    if (!_validate()) return null;

    loading = true;
    notifyListeners();

    try {
      final user = await _api.login(
        email: emailCtrl.text.trim(),
        password: passCtrl.text,
      );

      final token = user.sessionToken;
      if (token == null || token.isEmpty) {
        loading = false;
        error = "Token não retornou do servidor.";
        notifyListeners();
        return null;
      }

      await _session.save(
        sessionToken: token,
        role: user.role,
        email: user.email,
        name: user.name,
        id: user.id,
      );

      loading = false;
      notifyListeners();
      return user;
    } catch (e) {
      loading = false;
      error = "E-mail ou senha inválidos.";
      print("Erro no login: $e");
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}
