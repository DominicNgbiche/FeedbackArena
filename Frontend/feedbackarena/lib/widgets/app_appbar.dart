import 'dart:io';

import 'package:flutter/material.dart';

class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  const new({super.key, this.leadingPop = false});
  final bool leadingPop;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leadingPop
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              ),
            )
          : null,
      title: Row(
        children: [
          // Image on title
          Image.asset(
            'assets/images/FeedbackFlow Logo.png',
            width: 30,
            height: 30,
          ),

          SizedBox(width: 10),

          // Text on Title
          Text(
            'FeedbackArena',
            style: Theme.of(context).textTheme.bodySmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
