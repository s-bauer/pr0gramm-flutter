import "package:flutter/material.dart";
import 'package:pr0gramm/views/homeView.dart';
import 'package:pr0gramm/widgets/inherited.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyInherited(
      child: MaterialApp(
        title: "Pr0gramm",
        theme: ThemeData(
          primaryColor: Color(0xffee4d2e),
        ),
        home: HomeView(),
      ),
    );
  }
}








