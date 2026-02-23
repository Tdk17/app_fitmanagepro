import 'package:flutter/material.dart';
import 'package:app_fitmanagerpro/Src/App/theme/app_theme.dart';

class SectionTitleRow extends StatelessWidget {
  const SectionTitleRow({
    super.key,
    required this.title,
    required this.actionText,
    required this.onAction,
  });

  final String title;
  final String actionText;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onAction,
          child: Text(
            actionText,
            style: const TextStyle(
              color: AppTheme.green,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
