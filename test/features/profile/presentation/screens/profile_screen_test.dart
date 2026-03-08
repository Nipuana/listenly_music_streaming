import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weplay_music_streaming/core/services/storage/user_session_service.dart';
import 'package:weplay_music_streaming/features/profile/presentation/screens/edit_profile_screen.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<Widget> buildEditProfileScreen() async {
    final prefs = await SharedPreferences.getInstance();
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MaterialApp(home: EditProfileScreen()),
    );
  }

  group('EditProfileScreen Widget Tests', () {
    testWidgets('renders with correct AppBar title', (tester) async {
      await tester.pumpWidget(await buildEditProfileScreen());
      await tester.pump();

      expect(find.text('Edit Profile'), findsOneWidget);
    });

    testWidgets('has username and email text form fields', (tester) async {
      await tester.pumpWidget(await buildEditProfileScreen());
      await tester.pump();

      expect(find.byType(TextFormField), findsAtLeast(2));
    });

    testWidgets('has Save Changes button', (tester) async {
      await tester.pumpWidget(await buildEditProfileScreen());
      await tester.pump();

      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('can enter text in username field', (tester) async {
      await tester.pumpWidget(await buildEditProfileScreen());
      await tester.pump();

      final usernameField = find.widgetWithText(TextFormField, 'Username');
      expect(usernameField, findsOneWidget);

      await tester.enterText(usernameField, 'testuser');
      await tester.pump();

      expect(find.text('testuser'), findsOneWidget);
    });

    testWidgets('can enter text in email field', (tester) async {
      await tester.pumpWidget(await buildEditProfileScreen());
      await tester.pump();

      final emailField = find.widgetWithText(TextFormField, 'Email');
      expect(emailField, findsOneWidget);

      await tester.enterText(emailField, 'user@example.com');
      await tester.pump();

      expect(find.text('user@example.com'), findsOneWidget);
    });

    testWidgets('form shows validation error for empty username', (tester) async {
      await tester.pumpWidget(await buildEditProfileScreen());
      await tester.pump();

      // Tap save without filling fields
      final saveButton = find.text('Save Changes');
      await tester.tap(saveButton);
      await tester.pump();

      expect(find.text('Username cannot be empty'), findsOneWidget);
    });
  });
}
