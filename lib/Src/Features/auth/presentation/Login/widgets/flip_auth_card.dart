import 'package:app_fitmanagerpro/Src/App/theme/app_theme.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app_fitmanagerpro/Src/App/di/service_locator.dart';

import 'auth_card_shell.dart';
import 'professor_face.dart';
import 'aluno_face.dart';

enum AuthMode { professor, aluno }

class FlipAuthCard extends StatefulWidget {
  const FlipAuthCard({super.key});

  @override
  State<FlipAuthCard> createState() => _FlipAuthCardState();
}

class _FlipAuthCardState extends State<FlipAuthCard> {
  AuthMode mode = AuthMode.professor;

  late final LoginController c;

  final codeCtrl = TextEditingController(); // aluno

  @override
  void initState() {
    super.initState();
    c = sl<LoginController>(); // ✅ vem do GetIt
  }

  @override
  void dispose() {
    codeCtrl.dispose();
    c.dispose();
    super.dispose();
  }

  void setMode(AuthMode newMode) {
    if (newMode == mode) return;
    setState(() => mode = newMode);
    c.clearError();
  }

  @override
  Widget build(BuildContext context) {
    const green = AppTheme.green;

    return AnimatedBuilder(
      animation: c,
      builder: (context, _) {
        return AuthCardShell(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) {
                final slide = Tween<Offset>(
                  begin: const Offset(0, 0.06),
                  end: Offset.zero,
                ).animate(anim);

                return FadeTransition(
                  opacity: anim,
                  child: SlideTransition(position: slide, child: child),
                );
              },
              child: mode == AuthMode.professor
                  ? ProfessorFace(
                      key: const ValueKey('professor'),
                      green: green,
                      emailCtrl: c.emailCtrl,
                      passCtrl: c.passCtrl,
                      obscure: c.obscure,

                      onToggleObscure: c.toggleObscure,
                      onSelectProfessor: () => setMode(AuthMode.professor),
                      onSelectAluno: () => setMode(AuthMode.aluno),
                      onEntrarPainel: () async {
                        final user = await c.login();
                        print(
                          "Login attempt: ${c.emailCtrl.text}, success: ${user != null}",
                        );
                        if (!context.mounted) return;
                        if (user != null) {
                          context.go('/dashboard');
                        }
                      },
                      onForgot: () {},
                      onCreateAccount: () => context.go('/panel'),
                    )
                  : AlunoFace(
                      key: const ValueKey('aluno'),
                      green: green,
                      codeCtrl: codeCtrl,

                      onSelectProfessor: () => setMode(AuthMode.professor),
                      onSelectAluno: () => setMode(AuthMode.aluno),
                      onAccessTreino: () async {
                        // ✅ Aqui você decide a regra do aluno:
                        // 1) se aluno acessa via código -> precisa de endpoint no AuthApi
                        // 2) se aluno também usa email/senha -> reaproveita c.login()

                        // Por enquanto: navega direto
                        context.go('/treino');
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}
