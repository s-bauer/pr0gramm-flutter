import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pr0gramm/api/itemApi.dart';
import 'package:pr0gramm/controllers/pageController.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/entities/commonTypes/linkedStuff/linkedComments.dart';
import 'package:pr0gramm/entities/postInfo.dart';
import 'package:pr0gramm/services/feedProvider.dart';
import 'package:pr0gramm/services/timeFormatter.dart';
import 'package:pr0gramm/views/widgets/userMark.dart';
import '../postView.dart';

const authorTextStyle = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  letterSpacing: 1,
);

const postTimeTextStyle = const TextStyle(
  fontSize: 8,
  color: Colors.white70,
);

class PostButtons extends StatelessWidget {
  final PostInfo info;

  const PostButtons({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          color: Colors.white,
          onPressed: () {},
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () {},
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.favorite_border),
          onPressed: () {},
        ),
        Container(
          height: 30.0,
          width: 1.0,
          color: Colors.white30,
          margin: const EdgeInsets.only(left: 10.0, right: 20.0),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    info.item.user,
                    style: authorTextStyle,
                  ),
                  UserMarkWidget(
                    userMark: info.item.mark,
                    radius: 2.5,
                  )
                ],
              ),
              Text(
                formatTime(info.item.created * 1000),
                style: postTimeTextStyle,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class PostTags extends StatelessWidget {
  final PostInfo info;

  const PostTags({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tags = info.info.tags
      ..sort((a, b) => b.confidence.compareTo(a.confidence));

    var tagWidgets = tags.map((t) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Text(
              t.tag,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: tagWidgets),
      ),
    );
  }
}

class PostComments extends StatelessWidget {
  final PostInfo info;

  const PostComments({Key key, this.info}) : super(key: key);

  List<LinkedComment> linkComments() {
    final plainComments = info.info.comments;
    return plainComments
        .where((c) => c.parent == 0)
        .map((c) => LinkedComment.root(c, plainComments))
        .toList()
          ..sort(
              (a, b) => b.comment.confidence.compareTo(a.comment.confidence));
  }

  @override
  Widget build(BuildContext context) {
    var comments = linkComments();

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 20.0, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: comments.map((c) => c.build()).toList(),
      ),
    );
  }
}

class PostPage extends StatefulWidget {
  final int index;
  final Feed feed;
  final _centerKey = UniqueKey();

  PostPage({Key key, this.index, this.feed}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  MyPageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MyPageController(keepPage: false, initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    final forwardBuilder = new StreamBuilder<List<Item>>(
      key: widget._centerKey,
      stream: widget.feed.forwardStream,
      initialData: widget.feed.forwardData,
      builder: (context, snapshot) {
        return SliverFillViewport(
          delegate: !snapshot.hasData
              ? SliverChildListDelegate(
                  [Center(child: CircularProgressIndicator())])
              : SliverChildBuilderDelegate((context, index) {
                  print("Building front $index");

                  final item = widget.feed.getItemWithInfo(index);
                  final future = ItemApi().getItemInfo(item.id).then((info) {
                    return PostInfo(info: info, item: item);
                  });
                  return buildFutureBuilder(future, widget.index);
                }, childCount: snapshot.data.length),
        );
      },
    );

    final backwardBuilder = new StreamBuilder<List<Item>>(
      stream: widget.feed.backwardData,
      initialData: widget.feed.backwardData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SliverToBoxAdapter(child: Container());

        return SliverFillViewport(
          delegate: SliverChildBuilderDelegate((context, index) {
            print("Building back $index");
            final item = widget.feed.getItemWithInfo(index);
            final future = ItemApi().getItemInfo(item.id).then((info) {
              return PostInfo(info: info, item: item);
            });
            return buildFutureBuilder(future, widget.index);
          }, childCount: snapshot.data.length),
        );
      },
    );

    final scrollView = Scrollable(
      dragStartBehavior: DragStartBehavior.start,
      axisDirection: AxisDirection.right,
      controller: _controller,
      physics: PageScrollPhysics(),
      viewportBuilder: (BuildContext context, ViewportOffset position) {
        return Viewport(
          cacheExtent: 0.0,
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

    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text("Top"),
      ),
      body: scrollView,
    );
  }

  FutureBuilder<PostInfo> buildFutureBuilder(
      Future<PostInfo> future, int index) {
    return FutureBuilder<PostInfo>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PostView(item: snapshot.data.item),
              PostButtons(info: snapshot.data),
              PostTags(info: snapshot.data),
              PostComments(info: snapshot.data)
            ],
          ),
        );
      },
    );
  }
}
