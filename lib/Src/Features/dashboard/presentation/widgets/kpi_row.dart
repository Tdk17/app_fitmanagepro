import 'package:flutter/material.dart';
import '../../data/dashboard_models.dart';
import 'kpi_card.dart';

class KpiRow extends StatelessWidget {
  const KpiRow({super.key, required this.items});
  final List<KpiItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final wrap = c.maxWidth < 900;

        if (wrap) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: items
                .map((e) => SizedBox(width: 360, child: KpiCard(item: e)))
                .toList(),
          );
        }

        return Row(
          children: [
            Expanded(child: KpiCard(item: items[0])),
            const SizedBox(width: 12),
            Expanded(child: KpiCard(item: items[1])),
            const SizedBox(width: 12),
            Expanded(child: KpiCard(item: items[2])),
          ],
        );
      },
    );
  }
}
