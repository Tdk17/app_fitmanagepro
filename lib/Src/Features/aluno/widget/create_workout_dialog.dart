import 'package:app_fitmanagerpro/Src/App/Di/service_locator.dart';
import 'package:app_fitmanagerpro/Src/Db/auth_endPoints.dart';
import 'package:app_fitmanagerpro/Src/Db/http_manager..dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_api.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_session.dart';
import 'package:flutter/material.dart';

Future<void> showCreateWorkoutDialog({
  required BuildContext context,
  required String studentProfileId,
  required String studentName,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _CreateWorkoutDialog(
      studentProfileId: studentProfileId,
      studentName: studentName,
    ),
  );
}

class _CreateWorkoutDialog extends StatefulWidget {
  const _CreateWorkoutDialog({
    required this.studentProfileId,
    required this.studentName,
  });

  final String studentProfileId;
  final String studentName;

  @override
  State<_CreateWorkoutDialog> createState() => _CreateWorkoutDialogState();
}

class _CreateWorkoutDialogState extends State<_CreateWorkoutDialog> {
  final titleCtrl = TextEditingController(text: "Treino 1");
  String day = "SEG";

  final goalCtrl = TextEditingController(); // ✅ NOVO
  final exercises = <_ExerciseForm>[
    _ExerciseForm(name: "Prancha isométrica", sets: "4", reps: "máximo"),
  ];

  bool loading = false;
  String? errorText;

  @override
  void dispose() {
    titleCtrl.dispose();
    goalCtrl.dispose();
    super.dispose();
  }

  void _addExercise() {
    setState(() => exercises.add(_ExerciseForm()));
  }

  void _removeExercise(int i) {
    setState(() => exercises.removeAt(i));
  }

  void _applyTemplate5Days() {
    // Template resumido (você pode expandir com tudo do doc depois)
    // Exemplo baseado no seu arquivo: Treino 1 tem prancha, cadeira abdutora, terra sumo... :contentReference[oaicite:2]{index=2}
    setState(() {
      day = "SEG";
      titleCtrl.text = "Treino 1";
      exercises
        ..clear()
        ..addAll([
          _ExerciseForm(name: "Prancha isométrica", sets: "4", reps: "máximo"),
          _ExerciseForm(name: "Cadeira abdutora", sets: "5", reps: "20"),
          _ExerciseForm(name: "Terra sumô", sets: "6", reps: "variação"),
          _ExerciseForm(name: "Elevação pélvica", sets: "4", reps: "variação"),
          _ExerciseForm(name: "Stiff RDL", sets: "4", reps: "9-12"),
        ]);
    });
  }

  Future<void> _save() async {
    setState(() => errorText = null);

    final title = titleCtrl.text.trim();
    final goal = goalCtrl.text.trim(); // ✅ NOVO
    if (title.isEmpty) {
      setState(() => errorText = "Digite o título do treino.");
      return;
    }
    if (goal.isEmpty) {
      // ✅ NOVO
      setState(() => errorText = "Informe o objetivo do treino (goal).");
      return;
    }
    if (exercises.isEmpty) {
      setState(() => errorText = "Adicione pelo menos 1 exercício.");
      return;
    }
    for (final e in exercises) {
      if (e.name.trim().isEmpty) {
        setState(() => errorText = "Todo exercício precisa de nome.");
        return;
      }
    }

    setState(() => loading = true);

    try {
      final token = await sl<AuthSession>().token();
      if (token == null || token.isEmpty) {
        setState(() {
          loading = false;
          errorText = "Sessão expirada. Faça login novamente.";
        });
        return;
      }

      // ✅ payload certo (list de maps)
      final payloadExercises = exercises.map((e) {
        return <String, dynamic>{
          "name": e.name.trim(),
          "sets": e.sets.trim().isEmpty ? null : e.sets.trim(),
          "reps": e.reps.trim().isEmpty ? null : e.reps.trim(),
          "notes": e.notes.trim().isEmpty ? null : e.notes.trim(),
        };
      }).toList();

      final res = await HttpManager().restRequest(
        url: AuthEndpoints.workoutSave, // ex: '$baseUrl/workout-save'
        method: HttpMethod.post,
        headers: {"X-Parse-Session-Token": token},
        body: <String, dynamic>{
          "studentProfileId": widget.studentProfileId,
          "day": day, // "SEG"
          "title": title, // "Treino 1"
          "exercises": payloadExercises,
          "goal": goal, // ✅ NOVO
        },
      );

      debugPrint("workout-save response => $res");

      // Parse Cloud normalmente vem {result: {...}}
      final result = (res["result"] is Map)
          ? Map<String, dynamic>.from(res["result"])
          : (res is Map<String, dynamic> ? res : <String, dynamic>{});

      final ok = result["ok"] == true;

      if (!ok) {
        throw Exception(result["error"] ?? result.toString());
      }

      if (!mounted) return;
      Navigator.of(context).pop(); // fecha dialog
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        errorText = "Falha ao salvar: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0F0F0F),
      title: Text(
        "Treino • ${widget.studentName}",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (errorText != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.withOpacity(0.25)),
                  ),
                  child: Text(
                    errorText!,
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              Row(
                children: [
                  Expanded(child: _field("Título", titleCtrl)),
                  const SizedBox(width: 10),
                  _dayDropdown(),
                ],
              ),
              const SizedBox(height: 10),
              _field("Objetivo do treino (goal)", goalCtrl), // ✅ NOVO
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: loading ? null : _applyTemplate5Days,
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: const Text("Usar template 5 dias"),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Exercícios",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              for (int i = 0; i < exercises.length; i++) ...[
                _exerciseTile(i),
                const SizedBox(height: 10),
              ],

              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: loading ? null : _addExercise,
                  icon: const Icon(Icons.add),
                  label: const Text("Adicionar exercício"),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: loading ? null : () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: loading ? null : _save,
          child: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Salvar treino"),
        ),
      ],
    );
  }

  Widget _dayDropdown() {
    final days = const ["SEG", "TER", "QUA", "QUI", "SEX", "SAB", "DOM"];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: DropdownButton<String>(
        value: day,
        underline: const SizedBox.shrink(),
        dropdownColor: const Color(0xFF111111),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
        items: days
            .map((d) => DropdownMenuItem(value: d, child: Text(d)))
            .toList(),
        onChanged: loading ? null : (v) => setState(() => day = v ?? day),
      ),
    );
  }

  Widget _exerciseTile(int i) {
    final e = exercises[i];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Exercício ${i + 1}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                onPressed: loading ? null : () => _removeExercise(i),
                icon: const Icon(Icons.delete_outline),
                color: Colors.redAccent,
              ),
            ],
          ),
          _textField(
            label: "Nome do exercício",
            initial: e.name,
            onChanged: (v) => e.name = v,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _textField(
                  label: "Séries",
                  initial: e.sets,
                  keyboard: TextInputType.number,
                  onChanged: (v) => e.sets = v,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _textField(
                  label: "Reps / alvo",
                  initial: e.reps,
                  onChanged: (v) => e.reps = v,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _textField(
            label: "Observações (opcional)",
            initial: e.notes,
            onChanged: (v) => e.notes = v,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController c) {
    return TextField(
      controller: c,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.65)),
        filled: true,
        fillColor: Colors.black.withOpacity(0.35),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.22)),
        ),
      ),
    );
  }

  Widget _textField({
    required String label,
    required String initial,
    required ValueChanged<String> onChanged,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initial,
      onChanged: onChanged,
      keyboardType: keyboard,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.65)),
        filled: true,
        fillColor: Colors.black.withOpacity(0.35),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.22)),
        ),
      ),
    );
  }
}

class _ExerciseForm {
  _ExerciseForm({
    this.name = "",
    this.sets = "",
    this.reps = "",
    this.notes = "",
  });

  String name;
  String sets;
  String reps;
  String notes;
}
