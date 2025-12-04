import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/screens/onboard_popup.dart';

class OnboardingScreen extends StatefulWidget {
const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      "image": "assets/images/img1.png",
      "title": "Welcome to App",
      "subtitle": "Here's a brief overview of the app's key features.",
    },
    {
      "image": "assets/images/img1.png",
      "title": "Discover Music",
      "subtitle": "Find your favorite songs and artists easily.",
    },
    {
      "image": "assets/images/img1.png",
      "title": "Connect with Friends",
      "subtitle": "Share your playlists and enjoy music together.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 600,
              child: PageView.builder(
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        _slides[index]["image"]!,
                        height: 400,
                        fit: BoxFit.contain,
                      ),
                       SizedBox(height: 20),
                      Text(
                        _slides[index]["title"]!,
                        style:  TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                       SizedBox(height: 8),
                      Text(
                        _slides[index]["subtitle"]!,
                        style:
                             TextStyle(fontSize: 15, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration:  Duration(milliseconds: 300),
                  margin:  EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

             Spacer(),

            
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      builder: (_) =>  LoginPopup(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:  Text(
                    "Get started",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
