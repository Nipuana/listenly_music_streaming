import 'package:flutter/material.dart';


class AuthTextField extends StatelessWidget {
  final String hint;
  final String error;
  final bool obscure;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  

  const AuthTextField(
    {
      super.key, 
      required this.hint, 
      required this.error,
      this.obscure = false, 
      this.controller, 
      this.keyboardType,
      
    }
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        errorText: error,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}