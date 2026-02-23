import 'package:flutter/material.dart';

class ModeSegment extends StatelessWidget {
  const ModeSegment({
    super.key,
    required this.isAlunoSelected,
    required this.onProfessor,
    required this.onAluno,
    required this.green,
  });

  final bool isAlunoSelected;
  final VoidCallback onProfessor;
  final VoidCallback onAluno;
  final Color green;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegBtn(
              label: "Professor",
              selected: !isAlunoSelected,
              green: green,
              onTap: onProfessor,
            ),
          ),
          Expanded(
            child: _SegBtn(
              label: "Aluno",
              selected: isAlunoSelected,
              green: green,
              onTap: onAluno,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegBtn extends StatelessWidget {
  const _SegBtn({
    required this.label,
    required this.selected,
    required this.green,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color green;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? Colors.black : Colors.transparent,
          border: selected
              ? Border.all(color: green.withOpacity(0.55), width: 1.2)
              : Border.all(color: Colors.transparent),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: green.withOpacity(0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white.withOpacity(0.45),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
