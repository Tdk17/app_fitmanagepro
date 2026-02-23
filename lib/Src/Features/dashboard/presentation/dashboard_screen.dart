import 'package:app_fitmanagerpro/Src/App/Di/service_locator.dart';
import 'package:app_fitmanagerpro/Src/Db/http_manager..dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_api.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_session.dart';

import 'package:app_fitmanagerpro/Src/Features/dashboard/data/dashboard_models.dart';
import 'package:app_fitmanagerpro/Src/Features/dashboard/presentation/widgets/billing_card.dart';
import 'package:app_fitmanagerpro/Src/Features/dashboard/presentation/widgets/checkins_card.dart';
import 'package:app_fitmanagerpro/Src/Features/dashboard/presentation/widgets/quick_actions_card.dart';
import 'package:app_fitmanagerpro/Src/Features/dashboard/presentation/widgets/risk_card.dart';
import 'package:flutter/material.dart';

import '../data/dashboard_mock.dart';
import 'widgets/dashboard_shell.dart';
import 'widgets/kpi_row.dart';
import 'widgets/section_title_row.dart';
import 'widgets/today_workout_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<_DashData> _loadDashboard() async {
    final s = sl<AuthSession>();

    final name = await s.name();
    final email = await s.email();
    final token = await s.token();

    int studentsActive = 0;
    if (token != null && token.isNotEmpty) {
      studentsActive = await AuthApi(
        HttpManager(),
      ).getStudentsActiveCount(sessionToken: token);
    }

    return _DashData(
      userName: (name ?? "").trim(),
      userEmail: (email ?? "").trim(),
      studentsActive: studentsActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DashData>(
      future: _loadDashboard(),
      builder: (context, snap) {
        final data = snap.data;

        final userName = (data != null && data.userName.isNotEmpty)
            ? data.userName
            : "Usuário";
        final userEmail = (data != null && data.userEmail.isNotEmpty)
            ? data.userEmail
            : "";

        // base vazio (resto continua mock/zero)
        final base = DashboardMock.empty(
          userName: userName,
          userEmail: userEmail,
        );

        // ✅ troca só o KPI "Alunos ativos"
        final kpis = List.of(base.kpis);
        if (kpis.isNotEmpty) {
          kpis[0] = KpiItem(
            title: kpis[0].title,
            value: data?.studentsActive ?? 0,
            subtitle: kpis[0].subtitle,
            icon: kpis[0].icon,
            isWarning: kpis[0].isWarning,
            deltaColor: kpis[0].deltaColor,
          );
        }

        final vm = DashboardViewModel(
          userName: base.userName,
          userEmail: base.userEmail,
          kpis: kpis,
          todayWorkout: base.todayWorkout,
          recentCheckins: base.recentCheckins,
          billingNext: base.billingNext,
          riskRight: base.riskRight,
          riskBottom: base.riskBottom,
        );

        // loading
        if (snap.connectionState == ConnectionState.waiting) {
          return DashboardShell(
            userName: userName,
            userEmail: userEmail,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        // erro
        if (snap.hasError) {
          return DashboardShell(
            userName: userName,
            userEmail: userEmail,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                "Erro ao carregar dashboard: ${snap.error}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return DashboardShell(
          userName: vm.userName,
          userEmail: vm.userEmail,
          child: LayoutBuilder(
            builder: (context, c) {
              final isWide = c.maxWidth >= 1100;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cockpit do Personal",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),

                    KpiRow(items: vm.kpis),
                    const SizedBox(height: 18),

                    SectionTitleRow(
                      title: "Hoje",
                      actionText: "VER TODOS",
                      onAction: () {},
                    ),
                    const SizedBox(height: 12),

                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Column(
                              children: [
                                TodayWorkoutCard(item: vm.todayWorkout),
                                const SizedBox(height: 14),
                                BillingCard(items: vm.billingNext),
                                const SizedBox(height: 14),
                                RiskCard(
                                  title: "Alunos em risco",
                                  items: vm.riskBottom,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                CheckinsCard(items: vm.recentCheckins),
                                const SizedBox(height: 14),
                                RiskCard(
                                  title: "Alunos em risco",
                                  items: vm.riskRight,
                                  compact: true,
                                ),
                                const SizedBox(height: 14),
                                QuickActionsCard(),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          TodayWorkoutCard(item: vm.todayWorkout),
                          const SizedBox(height: 14),
                          CheckinsCard(items: vm.recentCheckins),
                          const SizedBox(height: 14),
                          BillingCard(items: vm.billingNext),
                          const SizedBox(height: 14),
                          RiskCard(
                            title: "Alunos em risco",
                            items: vm.riskRight,
                          ),
                          const SizedBox(height: 14),
                          QuickActionsCard(),
                          const SizedBox(height: 14),
                          RiskCard(
                            title: "Alunos em risco",
                            items: vm.riskBottom,
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _DashData {
  final String userName;
  final String userEmail;
  final int studentsActive;

  _DashData({
    required this.userName,
    required this.userEmail,
    required this.studentsActive,
  });
}
