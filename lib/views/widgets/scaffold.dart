import 'package:flutter/material.dart';
import 'package:pr0gramm/views/overview_grid.dart';
import 'package:pr0gramm/views/profile/widgets/profile_comment_overview.dart';
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
    var name = ModalRoute.of(context).settings?.name;
    bool isSearchRoute = name == "/search";
    bool isProfileRoute = name == "/profile";

    return NotificationListener<EndSearchNotification>(
      onNotification: onEndSearchNotification,
      child: NotificationListener<StartSearchNotification>(
        onNotification: onStartSearchNotification,
        child: Scaffold(
          backgroundColor: Colors.black45,
          appBar: isSearching ? MySearchBar() : MyAppBar(),
          drawer: isSearchRoute || isProfileRoute ? null : CustomDrawer(),
          body: RefreshIndicator(
            onRefresh: () => refreshInheritedFeeds(context),
            child: widget.body,
          ),
        ),
      ),
    );
  }

  Future<void> refreshInheritedFeeds(BuildContext context) async {
    await FeedInherited.of(context)?.feed?.refresh();
    await CommentFeedInherited.of(context)?.feed?.refresh();
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
