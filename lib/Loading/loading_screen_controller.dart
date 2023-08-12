import 'package:flutter/material.dart';

typedef CloseDialog = bool Function();

typedef UpdateNote = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseDialog close;
  final UpdateNote update;

  const LoadingScreenController({required this.close, required this.update});
}
