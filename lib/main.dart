import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

import 'package:dio/adapter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

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
  Future<Captcha> _captchaFuture;
  final _captchaController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  final CookieJar jar = CookieJar();
  final Dio dio = Dio(BaseOptions(baseUrl: "https://pr0gramm.com/api"));

  _MyHomePageState() {
    dio.interceptors.add(CookieManager(jar));
    _captchaFuture = fetchCaptcha();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      // Hook into the findProxy callback to set the client's proxy.
      client.findProxy = (url) {
        return 'PROXY 192.168.11.10:8888';
      };

      // This is a workaround to allow Charles to receive
      // SSL payloads when your app is running on Android.
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => Platform.isAndroid;
    };
  }

  Map<String, String> headers = {};

  Future<Captcha> fetchCaptcha() async {
    final response = await dio.get("/user/captcha");
    return Captcha.fromJson(response.data);
  }

  Future doLogin(BuildContext context) async {
    var captcha = await _captchaFuture;
    final body = {
      "name": _userController.text,
      "password": _passController.text,
      "captcha": _captchaController.text,
      "token": captcha.token
    };

    final response = await dio.post("/user/login", data: body, options: Options(
      contentType: Headers.formUrlEncodedContentType
    ));

    print(response.data);
    print(jar.loadForRequest(Uri.parse("https://pr0gramm.com/")));

    _captchaFuture = fetchCaptcha();

    showAlertDialog(context, "Login Status", response.data["success"] ? "Success" : "Failure!");
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

  void updateCookie(http.Response response) {
    String rawCookie = response.headers["set-cookie"];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers["cookie"] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
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
                      return Image.memory(snapshot.data.captchaBytes);
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    _captchaController.dispose();
    super.dispose();
  }
}

class Captcha {
  final String token;
  final Uint8List captchaBytes;

  Captcha({this.token, String captcha})
      : captchaBytes = Base64Decoder()
            .convert(captcha.replaceFirst("data:image/png;base64,", ""));

  factory Captcha.fromJson(Map<String, dynamic> json) {
    return Captcha(token: json["token"], captcha: json["captcha"]);
  }
}
