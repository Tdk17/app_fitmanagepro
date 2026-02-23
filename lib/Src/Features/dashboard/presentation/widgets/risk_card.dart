import 'package:flutter/material.dart';
import '../../data/dashboard_models.dart';
import 'card_shell.dart';

class RiskCard extends StatelessWidget {
  const RiskCard({
    super.key,
    required this.title,
    required this.items,
    this.compact = false,
  });

  final String title;
  final List<RiskItem> items;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return CardShell(
      title: title,
      child: Column(
        children: items
            .map((e) => _RiskRow(item: e, compact: compact))
            .toList(),
      ),
    );
  }
}

class _RiskRow extends StatelessWidget {
  const _RiskRow({required this.item, required this.compact});
  final RiskItem item;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.redAccent.withOpacity(0.35)),
            ),
            child: const Icon(
              Icons.priority_high_rounded,
              color: Colors.redAccent,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.reason,
                  maxLines: compact ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.white.withOpacity(0.45),
          ),
        ],
      ),
    );
  }
}
