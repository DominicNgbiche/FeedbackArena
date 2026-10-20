import 'dart:convert';

import 'package:feedbackarena/constants/api_constants.dart';
import 'package:feedbackarena/models/feedback_model.dart';
import 'package:feedbackarena/screens/user_homepage.dart';
import 'package:feedbackarena/widgets/app_appbar.dart';
import 'package:feedbackarena/widgets/continuation_button.dart';
import 'package:feedbackarena/widgets/input_field.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as https;

class EditFeedbackScreen extends StatefulWidget {
  const EditFeedbackScreen({
    super.key,
    required this.feedbackTitle,
    required this.feedbackDescription,
    required this.feedbackStatus,
    required this.feedbackId,
    required this.token,
  });

  final String feedbackTitle;
  final String feedbackDescription;
  final String feedbackStatus;
  final int feedbackId;
  final String token;

  @override
  State<EditFeedbackScreen> createState() => _EditFeedbackScreenState();
}

class _EditFeedbackScreenState extends State<EditFeedbackScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isUpdating = false;

  Future<void> _updateFeedback() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    setState(() {
      _isUpdating = true;
    });
    try {
      final response = await https.put(
        Uri.parse(ApiConstants.updateFeedback(widget.feedbackId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'status': widget.feedbackStatus,
        }),
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Feedback updated successfully!"),
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
            content: Text("Failed to update feedback. Please try again."),
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
        _isUpdating = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.feedbackTitle;
    _descriptionController.text = widget.feedbackDescription;
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
      appBar: AppAppbar(leadingPop: true),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Feedback Title
                    InputField(
                      title: "What is your feedback about?",
                      hintText: "Give your feedback a short title",
                      prefixIcon: null,
                      controller: _titleController,
                      initialValue: widget.feedbackTitle,
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
                      initialValue: widget.feedbackDescription,
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

                    SizedBox(height: 20),

                    // // Change status
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2,
                          ),
                      itemCount: FeedbackStatus.values.length,
                      itemBuilder: (context, index) {
                        final statusFeedback = FeedbackStatus.values[index];

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: statusFeedback.title == widget.feedbackStatus
                                ? Colors.deepOrange
                                : const Color.fromARGB(113, 158, 158, 158),
                          ),
                          padding: EdgeInsets.all(10),
                          height: 30,
                          child: Center(
                            child: Text(
                              statusFeedback.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    statusFeedback.title ==
                                        widget.feedbackDescription
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            ContinuationButton(
              continuationText: _isUpdating
                  ? "Updating Feedback..."
                  : "Update Feedback",
              onTap: _isUpdating ? null : _updateFeedback,
            ),
          ],
        ),
      ),
    );
  }
}
