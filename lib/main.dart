import "package:flutter/material.dart";
import 'package:pr0gramm/entities/enums/feed_type.dart';
import 'package:pr0gramm/helpers/overview_builder.dart';
import 'package:pr0gramm/services/initialization_service.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initService = new InitializationService();
  final initResult = await initService.initialize();

  runApp(MyApp(initResult: initResult));
}

class MyApp extends StatelessWidget {
  static final OverviewBuilder _overviewBuilder = OverviewBuilder.instance;

  final InitializationResult initResult;
  final routes = {
    "/top": (context) => _overviewBuilder.buildByType(FeedType.TOP),
    "/new": (context) => _overviewBuilder.buildByType(FeedType.NEW),
    "/random": (context) => _overviewBuilder.buildByType(FeedType.RANDOMNEW),
  };

  MyApp({Key key, this.initResult}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GlobalInherited(
      initResult: initResult,
      child: MaterialApp(
        title: "Pr0gramm",
        theme: ThemeData(
          primaryColor: Color(0xffee4d2e),
        ),
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }

  Route onGenerateRoute(RouteSettings settings) {
    if(!routes.containsKey(settings.name)) {
      final route = routes["/top"];
      settings = settings.copyWith(name: "/top");
      return FadingRoute(builder: route, settings: settings);
    }

    final route = routes[settings.name];
    return FadingRoute(builder: route, settings: settings);
  }
}

class FadingRoute<T> extends MaterialPageRoute<T> {
  FadingRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(opacity: animation, child: child);
  }
}








