import 'package:cable_vasool/common/logout.dart';
import 'package:cable_vasool/providers/admin/admin_dashboard_provider.dart';
import 'package:cable_vasool/utils/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          TextButton(
              onPressed: () {
                AlertDialogs().logoutDialog(context);
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      body: Consumer<AdminDashboardProvider>(
        builder: (BuildContext context, provider, Widget child) {
          return Center(
            child: provider.isUploading
                ? Text(
                    '${provider.uploadedCount} of ${provider.totalCount} Uploaded')
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        child: Text('Upload Setup Box CSV'),
                        onPressed: () => provider.pickFile(1),
                      ),
                      ElevatedButton(
                        child: Text('Upload Connections CSV'),
                        onPressed: () => provider.pickFile(2),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
