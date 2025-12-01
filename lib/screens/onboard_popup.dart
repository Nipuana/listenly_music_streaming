import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/screens/login_screen.dart';

class LoginPopup extends StatelessWidget {
  const LoginPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 25,
        right: 25,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
        
            /// Close Icon
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
            ),
        
            /// Title
            const Text(
              "Login or sign up",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
        
            const SizedBox(height: 8),
        
            const Text(
              "Please select your preferred method\n"
              "to continue setting up your account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black45),
            ),
        
            const SizedBox(height: 25),
        
            /// Email Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Already have an account? Log in",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
        
            const SizedBox(height: 12),
        
            /// Phone Login
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Sign up with us",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
        
            const SizedBox(height: 20),
        
            /// Google + Apple Buttons
        
            const SizedBox(height: 25),
        
            /// Footer Text
            const Text(
              "If you are creating a new account,\n"
              "Terms & Conditions and Privacy Policy will apply.",
              style: TextStyle(fontSize: 12, color: Colors.black45),
              textAlign: TextAlign.center,
            ),
        
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
