import 'package:feedbackarena/dummy_data/feedbacks.dart';
import 'package:feedbackarena/screens/admin_homepage.dart';
import 'package:feedbackarena/screens/authentication_screen.dart';
import 'package:feedbackarena/screens/confirm_email.dart';
import 'package:feedbackarena/screens/create_feedback_screen.dart';
import 'package:feedbackarena/screens/feedback_confirmation.dart';
import 'package:feedbackarena/screens/feedback_review_screen.dart';
import 'package:feedbackarena/screens/user_homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 235, 240, 252),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 235, 240, 252),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 37, 99, 235),
          brightness: Brightness.light,
        ).copyWith(primaryContainer: const Color.fromARGB(255, 37, 99, 235)),

        textTheme: TextTheme(
          bodySmall: TextStyle(fontFamily: 'serif', fontSize: 18),
        ),
      ),
      home: AuthenticationScreen(),
    );
  }
}
