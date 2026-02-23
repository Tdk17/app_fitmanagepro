import 'package:app_fitmanagerpro/Src/Features/dashboard/data/deshboard_api.dart';
import 'package:flutter/material.dart';

class DashboardController extends ChangeNotifier {
  DashboardController({required DashboardApi api}) : _api = api;

  final DashboardApi _api;

  bool loading = false;
  String? error;

  Map<String, dynamic>? data;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      data = await _api.getDashboard();
    } catch (e) {
      error = "Erro ao carregar dashboard.";
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
