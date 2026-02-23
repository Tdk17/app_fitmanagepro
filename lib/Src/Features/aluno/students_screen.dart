import 'package:app_fitmanagerpro/Src/App/Di/service_locator.dart';
import 'package:app_fitmanagerpro/Src/Db/http_manager..dart';
import 'package:app_fitmanagerpro/Src/Features/aluno/widget/create_workout_dialog.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_api.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_session.dart';
import 'package:app_fitmanagerpro/Src/Features/dashboard/presentation/widgets/dashboard_shell.dart';
import 'package:app_fitmanagerpro/Src/Features/dashboard/presentation/widgets/section_title_row.dart';
import 'package:app_fitmanagerpro/Src/Features/dashboard/presentation/widgets/quick_actions_card.dart';
import 'package:app_fitmanagerpro/Src/Features/dashboard/presentation/create_student_dialog.dart';
import 'package:flutter/material.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  Future<_StudentsData> _loadStudents() async {
    final s = sl<AuthSession>();
    final name = await s.name();
    final email = await s.email();
    final token = await s.token();

    var students = <Map<String, dynamic>>[];

    if (token != null && token.isNotEmpty) {
      students = await AuthApi(HttpManager()).getStudents(sessionToken: token);
    }

    return _StudentsData(
      userName: (name ?? "").trim(),
      userEmail: (email ?? "").trim(),
      students: students,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_StudentsData>(
      future: _loadStudents(),
      builder: (context, snap) {
        final data = snap.data;

        final userName = (data != null && data.userName.isNotEmpty)
            ? data.userName
            : "Usuário";
        final userEmail = (data != null && data.userEmail.isNotEmpty)
            ? data.userEmail
            : "";

        if (snap.connectionState == ConnectionState.waiting) {
          return DashboardShell(
            userName: userName,
            userEmail: userEmail,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snap.hasError) {
          return DashboardShell(
            userName: userName,
            userEmail: userEmail,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                "Erro ao carregar alunos: ${snap.error}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final students = data?.students ?? const <Map<String, dynamic>>[];

        return DashboardShell(
          userName: userName,
          userEmail: userEmail,
          child: LayoutBuilder(
            builder: (context, c) {
              final isWide = c.maxWidth >= 1100;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Alunos",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),

                    SectionTitleRow(
                      title: "Lista de alunos",
                      actionText: "NOVO ALUNO",
                      onAction: () async {
                        final created = await showCreateStudentDialog(context);
                        if (created == true && context.mounted) {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const StudentsScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    if (students.isEmpty) ...[
                      _EmptyStudentsCard(isWide: isWide),
                      const SizedBox(height: 14),
                      const QuickActionsCard(),
                    ] else ...[
                      _StudentsList(students: students, isWide: isWide),
                      const SizedBox(height: 14),
                      const QuickActionsCard(),
                    ],
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

class _StudentsData {
  final String userName;
  final String userEmail;
  final List<Map<String, dynamic>> students;

  _StudentsData({
    required this.userName,
    required this.userEmail,
    required this.students,
  });
}

class _EmptyStudentsCard extends StatelessWidget {
  const _EmptyStudentsCard({required this.isWide});
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.greenAccent.withOpacity(0.25)),
            ),
            child: const Icon(
              Icons.people_alt_outlined,
              color: Colors.greenAccent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Você ainda não tem alunos cadastrados.\nCrie seu primeiro aluno e comece a montar treino e alimentação.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentsList extends StatelessWidget {
  const _StudentsList({required this.students, required this.isWide});

  final List<Map<String, dynamic>> students;
  final bool isWide;

  Color _statusColor(String s) {
    switch (s) {
      case "active":
        return Colors.greenAccent;
      case "paused":
        return Colors.orangeAccent;
      case "archived":
        return Colors.white54;
      default:
        return Colors.white54;
    }
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = isWide ? 2 : 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: students.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: isWide
            ? 2.9
            : 2.6, // mais espaço pro preview do treino
      ),
      itemBuilder: (context, i) {
        final s = students[i];

        final id = (s["id"] ?? s["objectId"] ?? "").toString();
        final name = (s["name"] ?? "Aluno").toString();
        final phone = (s["phone"] ?? "").toString();
        final status = (s["status"] ?? "active").toString();
        final accessCode = (s["accessCode"] ?? "").toString();

        // Esperado: workoutDays: [{ day: "SEG", title: "Treino 1", count: 7 }, ...]
        final rawDays = (s["workoutDays"] is List)
            ? (s["workoutDays"] as List)
            : const [];
        final workoutDays = rawDays
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        final color = _statusColor(status);

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            // abre dialog para criar/editar treinos do aluno
            await showCreateWorkoutDialog(
              context: context,
              studentProfileId: id,
              studentName: name,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.10)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: color.withOpacity(0.25)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : "A",
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            [
                              if (phone.isNotEmpty) phone,
                              if (accessCode.isNotEmpty) "Código: $accessCode",
                            ].join(" • "),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: color.withOpacity(0.20)),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Preview “Dias de treino”
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Treinos da semana",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                if (workoutDays.isEmpty)
                  _miniHint("Sem treinos cadastrados — toque para criar")
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: workoutDays.take(6).map((d) {
                      final day = (d["day"] ?? "").toString();
                      final title = (d["title"] ?? "Treino").toString();
                      final count = (d["count"] ?? 0).toString();
                      return _DayChip(day: day, title: title, count: count);
                    }).toList(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _miniHint(String t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Text(
        t,
        style: TextStyle(color: Colors.white.withOpacity(0.65), height: 1.2),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.day, required this.title, required this.count});

  final String day;
  final String title;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day.isEmpty ? "DIA" : day,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "$title • $count ex",
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
