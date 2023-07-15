import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Sure??'),
          content: const Text('Do you reallyyyy wanna log out?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("no"))
          ],
        );
      }).then((value) => value ?? false);
}
