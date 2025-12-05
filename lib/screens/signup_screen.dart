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
          margin:  EdgeInsets.all(25),
          padding:  EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow:  [
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
                 LogoWidget(size: 80),
                 SizedBox(height: 25),

                // Full Name
                 Text("Full Name"),
                 SizedBox(height: 6),
                 AppTextField(
                  hint: "Your Name",
                  error: "Enter your Name",
                  prefixIcon: Icons.person_outline,
                ),

                 SizedBox(height: 20),

                // Email
                 Text("Email"),
                 SizedBox(height: 6),
                 AppTextField(
                  hint: "your@email.com",
                  error: "enter your email",
                  prefixIcon: Icons.email_outlined,
                ),

                 SizedBox(height: 20),

                // Password
                 Text("Password"),
                 SizedBox(height: 6),
                AppTextField(
                  hint: "Create a strong password",
                  error: "enter your password",
                  prefixIcon: Icons.lock_outline,
                  obscure: _isPasswordHidden,
                  suffixIcon: _isPasswordHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  onSuffixTap: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                ),

                 SizedBox(height: 8),
                 Text(
                  "Must be at least 8 characters long",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),

                 SizedBox(height: 20),

                // Terms & Policy
                RichText(
                  text: TextSpan(
                    text: "I agree to the ",
                    style:  TextStyle(color: Colors.black),
                    children:  [
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

                 SizedBox(height: 30),

                // Signup Button
                AppButton(
                  text: "Sign Up",
                  onPressed: () {},
                ),

                 SizedBox(height: 25),
                 Divider(height: 20),
                 SizedBox(height: 10),

                 Center(child: Text("OR")),
                 SizedBox(height: 20),

                // Social Buttons
                AppSocialButton(
                  text: "Continue with Google",
                  icon: Icons.g_mobiledata,
                  onPressed: () {},
                ),

                 SizedBox(height: 12),

                AppSocialButton(
                  text: "Continue with Apple",
                  icon: Icons.apple,
                  onPressed: () {},
                ),

                 SizedBox(height: 25),

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
