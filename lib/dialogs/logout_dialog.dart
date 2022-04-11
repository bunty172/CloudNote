import 'package:flutter/cupertino.dart';

import 'generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) async {
  return await showGenericDialog(
      context: context,
      content: "Are you sure wanna Logout?",
      dialogOptionsBuilder: () {
        return {
          "Cancel": false,
          "LogOut": true,
        };
      }).then((value) => value ?? false);
}
