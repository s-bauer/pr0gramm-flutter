import 'package:flutter/material.dart';
import 'package:pr0gramm/api/api_client.dart';
import 'package:pr0gramm/views/loginView/loginView.dart';
import 'package:pr0gramm/widgets/inherited.dart';

class CustomDrawer extends Drawer {
  @override
  Widget build(BuildContext context) {
    final isLoggedIn = GlobalInherited.of(context).isLoggedIn;

    final loginButton = FlatButton(
      onPressed: () => this.logOut(context),
      child: Row(
        children: <Widget>[
          Icon(Icons.exit_to_app),
          Text("Abmelden"),
        ],
      ),
    );

    final logoutButton = FlatButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.account_circle),
          Text("Anmelden"),
        ],
      ),
    );

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [isLoggedIn ? loginButton : logoutButton],
      ),
    );
  }

  logOut(BuildContext context) {
    final apiClient = ApiClient();
    apiClient.logout();
    GlobalInherited.of(context).onStatusChange(false, null);
  }
}
