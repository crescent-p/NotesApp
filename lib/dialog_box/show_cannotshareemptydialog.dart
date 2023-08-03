import 'package:flutter/cupertino.dart';
import 'package:friends2/dialog_box/generic_dialog_box.dart';

Future<void> cannotShareEmptyText({required BuildContext context}) async {
 return await showGenericDialog<void>(
      context: context,
      content: 'Empty Text can\'t be shared',
      title: 'Empty Text',
      optionBuilder: () => {'ok': null});
}
