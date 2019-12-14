import 'package:flutter/material.dart';
import 'package:pr0gramm/services/feedProvider.dart';

import 'package:pr0gramm/views/overviewView.dart';
import 'package:pr0gramm/views/widgets/drawer.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
    final provider = FeedProvider(feedType: FeedType.TOP);
    return FeedInherited(
      feedProvider: provider,
      feed: provider.getFeed(),
      child: OverviewView(),
    );
  }
}
