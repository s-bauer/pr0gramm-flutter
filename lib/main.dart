import "package:flutter/material.dart";
import 'package:pr0gramm/services/initialization_service.dart';
import 'package:pr0gramm/views/home_view.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initService = new InitializationService();
  final initResult = await initService.initialize();

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








