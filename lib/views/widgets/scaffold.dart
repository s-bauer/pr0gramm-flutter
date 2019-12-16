import 'package:flutter/material.dart';
import 'package:pr0gramm/views/overview_view.dart';
import 'package:pr0gramm/views/widgets/app_bar.dart';
import 'package:pr0gramm/views/widgets/drawer.dart';

class MyScaffold extends StatefulWidget {
  final Widget body;

  const MyScaffold({Key key, this.body}) : super(key: key);

  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<EndSearchNotification>(
      onNotification: onEndSearchNotification,
      child: NotificationListener<StartSearchNotification>(
        onNotification: onStartSearchNotification,
        child: Scaffold(
          backgroundColor: Colors.black45,
          appBar: isSearching ? MySearchBar() : MyAppBar(),
          drawer: CustomDrawer(),
          body: RefreshIndicator(
            onRefresh: FeedInherited.of(context).feed.refresh,
            child: widget.body,
          ),
        ),
      ),
    );
  }

  bool onStartSearchNotification(StartSearchNotification notification) {
    setState(() {
      isSearching = true;
    });
    return true;
  }

  bool onEndSearchNotification(EndSearchNotification notification) {
    setState(() {
      isSearching = false;
    });
    return true;
  }
}

class StartSearchNotification extends Notification {}

class EndSearchNotification extends Notification {}
