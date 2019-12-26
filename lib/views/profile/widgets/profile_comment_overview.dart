import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/comment/profile_comment.dart';
import 'package:pr0gramm/api/dtos/user/user.dart';
import 'package:pr0gramm/entities/profile_comment_feed.dart';

class CommentFeedInherited extends InheritedWidget {
  final ProfileCommentFeed feed;

  CommentFeedInherited({
    Key key,
    @required this.feed,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static CommentFeedInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CommentFeedInherited>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class ProfileCommentOverview extends StatefulWidget {
  final _centerKey = UniqueKey();

  final User user;

  ProfileCommentOverview({Key key, this.user}) : super(key: key);

  @override
  _ProfileCommentOverviewState createState() => _ProfileCommentOverviewState();
}

class _ProfileCommentOverviewState extends State<ProfileCommentOverview> {
  final ScrollController _controller = new ScrollController();
  ProfileCommentFeed currentFeed;

  @override
  Widget build(BuildContext context) {
    if (currentFeed == null) {
      currentFeed = CommentFeedInherited.of(context).feed;
    }

    final forwardBuilder = new StreamBuilder<List<ProfileComment>>(
      key: widget._centerKey,
      stream: currentFeed.forwardStream,
      initialData: currentFeed.forwardData,
      builder: (context, snapshot) {
        final grid = SliverList(
          delegate: new SliverChildBuilderDelegate(
            (context, index) => snapshot.data[index].toWidget(widget.user),
            childCount: snapshot.data?.length ?? 0,
          ),
        );

        final circ = SliverFillViewport(
            delegate: SliverChildListDelegate([
          Center(child: CircularProgressIndicator()),
        ]));

        return SliverSafeArea(
          sliver: snapshot.hasData ? grid : circ,
        );
      },
    );

    final backwardsBuilder = new StreamBuilder<List<ProfileComment>>(
      stream: currentFeed.backwardStream,
      initialData: currentFeed.backwardData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(child: Container());
        }

        return SliverList(
            delegate: new SliverChildBuilderDelegate(
          (context, index) => snapshot.data[index].toWidget(widget.user),
          childCount: snapshot.data?.length ?? 0,
        ));
      },
    );

    return CustomScrollView(
      controller: _controller,
      center: widget._centerKey,
      slivers: <Widget>[backwardsBuilder, forwardBuilder],
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

    if (offset - 50 <= min) {
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
}
