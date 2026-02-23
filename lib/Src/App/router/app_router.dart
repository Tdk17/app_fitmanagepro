import 'package:app_fitmanagerpro/Src/Features/aluno/students_screen.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/presentation/Cadastros/register_screen.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/presentation/Login/login_screen.dart';
import 'package:app_fitmanagerpro/Src/Features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/panel', builder: (context, state) => RegisterScreen()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    // Exemplos (você cria depois):
    GoRoute(path: '/students', builder: (_, __) => const StudentsScreen()),
    // GoRoute(path: '/treino', builder: (_, __) => const TreinoScreen()),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Text(
        'Rota não encontrada: ${state.uri}',
        style: const TextStyle(color: Colors.white),
      ),
    ),
  ),
);
