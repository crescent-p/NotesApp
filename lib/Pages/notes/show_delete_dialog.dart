import 'package:flutter/material.dart';
import 'package:friends2/dialog_box/generic_dialog_box.dart';

Future<bool> showDeleteDialog({required BuildContext context}) {
  return showGenericDialog<bool>(
    context: context,
    content: "Do you wanna delete this note?",
    title: 'Delete?',
    optionBuilder: () => {"yes": true, "no": false},
  ).then((value) => value?? false);
}
