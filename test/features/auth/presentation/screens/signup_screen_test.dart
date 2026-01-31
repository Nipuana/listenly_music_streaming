import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/features/auth/presentation/screens/signup_screen.dart';

void main() {
  group('SignupScreen Widget Tests', () {
    testWidgets('renders signup screen with all key widgets', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Verify key widgets are present
      expect(find.text('Create your account'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);
    });

    testWidgets('has all required text fields', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Verify text fields exist
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.widgetWithText(TextFormField, 'Your username'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'your@email.com'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Create a strong password'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Re-enter your password'), findsOneWidget);
    });

    testWidgets('password visibility toggle works', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Find password visibility icons (should be 2 - password and confirm password)
      final visibilityOffIcons = find.byIcon(Icons.visibility_off_outlined);
      expect(visibilityOffIcons, findsNWidgets(2));

      // Tap first visibility button
      await tester.tap(visibilityOffIcons.first);
      await tester.pump();

      // One should change to visibility icon
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('can enter text in username field', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Find username field
      final usernameField = find.widgetWithText(TextFormField, 'Your username');
      
      // Enter text
      await tester.enterText(usernameField, 'testuser');
      await tester.pump();

      // Verify text was entered
      expect(find.text('testuser'), findsOneWidget);
    });

    testWidgets('can enter text in email field', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Find email field
      final emailField = find.widgetWithText(TextFormField, 'your@email.com');
      
      // Enter text
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      // Verify text was entered
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('can enter text in password fields', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Find password fields
      final passwordField = find.widgetWithText(TextFormField, 'Create a strong password');
      final confirmPasswordField = find.widgetWithText(TextFormField, 'Re-enter your password');
      
      // Enter text in both
      await tester.enterText(passwordField, 'password123');
      await tester.pump();
      await tester.enterText(confirmPasswordField, 'password123');
      await tester.pump();

      // Verify text was entered (only shows once since it's obscured)
      expect(find.text('password123'), findsNWidgets(2));
    });

    testWidgets('has terms and conditions checkbox', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Verify checkbox exists
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('I agree to the '), findsOneWidget);
      expect(find.text('Terms & Conditions'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('checkbox can be toggled', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Find checkbox
      final checkbox = find.byType(Checkbox);
      
      // Initial state should be unchecked
      Checkbox checkboxWidget = tester.widget(checkbox);
      expect(checkboxWidget.value, false);

      // Tap checkbox
      await tester.tap(checkbox);
      await tester.pump();

      // Should now be checked
      checkboxWidget = tester.widget(checkbox);
      expect(checkboxWidget.value, true);
    });

    testWidgets('has social signup buttons', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Verify social signup buttons
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);
      expect(find.text('OR'), findsOneWidget);
    });

    testWidgets('form validation shows error for empty fields', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Find and tap signup button without filling fields
      final signupButton = find.text('Sign up');
      await tester.tap(signupButton);
      await tester.pumpAndSettle();

      // Validation should show errors
      expect(find.text('Enter your username'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
      expect(find.text('Confirm your password'), findsOneWidget);
    });

    testWidgets('has password length hint text', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignupScreen(),
          ),
        ),
      );

      // Verify password hint
      expect(find.text('Must be at least 8 characters long'), findsOneWidget);
    });
  });
}
