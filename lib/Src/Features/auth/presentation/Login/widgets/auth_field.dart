import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.trailing,
    this.obscureText = false,
    this.keyboardType,
  });

  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final Widget? trailing;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.55)),
          suffixIcon: trailing,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
