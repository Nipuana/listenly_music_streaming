import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final String error;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool obscure;
  final VoidCallback? onSuffixTap;

  const AppTextField({super.key, 
    required this.hint,
    required this.error,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscure = false,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintText: hint,
        errorText: error,
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
