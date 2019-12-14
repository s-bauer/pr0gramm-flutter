import "package:flutter/material.dart";
import 'package:pr0gramm/services/initializeService.dart';
import 'package:pr0gramm/views/homeView.dart';
import 'package:pr0gramm/widgets/inherited.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initService = new InitializeService();
  final initResult = await initService.initialize2();

  runApp(MyApp(initResult: initResult));
}

class MyApp extends StatelessWidget {
  final InitializationResult initResult;

  const MyApp({Key key, this.initResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalInherited(
      initResult: initResult,
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








