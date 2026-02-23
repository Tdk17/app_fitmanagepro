import 'package:flutter/material.dart';

class SelectPickerSheet<T> extends StatefulWidget {
  const SelectPickerSheet({
    super.key,
    required this.title,
    required this.items,
    required this.itemLabel,
  });

  final String title;
  final List<T> items;
  final String Function(T item) itemLabel;

  static Future<T?> open<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T item) itemLabel,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: const Color(0xFF0B0B0B),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (_) => SelectPickerSheet<T>(
        title: title,
        items: items,
        itemLabel: itemLabel,
      ),
    );
  }

  @override
  State<SelectPickerSheet<T>> createState() => _SelectPickerSheetState<T>();
}

class _SelectPickerSheetState<T> extends State<SelectPickerSheet<T>> {
  final TextEditingController _searchCtrl = TextEditingController();
  late List<T> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _searchCtrl.addListener(_filter);
  }

  void _filter() {
    final q = _searchCtrl.text.trim().toLowerCase();

    setState(() {
      if (q.isEmpty) {
        _filtered = widget.items;
      } else {
        _filtered = widget.items.where((item) {
          final label = widget.itemLabel(item).toLowerCase();
          return label.contains(q);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              const SizedBox(height: 10),

              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Pesquisar...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white.withOpacity(0.55),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.35),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.separated(
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) =>
                      Divider(color: Colors.white.withOpacity(0.06), height: 1),
                  itemBuilder: (_, index) {
                    final item = _filtered[index];
                    final label = widget.itemLabel(item);

                    return ListTile(
                      title: Text(
                        label,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () => Navigator.pop(context, item),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
