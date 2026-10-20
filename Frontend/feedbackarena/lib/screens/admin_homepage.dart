import 'dart:convert';

import 'package:feedbackarena/constants/api_constants.dart';
import 'package:feedbackarena/dummy_data/feedbacks.dart';
import 'package:feedbackarena/screens/feedback_review_screen.dart';
import 'package:feedbackarena/widgets/app_appbar.dart';
import 'package:feedbackarena/widgets/continuation_button.dart';
import 'package:feedbackarena/widgets/feedback_card.dart';
import 'package:feedbackarena/widgets/input_field.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as https;

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key, required this.token});
  final String token;

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  bool _isfetching = false;
  bool _isDemoting = false;
  bool _isPromoting = false;

  final _emailController = TextEditingController();

  List<dynamic> allFeedbacks = [];

  Future<void> _getAllFeedbacks() async {
    setState(() {
      _isfetching = true;
    });
    try {
      final response = await https.get(
        Uri.parse(ApiConstants.allFeedbacks),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print('All feedback: $data');

        setState(() {
          allFeedbacks = data;
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

  Future<void> _updateRole(bool isPromote) async {
    final email = _emailController.text.trim();

    setState(() {
      isPromote ? _isPromoting = true : _isDemoting = true;
    });
    try {
      final response = await https.put(
        Uri.parse(
          isPromote == true
              ? ApiConstants.promoteAdmin(email)
              : ApiConstants.demoteUser(email),
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Update Completed Successfully!"),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );

        // We will display this data in your existing UI.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update. Please try again."),
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
        _isPromoting = false;
        _isDemoting = false;
      });
    }
  }

  initState() {
    super.initState();
    _getAllFeedbacks();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            InputField(
              title: "Email",
              hintText: "feedbackarena@gmail.com",
              prefixIcon: Icons.email_outlined,
              controller: _emailController,
              validator: (value) {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (value == null || value.isEmpty) {
                  return "Please enter your email";
                }
                if (!emailRegex.hasMatch(value)) {
                  return "Please enter a valid email";
                }
                return null;
              },
            ),

            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                    onPressed: (_isDemoting || _isPromoting)
                        ? null
                        : () => _updateRole(false),
                    child: Text(
                      _isDemoting ? "Demoting Admin..." : "Demote Admin",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: (_isDemoting || _isPromoting)
                        ? null
                        : () => _updateRole(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                    ),
                    child: Text(
                      _isPromoting ? "Promoting User..." : "Promote User",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Feedbacks",
                style: Theme.of(context).textTheme.bodySmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10),

            //List of feedbacks
            Expanded(
              child: _isfetching
                  ? Center(child: CircularProgressIndicator())
                  : allFeedbacks.isEmpty
                  ? Center(child: Text("No feedback available."))
                  : ListView.builder(
                      itemCount: allFeedbacks.length,
                      itemBuilder: (context, index) {
                        final feedback = allFeedbacks[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeedbackReviewScreen(
                                  feedbackTitle: feedback['title'],
                                  feedbackDescription: feedback['description'],
                                  feedbackStatus: feedback['status'],
                                  feedbackId: feedback['id'],
                                  token: widget.token,
                                ),
                              ),
                            );
                            print('Feedback status: ${feedback['status']}');
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
