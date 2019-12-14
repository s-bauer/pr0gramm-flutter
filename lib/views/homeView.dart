import 'package:flutter/material.dart';
import 'package:pr0gramm/services/feedProvider.dart';

import 'package:pr0gramm/services/initializeService.dart';
import 'package:pr0gramm/views/overviewView.dart';
import 'package:pr0gramm/views/widgets/drawer.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = InitializeService().initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text("Top"),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: buildProfile(),
      ),
    );
  }

  Widget buildProfile() {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          final provider = FeedProvider(feedType: FeedType.PUBLICNEW);
          return FeedInherited(
            feedProvider: provider,
            feed: provider.getFeed(),
            child: OverviewView(),
          );
        }

        return Container();
      },
    );
  }
}
