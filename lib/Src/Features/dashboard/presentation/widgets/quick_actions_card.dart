import 'package:app_fitmanagerpro/Src/Features/dashboard/presentation/create_student_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app_fitmanagerpro/Src/App/theme/app_theme.dart';
import 'card_shell.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({
    super.key,
    this.onNewStudent,
    this.onNewWorkout,
    this.onRegisterPayment,
    this.onSendCharge,
  });

  final VoidCallback? onNewStudent;
  final VoidCallback? onNewWorkout;
  final VoidCallback? onRegisterPayment;
  final VoidCallback? onSendCharge;

  @override
  Widget build(BuildContext context) {
    return CardShell(
      title: "Ações rápidas",
      child: Column(
        children: [
          _ActionBtn(
            icon: Icons.person_add_alt_1_rounded,
            label: "Novo aluno",
            onTap: () {
              showCreateStudentDialog(context);
            },
          ),
          const SizedBox(height: 10),
          _ActionBtn(
            icon: Icons.fitness_center_rounded,
            label: "Novo treino",
            onTap: onNewWorkout,
          ),
          const SizedBox(height: 10),
          _ActionBtn(
            icon: Icons.payments_rounded,
            label: "Registrar pagamento",
            onTap: onRegisterPayment,
          ),
          const SizedBox(height: 10),
          _ActionBtn(
            icon: Icons.chat_rounded,
            label: "Enviar cobrança (WhatsApp)",
            onTap: onSendCharge,
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap ?? () {}, // ✅ Agora funciona
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.green.withOpacity(0.70),
              AppTheme.green.withOpacity(0.35),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.green.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
