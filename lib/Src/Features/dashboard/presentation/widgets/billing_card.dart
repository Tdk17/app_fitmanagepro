import 'package:flutter/material.dart';
import 'package:app_fitmanagerpro/Src/App/theme/app_theme.dart';
import '../../data/dashboard_models.dart';
import 'card_shell.dart';

class BillingCard extends StatefulWidget {
  const BillingCard({super.key, required this.items});
  final List<BillingItem> items;

  @override
  State<BillingCard> createState() => _BillingCardState();
}

class _BillingCardState extends State<BillingCard> {
  int tab = 0; // 0: vence em 3 dias, 1: vence em 7 dias, 2: e-mails

  @override
  Widget build(BuildContext context) {
    return CardShell(
      title: "Cobranças próximas",
      child: Column(
        children: [
          _Tabs(tab: tab, onChange: (v) => setState(() => tab = v)),
          const SizedBox(height: 12),
          Column(
            children: widget.items.map((e) => _BillingRow(item: e)).toList(),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.tab, required this.onChange});
  final int tab;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    Widget chip(String text, int idx) {
      final active = tab == idx;
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onChange(idx),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active
                  ? AppTheme.green.withOpacity(0.14)
                  : Colors.black.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: active
                    ? AppTheme.green.withOpacity(0.35)
                    : Colors.white.withOpacity(0.06),
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: active ? Colors.white : Colors.white.withOpacity(0.55),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip("Vence em 3 dias", 0),
        const SizedBox(width: 8),
        chip("Vence em 7 dias", 1),
        const SizedBox(width: 8),
        chip("E-mails", 2),
      ],
    );
  }
}

class _BillingRow extends StatelessWidget {
  const _BillingRow({required this.item});
  final BillingItem item;

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
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white.withOpacity(0.08),
            child: const Icon(Icons.person, color: Colors.white, size: 18),
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
                  item.due,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 10),

          // botão WhatsApp (visual)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.green.withOpacity(0.14),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.green.withOpacity(0.30)),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.phone, color: AppTheme.green, size: 18),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
