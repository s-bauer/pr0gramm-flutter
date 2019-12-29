import 'package:flutter/material.dart';
import 'package:pr0gramm/api/api_client.dart';
import 'package:pr0gramm/views/loginView/login_view.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

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

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
        elevation: 0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("pr0gramm"),
              decoration: BoxDecoration(color: Colors.black45),
            ),
            buildRouteButton(context, "TOP", "/top", Icons.home),
            buildRouteButton(context, "NEW", "/new", Icons.trending_up),
            buildRouteButton(context, "Zufall", "/random", Icons.shuffle),
            buildRouteButton(
                context, "Profil", "/profile", Icons.account_circle, arguments: GlobalInherited.of(context).profile.user.name),
            Divider(),
            isLoggedIn ? loginButton : logoutButton,
          ],
        ),
      ),
    );
  }

  Widget buildRouteButton(
    BuildContext context,
    String name,
    String route,
    IconData icon, {
    dynamic arguments,
  }) {
    final currentRoute = ModalRoute.of(context).settings.name;

    final color =
        currentRoute == route ? Theme.of(context).primaryColor : Colors.black;

    return FlatButton(
      child: Row(
        children: <Widget>[
          Icon(icon, color: color),
          Text(name, style: TextStyle(color: color)),
        ],
      ),
      onPressed: () => navigateTo(context, route, arguments: arguments),
    );
  }

  void navigateTo(BuildContext context, String route, {dynamic arguments}) {
    Navigator.popAndPushNamed(context, route, arguments: arguments);
  }

  void logOut(BuildContext context) {
    final apiClient = ApiClient();
    apiClient.logout();
    GlobalInherited.of(context).onStatusChange(false, null);
  }
}
