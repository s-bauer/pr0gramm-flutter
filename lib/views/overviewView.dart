import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/services/feedProvider.dart';
import 'package:pr0gramm/services/imageProvider.dart' as imgProv;
import 'package:pr0gramm/views/post/post_page_view.dart';

class FeedInherited extends InheritedWidget {
  final FeedProvider feedProvider;
  final Feed feed;

  FeedInherited({
    Key key,
    @required this.feedProvider,
    @required this.feed,
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
  final _centerKey = UniqueKey();

  @override
  _OverviewViewState createState() => _OverviewViewState();
}



class _OverviewViewState extends State<OverviewView> {
  final imgProv.ImageProvider _imageProvider = imgProv.ImageProvider();
  final ScrollController _controller = new ScrollController();
  Feed currentFeed;

  @override
  Widget build(BuildContext context) {
    if (currentFeed == null) {
      currentFeed = FeedInherited.of(context).feed;
    }

    final forwardBuilder = new StreamBuilder<List<Item>>(
      key: widget._centerKey,
      stream: currentFeed.forwardStream,
      initialData: currentFeed.forwardData,
      builder: (context, snapshot) {
        final grid = SliverGrid(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          delegate: new SliverChildBuilderDelegate(
              (context, index) => buildItem(context, snapshot.data[index], index),
            childCount: snapshot.data?.length ?? 0
          ),
        );

        final circ = SliverFillViewport(delegate: SliverChildListDelegate([
          Center(child: CircularProgressIndicator()),
        ]));

        return SliverSafeArea(
          sliver: snapshot.hasData ? grid : circ,
        );
      },
    );

    final backwardsBuilder = new StreamBuilder<List<Item>>(
      stream: currentFeed.backwardStream,
      initialData: currentFeed.backwardData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(child: Container());
        }

        return SliverGrid(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          delegate: new SliverChildBuilderDelegate(
                  (context, index) => buildItem(context, snapshot.data[index], index),
              childCount: snapshot.data?.length ?? 0
          ),
        );
      },
    );

    return RefreshIndicator(
      onRefresh: currentFeed.refresh,
      child: CustomScrollView(
        controller: _controller,
        center: widget._centerKey,
        slivers: <Widget>[
          backwardsBuilder,
          forwardBuilder
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final max = _controller.position.maxScrollExtent;
    final min = _controller.position.minScrollExtent;
    final offset = _controller.offset;

    if(offset - 50 <= min) {
      currentFeed.loadBackwards();
    }

    if (offset + 50 >= max) {
      currentFeed.loadForward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildItem(BuildContext context, Item item, int index) {
    return GestureDetector(
      child: new FutureBuilder(
        future: _imageProvider.getThumb(item),
        builder: (context, snap) {
          return snap.hasData ? Image.memory(snap.data) : new Container();
        },
      ),
      onTap: () {
        onThumbTap(index);
      },
    );
  }


  void onThumbTap(int index) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => PostPageView(
          index: index,
          feed: currentFeed,
        ),
      ),
    );
  }
}
