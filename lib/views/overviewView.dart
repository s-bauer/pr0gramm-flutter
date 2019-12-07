import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
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

  @override
  Widget build(BuildContext context) {
    final feedProvider = FeedInherited.of(context).feedProvider;

    return GridView.builder(
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        return FutureBuilder<Item>(
          future: feedProvider.getItem(index),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return GestureDetector(
                child: new FutureBuilder(
                  future: _imageProvider.getThumb(snapshot.data),
                  builder: (context, snap) {
                    if (snap.hasData) return Image.memory(snap.data);

                    return Container(color: Colors.red);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostPage(
                        index: index,
                        feedProvider: feedProvider,
                      ),
                    ),
                  );
                },
              );

            return CircularProgressIndicator();
          },
        );
      },
    );
  }
}
