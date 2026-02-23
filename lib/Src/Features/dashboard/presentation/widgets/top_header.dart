import 'package:flutter/material.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key, required this.userName, this.showMenu = false});

  final String userName;
  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: Row(
        children: [
          if (showMenu)
            IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(
                Icons.menu_rounded,
                color: Colors.white.withOpacity(0.75),
              ),
            )
          else
            const SizedBox(width: 6),

          Expanded(
            child: Text(
              "",
              style: TextStyle(color: Colors.white.withOpacity(0.85)),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.desktop_windows_outlined,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_rounded,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 6),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white.withOpacity(0.10),
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
