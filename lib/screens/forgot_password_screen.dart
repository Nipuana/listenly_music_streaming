import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/screens/login_screen.dart';
import 'package:weplay_music_streaming/widget/app_text_field.dart';
import 'package:weplay_music_streaming/widget/buttons/app_button.dart';


class ForgotPasswordScreen extends StatelessWidget {
   const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xffe8eefc),
      body: Center(
        child: SingleChildScrollView(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back to Login
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Row(
                    children:  [
                      Icon(Icons.arrow_back, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Back to Login",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
          
                 SizedBox(height: 25),
          
                // Mail Icon Circle
                Center(
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child:  Icon(
                      Icons.mail_outline,
                      color: Colors.blue,
                      size: 34,
                    ),
                  ),
                ),
          
                 SizedBox(height: 25),
          
                // Title
                 Center(
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          
                 SizedBox(height: 10),
          
                // Subtitle
                 Center(
                  child: Text(
                    "No worries! Enter your email address\nand we'll send you a code to reset your password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
          
                 SizedBox(height: 25),
          
                 Text("Email Address"),
                 SizedBox(height: 6),
          
                 AppTextField(
                  hint: "your@email.com",
                  prefixIcon: Icons.email_outlined,
                ),
          
                 SizedBox(height: 20),
          
                AppButton(
                  text: "Send Reset Code",
                  onPressed: () {},
                ),
          
                 SizedBox(height: 25),
          
                // Footer: Remember password?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Text("Remember your password? "),
                    Text(
                      "Log In",
                      style: TextStyle(color: Colors.blue),
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
