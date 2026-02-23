import 'package:flutter/material.dart';

import 'auth_field.dart';

import 'green_button.dart';
import 'mode_segment.dart';

class ProfessorFace extends StatelessWidget {
  const ProfessorFace({
    super.key,
    required this.green,
    required this.emailCtrl,
    required this.passCtrl,
    required this.obscure,
    required this.onToggleObscure,
    required this.onSelectProfessor,
    required this.onSelectAluno,
    required this.onEntrarPainel,
    required this.onForgot,
    required this.onCreateAccount,
  });

  final Color green;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool obscure;
  final VoidCallback onToggleObscure;

  final VoidCallback onSelectProfessor;
  final VoidCallback onSelectAluno;

  final VoidCallback onEntrarPainel;
  final VoidCallback onForgot;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 14),

        ModeSegment(
          isAlunoSelected: false,
          onProfessor: onSelectProfessor,
          onAluno: onSelectAluno,
          green: green,
        ),
        const SizedBox(height: 16),

        AuthField(
          hint: "E-mail",
          icon: Icons.mail_outline_rounded,
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),

        AuthField(
          hint: "Senha",
          icon: Icons.lock_outline_rounded,
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

        const SizedBox(height: 14),

        TextButton(
          onPressed: onForgot,
          child: Text(
            "Esqueceu a senha?",
            style: TextStyle(color: Colors.white.withOpacity(0.55)),
          ),
        ),

        TextButton(
          onPressed: onCreateAccount,
          child: Text(
            "Criar conta",
            style: TextStyle(color: Colors.white.withOpacity(0.65)),
          ),
        ),

        const SizedBox(height: 10),

        GreenButton(
          label: "ENTRAR NO PAINEL",
          green: green,
          onTap: onEntrarPainel,
          loading: null,
        ),

        const SizedBox(height: 14),

        Text(
          "Privacidade · Termos",
          style: TextStyle(color: Colors.white.withOpacity(0.35)),
        ),
      ],
    );
  }
}
