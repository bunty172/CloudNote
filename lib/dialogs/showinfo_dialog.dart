import 'package:flutter/cupertino.dart';

import 'generic_dialog.dart';

Future<bool> showInfoDialog(BuildContext context, String content) async {
  return await showGenericDialog(
      context: context,
      content: content,
      dialogOptionsBuilder: () {
        return {
          "Ok": null,
        };
      });
}
