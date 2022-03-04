import 'package:flutter/material.dart';

import 'logout_button.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 4, top: 15),
        child: Text(
          'My Notes',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
      ),
      actions: [LogoutButton()],
    );
  }
}
