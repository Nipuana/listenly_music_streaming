import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final String? error;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool obscure;
  final VoidCallback? onSuffixTap;
  final TextEditingController controller;

  const AppTextField({
    super.key,
    required this.hint,
    this.error,
    required this.prefixIcon,
    required this.controller,
    this.suffixIcon,
    this.obscure = false,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      obscureText: obscure,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return error ?? "$hint cannot be empty";
        }
        return null;
      },

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintText: hint,

        prefixIcon: Icon(prefixIcon),

        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(suffixIcon),
              )
            : null,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
