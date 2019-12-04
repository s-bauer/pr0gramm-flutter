import "package:flutter/material.dart";
import 'package:pr0gramm/services/AppLinkHandler.dart';
import 'package:pr0gramm/services/itemProvider.dart';
import 'package:pr0gramm/views/homeView.dart';
import 'package:pr0gramm/views/widgets/postPage.dart';
import 'package:pr0gramm/widgets/inherited.dart';

final topLinkHandler = LinkHandler(
    test: (input) => RegExp(r"top\/[0-9][0-9]*").hasMatch(input ?? ""),
    match: (input) =>
        RegExp(r"(?<=top\/)[0-9][0-9]*").stringMatch(input ?? ""),
    action: (match, context) async {
      print('here');
      await ItemProvider().getItemById(int.parse(match));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context2) {
          print('should');
          return PostPage(index: 0);
        }),
      );
    });


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return MyInherited(
      child: MaterialApp(
        title: "Pr0gramm",
        theme: ThemeData(
          primaryColor: Color(0xffee4d2e),
        ),
        home: Builder(
            builder: (context) => FutureBuilder(
                  future: AppLinkHandler([topLinkHandler], context).init(),
                  builder: (context, snap) => HomeView(),
                )),
      ),
    );
  }
}
