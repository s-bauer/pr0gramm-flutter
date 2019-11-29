import "dart:math";

import "package:flutter/material.dart";
import 'package:pr0gramm/api/profileApi.dart';

import "api/dtos/captcha.dart";
import "api/loginApi.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _captchaController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  static final _loginApi = LoginApi();
  static final _profileApi = ProfileApi();

  Future<Captcha> _captchaFuture = _loginApi.getCaptcha();

  void newCaptcha() {
    _captchaFuture = _loginApi.getCaptcha();
    _captchaController.clear();
    setState(() {});
  }

  Future doLogin(BuildContext context) async {
    final captcha = await _captchaFuture;
    captcha.captchaResult = _captchaController.text;

    final result = await _loginApi.doLogin(
      user: _userController.text,
      pass: _passController.text,
      captcha: captcha,
    );

    if(result?.success ?? false) {
      showAlertDialog(context, "Login Success", "Welcome ${result.username}");

      final profile = await _profileApi.getProfileInfo(
        name: result.username,
        flags: 15,
      );

      showAlertDialog(context, "Benis", "Dein Benis ${profile.user.score}");
    } else {
      showAlertDialog(context, "Login Failure", "Unable to login: ${result?.error}");
      newCaptcha();
    }
  }

  showAlertDialog(BuildContext context, String title, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { 
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                width: max(MediaQuery.of(context).size.width * 0.8, 250),
                child: FutureBuilder<Captcha>(
                  future: _captchaFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return GestureDetector(
                        onTap: newCaptcha,
                        child: Image.memory(snapshot.data.captchaBytes),
                      );
                    else
                      return CircularProgressIndicator();
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                width: max(MediaQuery.of(context).size.width * 0.8, 250),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _captchaController,
                      textAlign: TextAlign.center,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Captcha"
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _userController,
                      textAlign: TextAlign.center,
                      autocorrect: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "User"
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passController,
                      textAlign: TextAlign.center,
                      obscureText: true,
                      autocorrect: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password"
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () => doLogin(context),
      ),
    );
  }

  @override
  void dispose() {
    _captchaController.dispose();
    _passController.dispose();
    _userController.dispose();
    super.dispose();
  }
}


