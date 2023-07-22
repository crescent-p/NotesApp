import 'package:flutter/material.dart';
import 'package:friends2/dialog_box/generic_dialog_box.dart';

Future<bool> showLogoutMessage({required BuildContext context}) {
  return showGenericDialog<bool>(
    context: context,
    content: "Do you wanna LogOut?",
    title: "Logout",
    optionBuilder: () {
      return {'yes': true, 'no': false};
    },
  ).then((value) => value ?? false);
}
