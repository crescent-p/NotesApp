import 'package:flutter/widgets.dart';
import 'package:friends2/dialog_box/generic_dialog_box.dart';

Future<void> passwordResetDialogBox({required BuildContext context}) {
  return showGenericDialog(
    context: context,
    content:
        "We have sent you a password reset email. Please check your email.",
    title: "Password Reset",
    optionBuilder: () {
      return {"ok": null};
    },
  );
}
