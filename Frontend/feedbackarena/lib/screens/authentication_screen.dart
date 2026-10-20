import 'dart:convert';

import 'package:feedbackarena/constants/api_constants.dart';
import 'package:feedbackarena/dummy_data/auth_credential.dart';
import 'package:feedbackarena/screens/admin_homepage.dart';
import 'package:feedbackarena/screens/confirm_email.dart';
import 'package:feedbackarena/screens/forgot_password_screen.dart';
import 'package:feedbackarena/screens/user_homepage.dart';
import 'package:feedbackarena/widgets/continuation_button.dart';
import 'package:feedbackarena/widgets/input_field.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as https;

class AuthenticationScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool isSignIn = true;
  bool passwordObscure = false;
  bool confirmpasswordObscure = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _authenticationKey = GlobalKey<FormState>();

  bool _isAuthenticating = false;

  Future<https.Response> _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final signUpResponse = await https.post(
      Uri.parse(ApiConstants.signup),
      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"email": email, "password": password}),
    );

    print(signUpResponse.statusCode);
    print(signUpResponse.body);

    return signUpResponse;
  }

  Future<https.Response> _signin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final signinResponse = await https.post(
      Uri.parse(ApiConstants.signin),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Status: ${signinResponse.statusCode}');
    print('Body: ${signinResponse.body}');

    return signinResponse;
  }

  Future<void> _authenticate() async {
    // Trim off additional spaces

    final validAuthentication = _authenticationKey.currentState?.validate();

    if (validAuthentication != true) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      if (isSignIn) {
        final response = await _signin();

        // Successful sign in
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Signed in successfully!"),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          );

          print('Token: ${data['token']}');
          print('Role: ${data['role']}');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  data['role'] == 'ADMIN' || data['role'] == 'SUPER_ADMIN'
                  ? AdminHomepage(token: data['token'])
                  : UserHomepage(token: data['token']),
            ),
          );
        }
        //Unsuccessful sign in
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Invalid email or password."),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          );
        }
      }
      // Logic for signing up
      else {
        final response = await _signup();

        // Successful sign up
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Account created! Check your email for the verification code.",
              ),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ConfirmEmail(email: _emailController.text.trim()),
            ),
          );
        }
        // Unsuccessful sign up
        else {
          final data = jsonDecode(response.body);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? "Unable to create account."),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Something went wrong. Please check your connection and try again.",
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Form(
            key: _authenticationKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/FeedbackFlow Logo.png',
                  width: 70,
                  height: 70,
                ),

                SizedBox(height: 20),
                Text(
                  'Sign ${isSignIn ? "in" : "up"} to create or manage feedback',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: 20),

                //Email input box
                InputField(
                  title: "Email",
                  hintText: "feedbackarena@gmail.com",
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                  validator: (value) {
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    if (!emailRegex.hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),

                //Create Password and password for login Box
                InputField(
                  title: isSignIn ? "Password" : "Create Password",
                  hintText: "password",
                  prefixIcon: Icons.lock_clock_outlined,
                  isPassword: true,
                  controller: _passwordController,
                  furtherActionRequired: isSignIn,
                  furtherAction: "Forgot Password?",
                  obscureText: passwordObscure,
                  iconOnPressed: () {
                    setState(() {
                      passwordObscure = !passwordObscure;
                    });
                  },
                  action: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(),
                      ),
                    );
                  },
                  validator: (value) {
                    final capitalLetterRegex = RegExp(r'[A-Z]');
                    final smallLetterRegex = RegExp(r'[a-z]');
                    final numberRegex = RegExp(r'[0-9]');
                    final symbolRexegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    if (value.length < 8) {
                      return "Password must be at least 8 characters long";
                    }
                    if (!capitalLetterRegex.hasMatch(value)) {
                      return "Capital letter required in password";
                    }
                    if (!smallLetterRegex.hasMatch(value)) {
                      return "Small letter required in password";
                    }
                    if (!numberRegex.hasMatch(value)) {
                      return "Number required in password";
                    }
                    if (!symbolRexegex.hasMatch(value)) {
                      return "Symbol required in password";
                    }
                    return null;
                  },
                ),

                //Confirm Password Box
                !isSignIn
                    ? InputField(
                        title: "Confirm Password",
                        hintText: "password",
                        prefixIcon: Icons.lock_clock_outlined,
                        controller: _confirmPasswordController,
                        obscureText: confirmpasswordObscure,
                        iconOnPressed: () {
                          setState(() {
                            confirmpasswordObscure = !confirmpasswordObscure;
                          });
                        },
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Confirm your password";
                          }
                          if (value != _passwordController.text.trim()) {
                            return "Passwords are not matching";
                          }
                          return null;
                        },
                      )
                    : SizedBox.shrink(),

                TextButton(
                  onPressed: () {
                    setState(() {
                      isSignIn = !isSignIn;
                      _emailController.clear();
                      _passwordController.clear();
                      _confirmPasswordController.clear();
                    });
                  },
                  child: Text(
                    isSignIn
                        ? "Have no account? Sign Up"
                        : "Already have an account? Sign In",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Sign up or Sign In Button
                ContinuationButton(
                  continuationText: _isAuthenticating
                      ? (isSignIn ? 'Signing In...' : 'Signing Up...')
                      : (isSignIn ? 'Sign In' : 'Sign Up'),

                  onTap: _isAuthenticating ? null : _authenticate,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
