import 'package:flutter/widgets.dart';
import 'package:uni_links/uni_links.dart';

class LinkHandler {
  bool Function(String link) test;
  dynamic Function(String link) match;
  Future<dynamic> Function(dynamic match, BuildContext context) action;
  bool exclusive;
  LinkHandler({
    bool Function(String link) test,
    dynamic Function(String link) match,
    Future<dynamic> Function(dynamic match, BuildContext context) action
  }) {
    this.test = test;
    this.match = match;
    this.action = action;
  }
}

class AppLinkHandler {
  String latestLink;
  final List<LinkHandler> handlers;
  final BuildContext _context;
  AppLinkHandler(this.handlers, this._context);

  Future<dynamic> init() async {
    String initialLink;
    try {
      initialLink = await getInitialLink();
      if(latestLink == initialLink) return null;
      latestLink = initialLink;
      print('initial link: $initialLink');
      handlers.forEach((handler) async {
        if (handler.test(initialLink)) {
          return handler.action(handler.match(initialLink), this._context);
        }
      });
    } catch (e) {
      initialLink = 'Failed to get initial link.';
    }
  }
}
