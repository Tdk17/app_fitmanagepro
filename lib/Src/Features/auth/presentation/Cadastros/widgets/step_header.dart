import 'package:flutter/material.dart';

class StepHeader extends StatelessWidget {
  const StepHeader({
    super.key,
    required this.stepIndex,
    required this.leftLabel,
    required this.rightLabel,
    required this.green,
  });

  final int stepIndex;
  final String leftLabel;
  final String rightLabel;
  final Color green;

  @override
  Widget build(BuildContext context) {
    final leftActive = stepIndex == 1;
    final rightActive = stepIndex == 2;

    return Column(
      children: [
        Row(
          children: [
            _Dot(active: leftActive, text: "1", green: green),
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: green.withOpacity(0.55),
              ),
            ),
            _Dot(active: rightActive, text: "2", green: green),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                leftLabel,
                style: TextStyle(
                  color: leftActive
                      ? Colors.white.withOpacity(0.70)
                      : Colors.white.withOpacity(0.35),
                ),
              ),
            ),
            Expanded(
              child: Text(
                rightLabel,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: rightActive
                      ? Colors.white.withOpacity(0.85)
                      : Colors.white.withOpacity(0.35),
                  fontWeight: rightActive ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active, required this.text, required this.green});
  final bool active;
  final String text;
  final Color green;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Colors.black : Colors.white.withOpacity(0.08),
        border: Border.all(
          color: active ? green : Colors.white.withOpacity(0.20),
          width: 1.4,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: active ? green : Colors.white.withOpacity(0.55),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
