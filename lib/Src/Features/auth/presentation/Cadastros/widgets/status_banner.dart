import 'package:flutter/material.dart';

enum StatusType { success, error }

class StatusBanner extends StatelessWidget {
  const StatusBanner({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.green,
  });

  final StatusType type;
  final String title;
  final String subtitle;
  final Color green;

  @override
  Widget build(BuildContext context) {
    final isSuccess = type == StatusType.success;
    final iconBg = isSuccess
        ? green.withOpacity(0.22)
        : Colors.red.withOpacity(0.18);
    final iconColor = isSuccess ? green : Colors.redAccent;
    final boxColor = isSuccess
        ? green.withOpacity(0.10)
        : Colors.red.withOpacity(0.10);
    final border = isSuccess
        ? green.withOpacity(0.22)
        : Colors.red.withOpacity(0.22);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
              border: Border.all(color: border),
            ),
            child: Icon(
              isSuccess ? Icons.check_rounded : Icons.close_rounded,
              size: 16,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.90),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white.withOpacity(0.55)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
