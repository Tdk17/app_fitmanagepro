import 'package:flutter/material.dart';
import 'dashboard_models.dart';

class DashboardMock {
  static DashboardViewModel viewModel() {
    return DashboardViewModel(
      userName: "Andre Cardoso",
      userEmail: "andre@fitmanagerpro.com",
      kpis: [
        KpiItem(
          title: "Alunos ativos",
          value: 42,
          subtitle: "+3 essa semana",
          icon: Icons.people_alt_outlined,
          deltaColor: Colors.greenAccent,
        ),
        KpiItem(
          title: "Inadimplentes",
          value: 8,
          subtitle: "+2 essa semana",
          icon: Icons.warning_amber_rounded,
          isWarning: true,
          deltaColor: Colors.redAccent,
        ),
        KpiItem(
          title: "Treinos ativos",
          value: 26,
          subtitle: "+6 essa semana  +12%",
          icon: Icons.fitness_center_rounded,
          deltaColor: Colors.greenAccent,
        ),
      ],
      todayWorkout: TodayWorkout(
        studentName: "Lucas Mendes",
        subtitle: "Treino - inferiores",
        timeLabel: "Rt: 18h00",
      ),
      recentCheckins: [
        CheckinItem(name: "Carlos Almeida", time: "12h35"),
        CheckinItem(name: "Fernanda Souza", time: "11h20"),
        CheckinItem(name: "Bruno Lima", time: "10h50"),
      ],
      billingNext: [
        BillingItem(
          name: "João Martins",
          due: "Vence em 3 dias",
          value: "R\$250",
        ),
        BillingItem(
          name: "Diego Santos",
          due: "Vence em 3 dias",
          value: "R\$200",
        ),
        BillingItem(
          name: "Bruno Lima",
          due: "Vence em 7 dias",
          value: "R\$150",
        ),
      ],
      riskRight: [
        RiskItem(
          name: "Eduardo Costa",
          reason: "Sem treino concluído há 7 dias",
          days: "7 dias",
        ),
        RiskItem(
          name: "Sofia Lima",
          reason: "Sem atualização há 10 dias",
          days: "10 dias",
        ),
        RiskItem(
          name: "Juliana Pereira",
          reason: "Sem treino concluído há 10 dias",
          days: "10 dias",
        ),
      ],
      riskBottom: [
        RiskItem(
          name: "Eduardo Costa",
          reason: "Sem treino concluído há 7 dias",
          days: "7 dias",
        ),
        RiskItem(
          name: "Sofia Lima",
          reason: "Sem atualização há 16 dias",
          days: "16 dias",
        ),
        RiskItem(
          name: "Juliana Pereira",
          reason: "Sem treino concluído há 10 dias",
          days: "10 dias",
        ),
      ],
    );
  }

  static DashboardViewModel empty({
    required String userName,
    required String userEmail,
  }) {
    return DashboardViewModel(
      userName: userName,
      userEmail: userEmail,
      kpis: [
        KpiItem(
          title: "Alunos ativos",
          value: 0,
          subtitle: "0 essa semana",
          icon: Icons.people_alt_outlined,
          deltaColor: Colors.white54,
        ),
        KpiItem(
          title: "Inadimplentes",
          value: 0,
          subtitle: "0 essa semana",
          icon: Icons.warning_amber_rounded,
          isWarning: true,
          deltaColor: Colors.white54,
        ),
        KpiItem(
          title: "Treinos ativos",
          value: 0,
          subtitle: "0 essa semana",
          icon: Icons.fitness_center_rounded,
          deltaColor: Colors.white54,
        ),
      ],
      todayWorkout: TodayWorkout(
        studentName: "Nenhum treino hoje",
        subtitle: "—",
        timeLabel: "—",
      ),
      recentCheckins: const [],
      billingNext: const [],
      riskRight: const [],
      riskBottom: const [],
    );
  }
}
