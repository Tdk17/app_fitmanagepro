import 'package:flutter/material.dart';
import 'auth_field.dart';

import 'green_button.dart';
import 'mode_segment.dart';

class AlunoFace extends StatelessWidget {
  const AlunoFace({
    super.key,
    required this.green,
    required this.codeCtrl,
    required this.onSelectProfessor,
    required this.onSelectAluno,
    required this.onAccessTreino,
  });

  final Color green;
  final TextEditingController codeCtrl;

  final VoidCallback onSelectProfessor;
  final VoidCallback onSelectAluno;

  final VoidCallback onAccessTreino;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 14),

        ModeSegment(
          isAlunoSelected: true,
          onProfessor: onSelectProfessor,
          onAluno: onSelectAluno,
          green: green,
        ),
        const SizedBox(height: 18),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Código de Acesso do Aluno",
            style: TextStyle(
              color: Colors.white.withOpacity(0.90),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 10),

        AuthField(
          hint: "Digite seu código",
          icon: Icons.key_rounded,
          controller: codeCtrl,
        ),

        const SizedBox(height: 10),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Código fornecido pelo seu personal trainer",
            style: TextStyle(color: Colors.white.withOpacity(0.45)),
          ),
        ),

        const SizedBox(height: 16),

        GreenButton(
          loading: null,
          label: "ACESSAR TREINO",
          green: green,
          onTap: onAccessTreino,
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
