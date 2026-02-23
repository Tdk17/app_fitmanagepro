import 'package:flutter/material.dart';
import 'sidebar_nav.dart';
import 'top_header.dart';

class DashboardShell extends StatelessWidget {
  const DashboardShell({
    super.key,
    required this.child,
    required this.userName,
    required this.userEmail,
  });

  final Widget child;
  final String userName;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B0B0B), Color(0xFF1C1C1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final isWide = c.maxWidth >= 980;

          if (isWide) {
            return Scaffold(
              body: Row(
                children: [
                  const SizedBox(width: 250, child: SidebarNav()),
                  Expanded(
                    child: Column(
                      children: [
                        TopHeader(userName: userName),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // Mobile / narrow: sidebar vira Drawer
          return Scaffold(
            drawer: const Drawer(
              backgroundColor: Color(0xFF0B0B0B),
              child: SafeArea(child: SidebarNav()),
            ),
            body: Column(
              children: [
                TopHeader(userName: userName, showMenu: true),
                Expanded(child: child),
              ],
            ),
          );
        },
      ),
    );
  }
}
