import 'package:feedbackarena/models/feedback_model.dart';
import 'package:flutter/material.dart';

class FeedbackCard extends StatelessWidget {
  const new({
    super.key,
    required this.feedbackTitle,
    required this.feedbackDescription,
  });
  final String feedbackTitle;
  final String feedbackDescription;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feedbackTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              feedbackDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
