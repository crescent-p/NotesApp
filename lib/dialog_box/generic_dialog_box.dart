import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>(
    {required BuildContext context,
    required String content,
    required String title,
    required DialogOptionBuilder optionBuilder}) {
  final options = optionBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actions: options.keys.map((titleText) {
          final value = options[titleText];
          return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(titleText));
        }).toList(),
        content: Text(content),
        title: Text(title),
      );
    },
  );
}
