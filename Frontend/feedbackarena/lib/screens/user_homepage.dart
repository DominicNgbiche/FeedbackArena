import 'dart:convert';

import 'package:feedbackarena/constants/api_constants.dart';
import 'package:feedbackarena/screens/create_feedback_screen.dart';
import 'package:feedbackarena/screens/edit_feedback_screen.dart';
import 'package:feedbackarena/widgets/app_appbar.dart';
import 'package:feedbackarena/widgets/feedback_card.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as https;

class UserHomepage extends StatefulWidget {
  const UserHomepage({super.key, required this.token});
  final String token;

  @override
  State<UserHomepage> createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  bool _isfetching = false;

  List<dynamic> myFeedback = [];

  Future<void> _getMyFeedbacks() async {
    setState(() {
      _isfetching = true;
    });
    try {
      final response = await https.get(
        Uri.parse(ApiConstants.myFeedback),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print('My feedback: $data');

        setState(() {
          myFeedback = data;
        });

        // We will display this data in your existing UI.
      } else {
        print('Failed to load feedback');
      }
    } catch (e) {
      print('Error loading feedback: $e');
    } finally {
      setState(() {
        _isfetching = false;
      });
    }
  }

  void _deleteFeedback(int id) async {
    try {
      final response = await https.delete(
        Uri.parse(ApiConstants.updateFeedback(id)),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          myFeedback.removeWhere((feedback) => feedback['id'] == id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Feedback deleted Successfully!"),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not delete feedback. Try again."),
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
    }
  }

  @override
  void initState() {
    super.initState();
    _getMyFeedbacks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome back",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),

            // Help us to understand... Text
            Text(
              "Track your feedback status or share new thoughts.",
              style: Theme.of(context).textTheme.bodySmall!
                  .copyWith(fontSize: 16),
            ),

            SizedBox(height: 10),

            //Create feedback button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateFeedbackScreen(token: widget.token),
                  ),
                );
              },
              icon: Icon(Icons.add),
              label: Text(
                "New Feedback",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Your feedbacks",
              style: Theme.of(context).textTheme.bodySmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: _isfetching
                  ? const Center(child: CircularProgressIndicator())
                  : myFeedback.isEmpty
                  ? const Center(child: Text("No feedback available."))
                  : ListView.builder(
                      itemCount: myFeedback.length,
                      itemBuilder: (context, index) {
                        final feedback = myFeedback[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditFeedbackScreen(
                                  feedbackTitle: feedback['title'],
                                  feedbackDescription: feedback['description'],
                                  feedbackStatus: feedback['status'],
                                  feedbackId: feedback['id'],
                                  token: widget.token,
                                ),
                              ),
                            );
                          },

                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Delete Feedback"),
                                  content: const Text(
                                    "Do you want to delete this feedback?",
                                  ),

                                  actions: [
                                    // Cancel Option
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"),
                                    ),

                                    // Delete Option
                                    TextButton(
                                      onPressed: () {
                                        _deleteFeedback(feedback['id']);

                                        Navigator.pop(context);
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: FeedbackCard(
                            feedbackTitle: feedback['title'],
                            feedbackDescription: feedback['description'],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
