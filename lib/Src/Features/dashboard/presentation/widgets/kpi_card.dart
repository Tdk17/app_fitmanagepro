import 'package:flutter/material.dart';
import 'package:app_fitmanagerpro/Src/App/theme/app_theme.dart';
import '../../data/dashboard_models.dart';

class KpiCard extends StatelessWidget {
  const KpiCard({super.key, required this.item});
  final KpiItem item;

  @override
  Widget build(BuildContext context) {
    final green = AppTheme.green;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(item.icon, color: item.isWarning ? Colors.amber : green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.70),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${item.value}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    color: item.deltaColor ?? Colors.white.withOpacity(0.45),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // “mini chart” fake só pra estética (depois troca por chart real)
          Container(
            width: 70,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Center(
              child: Icon(
                Icons.show_chart_rounded,
                color: Colors.white.withOpacity(0.35),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
