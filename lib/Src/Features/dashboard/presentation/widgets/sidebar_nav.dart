import 'package:app_fitmanagerpro/Src/App/Di/service_locator.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_session.dart';
import 'package:flutter/material.dart';
import 'package:app_fitmanagerpro/Src/App/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class SidebarNav extends StatefulWidget {
  const SidebarNav({super.key});

  @override
  State<SidebarNav> createState() => _SidebarNavState();
}

class _SidebarNavState extends State<SidebarNav> {
  @override
  Widget build(BuildContext context) {
    const green = AppTheme.green;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0B0B0B),
            const Color(0xFF070707),
            Colors.black,
          ],
        ),
        border: Border(
          right: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 14),
            Row(
              children: [
                const SizedBox(width: 16),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: green.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: green.withOpacity(0.35)),
                  ),
                  child: const Center(
                    child: Text(
                      "FM",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "FitManager Pro",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _NavItem(
              icon: Icons.grid_view_rounded,
              label: "Dashboard",
              active: true,
              onTap: () {
                context.go('/dashboard');
              },
            ),
            _NavItem(
              icon: Icons.people_alt_outlined,
              label: "Alunos",
              onTap: () {
                context.go('/students');
              },
            ),
            _NavItem(icon: Icons.fitness_center_rounded, label: "Treinos"),
            _NavItem(icon: Icons.payments_outlined, label: "Financeiro"),
            _NavItem(
              icon: Icons.chat_bubble_outline_rounded,
              label: "Mensagens",
            ),
            const Spacer(),
            Divider(color: Colors.white.withOpacity(0.06), height: 1),
            const SizedBox(height: 12),

            FutureBuilder(
              future: Future.wait([
                sl<AuthSession>().name(),
                sl<AuthSession>().email(),
                sl<AuthSession>().role(),
              ]),
              builder: (context, snap) {
                final data = snap.data;

                final name =
                    (data != null &&
                        (data[0] as String) != null &&
                        (data[0] as String).trim().isNotEmpty)
                    ? (data[0] as String).trim()
                    : "Usuário";

                final email = (data != null && (data[1] as String?) != null)
                    ? (data[1] as String).trim()
                    : "";

                final role = (data != null && (data[2] as String?) != null)
                    ? (data[2] as String).trim()
                    : "personal";

                final roleLabel = role == "personal"
                    ? "Personal Trainer"
                    : "Aluno";

                return _ProfileBlock(name: name, role: roleLabel, email: email);
              },
            ),
            const SizedBox(height: 10),
            _NavItem(
              icon: Icons.settings_outlined,
              label: "Configurações",
              onTap: () {
                context.go('/login');
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = active ? AppTheme.green : Colors.white.withOpacity(0.70);
    final bg = active ? AppTheme.green.withOpacity(0.12) : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ?? () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active
                  ? AppTheme.green.withOpacity(0.25)
                  : Colors.white.withOpacity(0.04),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: c),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(color: c, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileBlock extends StatelessWidget {
  const _ProfileBlock({
    required this.name,
    required this.role,
    required this.email,
  });
  final String name;
  final String role;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white.withOpacity(0.08),
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.90),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 12,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.40),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
