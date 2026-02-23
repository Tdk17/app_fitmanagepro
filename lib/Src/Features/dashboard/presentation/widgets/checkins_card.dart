import 'package:flutter/material.dart';
import 'package:app_fitmanagerpro/Src/App/theme/app_theme.dart';
import '../../data/dashboard_models.dart';
import 'card_shell.dart';

class CheckinsCard extends StatelessWidget {
  const CheckinsCard({super.key, required this.items});
  final List<CheckinItem> items;

  @override
  Widget build(BuildContext context) {
    return CardShell(
      title: "Check-ins recentes",
      child: Column(children: items.map((e) => _RowItem(item: e)).toList()),
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({required this.item});
  final CheckinItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.green.withOpacity(0.16),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.green.withOpacity(0.35)),
            ),
            child: const Icon(Icons.check, color: AppTheme.green, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            item.time,
            style: TextStyle(
              color: Colors.white.withOpacity(0.55),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
