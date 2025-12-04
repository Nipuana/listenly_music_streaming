import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/widget/app_text_field.dart';
import 'package:weplay_music_streaming/widget/buttons/app_button.dart';
import 'package:weplay_music_streaming/widget/buttons/app_social_button.dart';
import 'package:weplay_music_streaming/widget/logo_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                  prefixIcon: Icons.lock_outline,
                  obscure: true,
                  suffixIcon: Icons.visibility_outlined,
                  onSuffixTap: () {},
                ),

                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot Password?",
                      style: TextStyle(color: Colors.blue)),
                ),

                SizedBox(height: 20),

                AppButton(
                  text: "Log In",
                  onPressed: () {},
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
                    Text("SignUp", style: TextStyle(color: Colors.blue)),
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