import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/screens/onboard_popup.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            //Top Image 
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: SizedBox(
                height: 330, 
                child: Image.asset(
                  "assets/images/img1.png", 
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Bottom Panel
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black12,
                    offset: Offset(0, -5),
                  )
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// Title
                  const Text(
                    "Welcome to App",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  /// Subtitle
                  const Text(
                    "Here's a good place for a brief overview\nof the app or it's key features.",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  /// Page Indicator 

                  const SizedBox(height: 30),

                  /// Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                            ),
                            builder: (_) => const LoginPopup(),
                                );
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Get started",
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
