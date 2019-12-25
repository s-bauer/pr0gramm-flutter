import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/comment/profile_comment.dart';
import 'package:pr0gramm/api/dtos/user/user.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/entities/profile_comment_feed.dart';

/*class ProfileCommentOverview extends StatelessWidget {
  final SplayTreeMap<int, Widget> commentWidgets = new SplayTreeMap();

  ProfileCommentOverview({
    Key key,
    @required ProfileComment newestComment,
    @required User user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    */ /*
    *  .expand((c) => [
                  c.toWidget(user),
                  Divider(color: Colors.white24, height: 0.1),
                ])
                * */ /*
    return ListView(
      children: commentWidgets,
    );
  }
}*/
class ProfileCommentOverview extends StatefulWidget {
  final _centerKey = UniqueKey();

  final User user;
  final ProfileComment firstComment;

  ProfileCommentOverview({Key key, this.user, this.firstComment})
      : super(key: key);

  @override
  _ProfileCommentOverviewState createState() => _ProfileCommentOverviewState();
}

class _ProfileCommentOverviewState extends State<ProfileCommentOverview> {
  final ScrollController _controller = new ScrollController();
  ProfileCommentFeed currentFeed;

  @override
  Widget build(BuildContext context) {
    if (currentFeed == null) {
      currentFeed = new ProfileCommentFeed(
          user: widget.user.name,
          firstComment: widget.firstComment,
          flags: Flags.sfw);
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

    return RefreshIndicator(
      onRefresh: currentFeed.refresh,
      child: CustomScrollView(
        controller: _controller,
        center: widget._centerKey,
        slivers: <Widget>[backwardsBuilder, forwardBuilder],
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
