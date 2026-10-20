import 'dart:convert';

import 'package:feedbackarena/constants/api_constants.dart';
import 'package:feedbackarena/models/feedback_model.dart';
import 'package:feedbackarena/screens/admin_homepage.dart';
import 'package:feedbackarena/widgets/app_appbar.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as https;

class FeedbackReviewScreen extends StatefulWidget {
  const FeedbackReviewScreen({
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
  State<FeedbackReviewScreen> createState() => _FeedbackReviewScreenState();
}

class _FeedbackReviewScreenState extends State<FeedbackReviewScreen> {
  String? selectedStatus;

  bool _isUpdating = false;

  Future<void> _updateFeedback() async {
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
          'title': widget.feedbackTitle,
          'description': widget.feedbackDescription,
          'status': selectedStatus,
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
            builder: (context) => AdminHomepage(token: widget.token),
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
    selectedStatus = widget.feedbackStatus;
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
                    Text(
                      widget.feedbackTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

                    Divider(
                      color: const Color.fromARGB(36, 158, 158, 158),
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                    ),

                    // Feedback Description
                    Text(
                      widget.feedbackDescription,
                      style: TextStyle(fontSize: 17),
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

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStatus = statusFeedback.title;
                            });

                            _updateFeedback();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: statusFeedback.title == selectedStatus
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
                                  color: statusFeedback.title == selectedStatus
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 17,
                                ),
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
          ],
        ),
      ),
    );
  }
}
