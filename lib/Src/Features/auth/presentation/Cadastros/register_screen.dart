import 'package:app_fitmanagerpro/Src/App/theme/app_theme.dart';
import 'package:app_fitmanagerpro/Src/Db/http_manager..dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_api.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_session.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/core_data.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/ibge_cities_service.dart'
    show IbgeCitiesService;
import 'package:app_fitmanagerpro/Src/Features/auth/data/nichos_data.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/presentation/Cadastros/widgets/select_picker_sheet.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/presentation/Login/widgets/auth_field.dart'
    show AuthField;
import 'package:app_fitmanagerpro/Src/Features/auth/presentation/Login/widgets/green_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String? cidade;
  String? nicho;

  bool loading = false;
  bool obscure = true;

  final ibge = IbgeCitiesService();

  final api = AuthApi(HttpManager());
  late final AuthSession session;

  @override
  void initState() {
    super.initState();
    session = AuthSession();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String? _validate() {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    if (name.isEmpty) return "Digite seu nome.";
    if (email.isEmpty || !email.contains('@'))
      return "Digite um e-mail válido.";
    if (pass.length < 6) return "Senha precisa ter no mínimo 6 caracteres.";
    if (cidade == null || cidade!.isEmpty) return "Selecione sua cidade.";
    if (nicho == null || nicho!.isEmpty) return "Selecione seu nicho.";
    return null;
  }

  Future<void> _register() async {
    final err = _validate();
    if (err != null) {
      _snack(err);
      return;
    }

    setState(() => loading = true);

    try {
      final user = await api.signupPersonal(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        password: passCtrl.text,
        city: cidade!,
        niche: nicho!,
        crefNumber: "", // ✅ removido CREF: backend deve aceitar vazio ou ignore
        crefUf: null,
      );

      if (!mounted) return;

      final token = user.sessionToken;
      if (token == null || token.isEmpty) {
        _snack("Cadastro concluído, mas o token não retornou.");
        return;
      }
      context.go('/dashboard'); // ajuste sua rota

      await session.save(
        sessionToken: token,
        role: user.role,
        email: user.email,
        name: user.name,
        id: user.id,
      );
    } catch (e) {
      if (!mounted) return;
      _snack("Falha no cadastro. Tente novamente.");
      print("Erro no cadastro: $e");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const green = AppTheme.green;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 6),
                      const Text(
                        "Cadastro",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 18),

                      Container(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111111).withOpacity(0.78),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.8),
                              blurRadius: 30,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: _StepInfo(
                          green: green,
                          nameCtrl: nameCtrl,
                          emailCtrl: emailCtrl,
                          passCtrl: passCtrl,
                          obscure: obscure,
                          onToggleObscure: () =>
                              setState(() => obscure = !obscure),
                          cidade: cidade,
                          nicho: nicho,
                          onPickCidade: () async {
                            final cities = await ibge.getCities();
                            final picked = await SelectPickerSheet.open<BrCity>(
                              context: context,
                              title: "Selecione sua cidade",
                              items: cities,
                              itemLabel: (c) => c.label,
                            );
                            if (picked != null)
                              setState(() => cidade = picked.label);
                          },
                          onPickNicho: () async {
                            final picked = await SelectPickerSheet.open<String>(
                              context: context,
                              title: "Selecione seu nicho",
                              items: NichosData.all,
                              itemLabel: (x) => x,
                            );
                            if (picked != null) setState(() => nicho = picked);
                          },
                        ),
                      ),

                      const SizedBox(height: 14),

                      GreenButton(
                        label: "CRIAR CONTA",
                        green: green,
                        loading: loading,
                        onTap: _register,
                      ),

                      const SizedBox(height: 14),
                      Text(
                        "Privacidade · Termos",
                        style: TextStyle(color: Colors.white.withOpacity(0.35)),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          "Voltar",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.55),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepInfo extends StatelessWidget {
  const _StepInfo({
    super.key,
    required this.green,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passCtrl,
    required this.obscure,
    required this.onToggleObscure,
    required this.cidade,
    required this.nicho,
    required this.onPickCidade,
    required this.onPickNicho,
  });

  final Color green;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool obscure;
  final VoidCallback onToggleObscure;

  final String? cidade;
  final String? nicho;
  final VoidCallback onPickCidade;
  final VoidCallback onPickNicho;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthField(
          hint: "Nome",
          controller: nameCtrl,
          icon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 12),
        AuthField(
          hint: "E-mail",
          icon: Icons.mail_outline_rounded,
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        AuthField(
          icon: Icons.lock_outline_rounded,
          hint: "Senha",
          controller: passCtrl,
          obscureText: obscure,
          trailing: IconButton(
            onPressed: onToggleObscure,
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.white.withOpacity(0.55),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _SelectField(
          label: "Cidade",
          value: cidade ?? "Cidade",
          onTap: onPickCidade,
        ),
        const SizedBox(height: 12),
        _SelectField(
          label: "Nicho",
          value: nicho ?? "Nicho",
          onTap: onPickNicho,
          highlight: true,
          green: green,
        ),
      ],
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({
    required this.label,
    required this.value,
    required this.onTap,
    this.highlight = false,
    this.green,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool highlight;
  final Color? green;

  @override
  Widget build(BuildContext context) {
    final border = highlight && green != null
        ? green!.withOpacity(0.55)
        : Colors.white.withOpacity(0.12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: value == "Cidade" || value == "Nicho"
                          ? Colors.white.withOpacity(0.35)
                          : Colors.white.withOpacity(0.90),
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white.withOpacity(0.55),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
