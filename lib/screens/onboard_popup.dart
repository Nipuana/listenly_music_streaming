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
        padding:  EdgeInsets.all(2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
        
            /// Close Icon
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon:  Icon(Icons.close, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
            ),
        
            /// Title
             Text(
              "Login or sign up",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
        
             SizedBox(height: 8),
        
             Text(
              "Please select your preferred method\n"
              "to continue setting up your account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black45),
            ),
        
             SizedBox(height: 25),
        
            /// Email Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:  Text(
                  "Already have an account? Log in",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
        
             SizedBox(height: 12),
        
            /// Phone Login
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  LoginScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side:  BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:  Text(
                  "Sign up with us",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
        
             SizedBox(height: 20),
        
            /// Google + Apple Buttons
        
             SizedBox(height: 25),
        
            /// Footer Text
             Text(
              "If you are creating a new account,\n"
              "Terms & Conditions and Privacy Policy will apply.",
              style: TextStyle(fontSize: 12, color: Colors.black45),
              textAlign: TextAlign.center,
            ),
        
             SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
