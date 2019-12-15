import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pr0gramm/controllers/pageController.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/services/feedProvider.dart';
import 'package:pr0gramm/views/post/post_page.dart';

class PostPageView extends StatefulWidget {
  final int index;
  final Feed feed;
  final _centerKey = UniqueKey();

  PostPageView({Key key, this.index, this.feed}) : super(key: key);

  @override
  _PostPageViewState createState() => _PostPageViewState();
}

class _PostPageViewState extends State<PostPageView> {
  MyPageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MyPageController(keepPage: false, initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    final forwardBuilder = buildForwardBuilder();
    final backwardBuilder = buildBackwardBuilder();
    final scrollView = buildScrollable(backwardBuilder, forwardBuilder);

    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text("Top"),
      ),
      body: scrollView,
    );
  }

  Scrollable buildScrollable(
    StreamBuilder<List<Item>> backwardBuilder,
    StreamBuilder<List<Item>> forwardBuilder,
  ) {
    return Scrollable(
      dragStartBehavior: DragStartBehavior.start,
      axisDirection: AxisDirection.right,
      controller: _controller,
      physics: PageScrollPhysics(),
      viewportBuilder: (BuildContext context, ViewportOffset position) {
        return Viewport(
          cacheExtent: 0,
          axisDirection: AxisDirection.right,
          offset: position,
          center: widget._centerKey,
          slivers: <Widget>[
            backwardBuilder,
            forwardBuilder,
          ],
        );
      },
    );
  }

  StreamBuilder<List<Item>> buildForwardBuilder() {
    return new StreamBuilder<List<Item>>(
      key: widget._centerKey,
      stream: widget.feed.forwardStream,
      initialData: widget.feed.forwardData,
      builder: (context, snapshot) {
        return SliverFillViewport(
          delegate: !snapshot.hasData
              ? SliverChildListDelegate(
                  [Center(child: CircularProgressIndicator())])
              : SliverChildBuilderDelegate((context, index) {
                  return PostPage(
                    item: snapshot.data[index],
                    feed: widget.feed,
                    index: index,
                  );
                }, childCount: snapshot.data.length),
        );
      },
    );
  }

  StreamBuilder<List<Item>> buildBackwardBuilder() {
    return new StreamBuilder<List<Item>>(
      stream: widget.feed.backwardData,
      initialData: widget.feed.backwardData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SliverToBoxAdapter(child: Container());

        return SliverFillViewport(
          delegate: SliverChildBuilderDelegate((context, index) {
            return PostPage(
              item: snapshot.data[index],
              feed: widget.feed,
              index: index,
            );
          }, childCount: snapshot.data.length),
        );
      },
    );
  }
}
