import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/screens/dashboard_screen.dart';
import 'package:weplay_music_streaming/screens/forgot_password_screen.dart';
import 'package:weplay_music_streaming/screens/signup_screen.dart';
import 'package:weplay_music_streaming/widget/app_text_field.dart';
import 'package:weplay_music_streaming/widget/buttons/app_button.dart';
import 'package:weplay_music_streaming/widget/buttons/app_social_button.dart';
import 'package:weplay_music_streaming/widget/logo_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordHidden = true;
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          margin: EdgeInsets.all(25),
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                LogoWidget(size: 80),
                SizedBox(height: 25),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Email"),
                ),
                SizedBox(height: 6),
                AppTextField(
                  hint: "your@email.com",
                  error: "enter your email",
                  prefixIcon: Icons.email_outlined,
                ),

                SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Password"),
                ),
                SizedBox(height: 6),
                AppTextField(
                  hint: "Enter your password",
                  error: "please enter your password",
                  prefixIcon: Icons.lock_outline,
                  obscure: _isPasswordHidden,
                  suffixIcon: _isPasswordHidden 
                  ? Icons.visibility_outlined 
                  : Icons.visibility_off_outlined,
                  onSuffixTap: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                ),

                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                      );
                    },
                    child: Text("Forgot Password?",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ),

                SizedBox(height: 20),

                AppButton(
                  text: "Log In",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardScreen()),
                    );
                  },
                ),

                SizedBox(height: 25),
                Text("OR"),
                SizedBox(height: 25),

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
                      },
                      child: Text("SignUp", 
                      style: TextStyle(color: Colors.blue)
                      )
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