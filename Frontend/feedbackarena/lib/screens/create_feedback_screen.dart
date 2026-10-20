import 'dart:convert';

import 'package:feedbackarena/constants/api_constants.dart';
import 'package:feedbackarena/screens/user_homepage.dart';
import 'package:feedbackarena/widgets/app_appbar.dart';
import 'package:feedbackarena/widgets/continuation_button.dart';
import 'package:feedbackarena/widgets/input_field.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as https;

class CreateFeedbackScreen extends StatefulWidget {
  const CreateFeedbackScreen({super.key, required this.token});
  final String token;

  @override
  State<CreateFeedbackScreen> createState() => _CreateFeedbackScreenState();
}

class _CreateFeedbackScreenState extends State<CreateFeedbackScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isAdding = false;

  Future<void> _createFeedback() async {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();

    setState(() {
      _isAdding = true;
    });
    try {
      final response = await https.post(
        Uri.parse('${ApiConstants.createFeedback}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'status': 'New',
        }),
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Feedback created successfully!"),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => UserHomepage(token: widget.token),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create feedback. Please try again."),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
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
      setState(() {
        _isAdding = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            //Share your feedback Text
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Share your feedback",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),

            // Help us to understand... Text
            Text(
              "Help us to understand your issue or suggestion.",
              style: Theme.of(context).textTheme.bodySmall!
                  .copyWith(fontSize: 16),
            ),

            SizedBox(height: 20),

            // Box containing the input fields for feedback title and description
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Feedback Title Box
                    InputField(
                      title: "What is your feedback about?",
                      hintText: "Give your feedback a short title",
                      prefixIcon: null,
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Provide the feedback title";
                        }
                        return null;
                      },
                    ),

                    // Feedback Description Box
                    InputField(
                      title: "Tell us more",
                      hintText: "Describe the feedback",
                      prefixIcon: null,
                      controller: _descriptionController,
                      maxLines: null,
                      maxLength: 1000,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Provide the feedback description";
                        }
                        if (value.length > 1000) {
                          return "At least 1000 characters allowed";
                        }
                        return null;
                      },
                    ),

                    //Submit Feedback Button
                    ContinuationButton(
                      continuationText: _isAdding
                          ? "Submitting Feedback..."
                          : "Submit Feedback",
                      onTap: _isAdding ? null : _createFeedback,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
