import 'package:app_fitmanagerpro/Src/Db/auth_endPoints.dart';
import 'package:flutter/material.dart';
import 'package:app_fitmanagerpro/Src/App/Di/service_locator.dart';
import 'package:app_fitmanagerpro/Src/Db/http_manager..dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_session.dart';

Future<bool?> showCreateStudentDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _CreateStudentDialog(),
  );
}

class _CreateStudentDialog extends StatefulWidget {
  const _CreateStudentDialog();

  @override
  State<_CreateStudentDialog> createState() => _CreateStudentDialogState();
}

class _CreateStudentDialogState extends State<_CreateStudentDialog> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final goalsCtrl = TextEditingController();

  final monthlyFeeCtrl = TextEditingController();
  final dueDayCtrl = TextEditingController(text: "10");
  final classFrequencyCtrl = TextEditingController(text: "2x/semana");
  final classDurationCtrl = TextEditingController(text: "60");

  DateTime startDate = DateTime.now();

  // ✅ NOVO: birthDate obrigatório
  DateTime? birthDate;

  bool loading = false;
  String? errorText;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    phoneCtrl.dispose();
    goalsCtrl.dispose();
    monthlyFeeCtrl.dispose();
    dueDayCtrl.dispose();
    classFrequencyCtrl.dispose();
    classDurationCtrl.dispose();
    super.dispose();
  }

  String _dateIso(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return "$y-$m-$day";
  }

  String? _validate() {
    if (nameCtrl.text.trim().isEmpty) return "Digite o nome.";

    // ✅ NOVO: valida birthDate
    if (birthDate == null) return "Informe a data de nascimento.";

    final fee = double.tryParse(
      monthlyFeeCtrl.text.trim().replaceAll(',', '.'),
    );
    if (fee == null || fee <= 0) return "Digite uma mensalidade válida.";

    final due = int.tryParse(dueDayCtrl.text.trim());
    if (due == null || due < 1 || due > 28) return "Dia de vencimento: 1 a 28.";

    final dur = int.tryParse(classDurationCtrl.text.trim());
    if (dur == null || dur < 15 || dur > 240) return "Duração: 15 a 240 min.";

    if (classFrequencyCtrl.text.trim().isEmpty) return "Informe a frequência.";

    return null;
  }

  Future<void> _create() async {
    setState(() => errorText = null);

    final err = _validate();
    if (err != null) {
      setState(() => errorText = err);
      return;
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

      final http = HttpManager();

      final res = await http.restRequest(
        url: AuthEndpoints.createStudentV2,
        method: HttpMethod.post,
        headers: {"X-Parse-Session-Token": token},
        body: {
          "name": nameCtrl.text.trim(),
          "email": emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
          "address": addressCtrl.text.trim().isEmpty
              ? null
              : addressCtrl.text.trim(),
          "phone": phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
          "goals": goalsCtrl.text.trim().isEmpty ? null : goalsCtrl.text.trim(),

          // ✅ NOVO: envie birthDate
          // Se seu backend espera "birthDate" em vez de "birthDateISO", troque a key.
          "birthDateISO": _dateIso(birthDate!),

          "startDateISO": _dateIso(startDate),
          "monthlyFee": double.parse(
            monthlyFeeCtrl.text.trim().replaceAll(',', '.'),
          ),
          "dueDay": int.parse(dueDayCtrl.text.trim()),
          "classFrequency": classFrequencyCtrl.text.trim(),
          "classDurationMinutes": int.parse(classDurationCtrl.text.trim()),
        },
      );

      final result = (res["result"] is Map)
          ? Map<String, dynamic>.from(res["result"])
          : res;

      final accessCode = (result["accessCode"] ?? "").toString();

      if (!mounted) return;
      setState(() => loading = false);

      print(result);

      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF111111),
          title: const Text(
            "Aluno cadastrado!",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            accessCode.isEmpty
                ? "Cadastro concluído."
                : "Código de acesso do aluno:\n\n$accessCode",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        errorText = "Falha ao cadastrar: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0F0F0F),
      title: const Text(
        "Novo aluno",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
      content: SizedBox(
        width: 520,
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

              _field("Nome", nameCtrl),
              const SizedBox(height: 10),
              _field("E-mail (opcional)", emailCtrl),
              const SizedBox(height: 10),
              _field("Telefone", phoneCtrl),
              const SizedBox(height: 10),
              _field("Endereço", addressCtrl),
              const SizedBox(height: 10),
              _field("Objetivos", goalsCtrl, maxLines: 3),
              const SizedBox(height: 14),

              // ✅ NOVO: Data de nascimento
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: birthDate ?? DateTime(now.year - 20, 1, 1),
                    firstDate: DateTime(1900),
                    lastDate: now,
                  );
                  if (picked != null) setState(() => birthDate = picked);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                  ),
                  child: Text(
                    birthDate == null
                        ? "Data de nascimento: selecione"
                        : "Data de nascimento: ${_dateIso(birthDate!)}",
                    style: TextStyle(color: Colors.white.withOpacity(0.85)),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _field(
                      "Mensalidade (ex: 250)",
                      monthlyFeeCtrl,
                      keyboard: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _field(
                      "Vencimento (1-28)",
                      dueDayCtrl,
                      keyboard: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _field(
                      "Frequência (ex: 2x/semana)",
                      classFrequencyCtrl,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _field(
                      "Duração (min)",
                      classDurationCtrl,
                      keyboard: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => startDate = picked);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                  ),
                  child: Text(
                    "Data de início: ${_dateIso(startDate)}",
                    style: TextStyle(color: Colors.white.withOpacity(0.85)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: loading ? null : () => Navigator.of(context).pop(false),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: loading ? null : _create,
          child: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Cadastrar"),
        ),
      ],
    );
  }

  Widget _field(
    String label,
    TextEditingController c, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      keyboardType: keyboard,
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
