
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/apiClient.dart';
import 'package:pr0gramm/api/profileApi.dart';
import 'package:pr0gramm/data/sharedPrefKeys.dart';
import 'package:pr0gramm/widgets/inherited.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginView.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future _initFuture;

  Future initialize(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(SharedPrefKeys.Token) &&
          prefs.containsKey(SharedPrefKeys.MeToken) &&
          prefs.containsKey(SharedPrefKeys.UserName)) {
        final apiClient = ApiClient();

        final token = prefs.getString(SharedPrefKeys.Token);
        final meToken = prefs.getString(SharedPrefKeys.MeToken);
        apiClient.setToken(token, meToken);

        final username = prefs.getString(SharedPrefKeys.UserName);

        final api = ProfileApi();
        final profile = await api.getProfileInfo(name: username, flags: 15);

        MyInherited.of(context).onStatusChange(true, profile);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void logOut() {
    final apiClient = ApiClient();
    apiClient.logout();

    MyInherited.of(context).onStatusChange(false, null);
  }


  @override
  Widget build(BuildContext context) {
    if(_initFuture == null)
      _initFuture = initialize(context);

    final isLoggedIn = MyInherited.of(context).isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: isLoggedIn ? buildProfile() : buildLoginButton(),
      ),
    );
  }

  FutureBuilder buildLoginButton() {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return RaisedButton(
            child: const Text("Login"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            },
          );

        return CircularProgressIndicator();
      },
    );
  }

  Widget buildProfile() {
    var profile = MyInherited.of(context).profile;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Welcome ${profile.user.name}"),
        RaisedButton(
          child: Text("Logout"),
          onPressed: logOut,
        )
      ],
    );
  }
}