import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showLoginError(
  BuildContext context,
  String error,
) async {
  print(error);
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
