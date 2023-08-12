// import 'package:flutter/material.dart';

// typedef CloseDialog = void Function();

// CloseDialog showLoadingDialog({
//   required BuildContext context,
//   required String text,
// }) {
//   const dialog = AlertDialog(
//     content: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         CircularProgressIndicator(),
//         SizedBox(height: 10.0),
//         Text("Loading"),
//       ],
//     ),
//   );
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return dialog;
//     },
//   );
//   return () => Navigator.of(context).pop();
// }
