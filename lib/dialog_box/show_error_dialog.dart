import 'package:flutter/material.dart';
import 'package:friends2/dialog_box/generic_dialog_box.dart';

Future<void> showErrorDialog(
    {required String content, required BuildContext context}) {
  return showGenericDialog<void>(
    context: context,
    content: content,
    title: "An error Occured",
    optionBuilder: () =>
       {'OK': null}
    
  );
}
