import 'package:flutter/material.dart';
import 'package:weplay_music_streaming/common/my_snack.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Snackbar')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            MySnack.show(
              context,
              message: 'This is a custom Snackbar!',
              icon: Icons.music_note,
              actionLabel: 'UNDO',
              onAction: () {},
            );
          },
          child: const Text('Show Snackbar'),
        ),
      ),
    );
  }
}
