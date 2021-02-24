import 'package:cable_vasool/common/logout.dart';
import 'package:flutter/material.dart';

class AlertDialogs {
  Future commonDialog(BuildContext context,
      {Widget title, Widget content, List<Widget> actions(context)}) async {
    return await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        actions: actions(dialogContext),
        title: title,
        content: content,
      ),
    );
  }

  Future logoutDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('No')),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: () {
                Navigator.pop(dialogContext);
                Logout().logout(context);
              },
              child: Text('Yes')),
        ],
        title: Text('Warning'),
        content: Text('Do you Really Want to Logout?'),
      ),
    );
  }
}
