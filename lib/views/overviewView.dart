import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/services/feedProvider.dart';
import 'package:pr0gramm/services/imageProvider.dart' as imgProv;
import 'package:pr0gramm/views/widgets/postPage.dart';

class FeedInherited extends InheritedWidget {
  final FeedProvider feedProvider;

  FeedInherited({
    Key key,
    @required this.feedProvider,
    @required Widget child,
  })  : assert(feedProvider != null),
        assert(child != null),
        super(key: key, child: child);

  static FeedInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FeedInherited>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class OverviewView extends StatefulWidget {
  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  final imgProv.ImageProvider _imageProvider = imgProv.ImageProvider();
  FeedProvider feedProvider;

  @override
  Widget build(BuildContext context) {
    if(feedProvider == null)
      feedProvider = FeedInherited.of(context).feedProvider;

    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      physics: new AlwaysScrollableScrollPhysics(),
      itemBuilder: buildItem,
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return FutureBuilder<Item>(
      future: feedProvider.getItem(index),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return GestureDetector(
            child: new FutureBuilder(
              future: _imageProvider.getThumb(snapshot.data),
              builder: (context, snap) {
                return snap.hasData
                    ? Image.memory(snap.data)
                    : new Container();
              },
            ),
            onTap: () => onThumbTap(index),
          );

        return Container();
      },
    );

  }

  void onThumbTap(int index) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => PostPage(
          index: index,
          feedProvider: feedProvider,
        ),
      ),
    );
  }
}
