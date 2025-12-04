import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/screens/login_screen.dart';
import 'package:weplay_music_streaming/widget/app_text_field.dart';
import 'package:weplay_music_streaming/widget/buttons/app_button.dart';
import 'package:weplay_music_streaming/widget/buttons/app_social_button.dart';
import 'package:weplay_music_streaming/widget/logo_widget.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordHidden =true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(25),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LogoWidget(size: 80),
                const SizedBox(height: 25),

                // Full Name
                const Text("Full Name"),
                const SizedBox(height: 6),
                const AppTextField(
                  hint: "Your Name",
                  prefixIcon: Icons.person_outline,
                ),

                const SizedBox(height: 20),

                // Email
                const Text("Email"),
                const SizedBox(height: 6),
                const AppTextField(
                  hint: "your@email.com",
                  prefixIcon: Icons.email_outlined,
                ),

                const SizedBox(height: 20),

                // Password
                const Text("Password"),
                const SizedBox(height: 6),
                AppTextField(
                  hint: "Create a strong password",
                  prefixIcon: Icons.lock_outline,
                  obscure: _isPasswordHidden,
                  suffixIcon: _isPasswordHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  onSuffixTap: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                ),

                const SizedBox(height: 8),
                const Text(
                  "Must be at least 8 characters long",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const SizedBox(height: 20),

                // Terms & Policy
                RichText(
                  text: TextSpan(
                    text: "I agree to the ",
                    style: const TextStyle(color: Colors.black),
                    children: const [
                      TextSpan(
                        text: "Terms & Conditions",
                        style: TextStyle(color: Colors.blue),
                      ),
                      TextSpan(text: " and "),
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Signup Button
                AppButton(
                  text: "Sign Up",
                  onPressed: () {},
                ),

                const SizedBox(height: 25),
                const Divider(height: 20),
                const SizedBox(height: 10),

                const Center(child: Text("OR")),
                const SizedBox(height: 20),

                // Social Buttons
                AppSocialButton(
                  text: "Continue with Google",
                  icon: Icons.g_mobiledata,
                  onPressed: () {},
                ),

                const SizedBox(height: 12),

                AppSocialButton(
                  text: "Continue with Apple",
                  icon: Icons.apple,
                  onPressed: () {},
                ),

                const SizedBox(height: 25),

                // Already have account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
