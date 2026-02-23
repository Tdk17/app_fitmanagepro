import 'package:app_fitmanagerpro/Src/Features/auth/presentation/Login/widgets/flip_auth_card.dart';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const green = AppTheme.green;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 0, 0, 0),
                    green.withOpacity(0.95),

                    const Color.fromARGB(255, 0, 0, 0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(100),
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset("assets/logoBranca.png", width: 500),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: const FlipAuthCard(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
