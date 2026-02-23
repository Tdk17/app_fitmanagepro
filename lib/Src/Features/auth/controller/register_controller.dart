import 'package:app_fitmanagerpro/Src/App/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_api.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_session.dart';

enum RegisterStep { info, cref }

class RegisterController extends ChangeNotifier {
  RegisterController({required AuthApi api, required AuthSession session})
    : _api = api,
      _session = session;

  final AuthApi _api;
  final AuthSession _session;

  // Step
  RegisterStep step = RegisterStep.info;

  // Fields (Step 1)
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String? city;
  String? niche;

  // Fields (Step 2)
  final crefCtrl = TextEditingController();
  String? crefUf;

  // UI states
  bool loading = false;
  bool obscure = true;
  String? error;

  // Status do CREF (para mostrar banner)
  StatusType? statusType;
  String? statusTitle;
  String? statusSubtitle;

  void toggleObscure() {
    obscure = !obscure;
    notifyListeners();
  }

  void clearError() {
    if (error == null) return;
    error = null;
    notifyListeners();
  }

  void setCity(String value) {
    city = value;
    notifyListeners();
  }

  void setNiche(String value) {
    niche = value;
    notifyListeners();
  }

  void setCrefUf(String uf) {
    crefUf = uf;
    notifyListeners();
  }

  void back() {
    if (step == RegisterStep.cref) {
      step = RegisterStep.info;
      statusType = null;
      statusTitle = null;
      statusSubtitle = null;
      notifyListeners();
    }
  }

  bool _validateStepInfo() {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    if (name.isEmpty) {
      error = "Digite seu nome.";
      notifyListeners();
      return false;
    }
    if (email.isEmpty || !email.contains('@')) {
      error = "Digite um e-mail válido.";
      notifyListeners();
      return false;
    }
    if (pass.length < 6) {
      error = "Senha precisa ter no mínimo 6 caracteres.";
      notifyListeners();
      return false;
    }
    if (city == null || city!.isEmpty) {
      error = "Selecione sua cidade.";
      notifyListeners();
      return false;
    }
    if (niche == null || niche!.isEmpty) {
      error = "Selecione seu nicho.";
      notifyListeners();
      return false;
    }
    return true;
  }

  bool _validateStepCref() {
    final cref = crefCtrl.text.trim();
    if (cref.isEmpty) {
      error = "Digite seu número do CREF.";
      notifyListeners();
      return false;
    }
    return true;
  }

  /// Avança o step ou finaliza cadastro.
  /// Retorna UserModel quando cadastro finaliza com sucesso.
  Future<UserModel?> next() async {
    clearError();

    // Step 1 -> Step 2
    if (step == RegisterStep.info) {
      if (!_validateStepInfo()) return null;
      step = RegisterStep.cref;
      notifyListeners();
      return null;
    }

    // Step 2: validar CREF + cadastrar
    if (!_validateStepCref()) return null;

    loading = true;
    statusType = null;
    statusTitle = null;
    statusSubtitle = null;
    notifyListeners();

    final cref = crefCtrl.text.trim();

    try {
      // 1) validar CREF
      final crefResult = await _api.validateCref(crefNumber: cref, uf: crefUf);

      if (!crefResult.isValid) {
        loading = false;
        statusType = StatusType.error;
        statusTitle = "Número CREF inválido!";
        statusSubtitle = "Verifique o número e tente novamente.";
        notifyListeners();
        return null;
      }

      statusType = StatusType.success;
      statusTitle = "CREF válido!";
      statusSubtitle = "Criando sua conta...";
      notifyListeners();

      // 2) cadastrar personal (igual ao front)
      final user = await _api.signupPersonal(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        password: passCtrl.text,
        city: city!,
        niche: niche!,
        crefNumber: cref,
        crefUf: crefUf,
      );

      // 3) salvar sessão igual login
      if (user.sessionToken != null) {
        await _session.save(
          sessionToken: user.sessionToken!,
          role: user.role,
          email: user.email,
          name: user.name,
          id: user.id,
        );
      }

      loading = false;
      notifyListeners();
      return user;
    } catch (_) {
      loading = false;
      statusType = StatusType.error;
      statusTitle = "Falha no cadastro.";
      statusSubtitle = "Tente novamente em instantes.";
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    crefCtrl.dispose();
    super.dispose();
  }
}

/// Copie o mesmo enum que você usa no StatusBanner.
/// Se ele já existe em outro arquivo, remova daqui e importe.
enum StatusType { success, error, info }
