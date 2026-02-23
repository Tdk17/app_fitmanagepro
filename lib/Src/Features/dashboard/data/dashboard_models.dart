import 'package:flutter/material.dart';

class KpiItem {
  final String title;
  final int value;
  final String subtitle;
  final IconData icon;
  final bool isWarning;
  final Color? deltaColor;

  KpiItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.isWarning = false,
    this.deltaColor,
  });
}

class TodayWorkout {
  final String studentName;
  final String subtitle;
  final String timeLabel;
  TodayWorkout({
    required this.studentName,
    required this.subtitle,
    required this.timeLabel,
  });
}

class CheckinItem {
  final String name;
  final String time;
  CheckinItem({required this.name, required this.time});
}

class BillingItem {
  final String name;
  final String due;
  final String value;
  BillingItem({required this.name, required this.due, required this.value});
}

class RiskItem {
  final String name;
  final String reason;
  final String days;
  RiskItem({required this.name, required this.reason, required this.days});
}

class DashboardViewModel {
  final String userName;
  final String userEmail;
  final List<KpiItem> kpis;
  final TodayWorkout todayWorkout;
  final List<CheckinItem> recentCheckins;
  final List<BillingItem> billingNext;
  final List<RiskItem> riskRight;
  final List<RiskItem> riskBottom;

  DashboardViewModel({
    required this.userName,
    required this.userEmail,
    required this.kpis,
    required this.todayWorkout,
    required this.recentCheckins,
    required this.billingNext,
    required this.riskRight,
    required this.riskBottom,
  });
}
