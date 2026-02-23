import 'package:app_fitmanagerpro/Src/App/Di/service_locator.dart';
import 'package:app_fitmanagerpro/Src/App/router/app_router.dart';
import 'package:app_fitmanagerpro/Src/App/theme/app_theme.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
