import 'package:flutter/material.dart';

class FeedbackConfirmation extends StatefulWidget {
  const new({super.key});

  @override
  State<FeedbackConfirmation> createState() => _FeedbackConfirmationState();
}

class _FeedbackConfirmationState extends State<FeedbackConfirmation>
    with SingleTickerProviderStateMixin {
  late AnimationController _confirmaionAnimation;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    //Duration for the animation
    _confirmaionAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Controls amount of animation
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_confirmaionAnimation);

    // Start the animation
    _confirmaionAnimation.forward();
  }

  @override
  void dispose() {
    _confirmaionAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _animation,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: const Color.fromARGB(255, 11, 94, 14),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  size: 30,
                ),
              ),
            ),
            SizedBox(height: 25),

            Text(
              "Thank you!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),

            SizedBox(height: 5),

            Text(
              'Feedback Submitted Successfully',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
