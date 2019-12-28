import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/comment/profile_comment.dart';
import 'package:pr0gramm/api/dtos/user/user.dart';
import 'package:pr0gramm/entities/profile_comment_feed.dart';
import 'package:pr0gramm/views/profile/widgets/profile_comment_view.dart';

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

    return StreamBuilder<List<ProfileComment>>(
      stream: currentFeed.forwardStream,
      initialData: currentFeed.forwardData,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return ProfileCommentView(
              comment: snapshot.data[index],
              user: widget.user,
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final max = _controller.position.maxScrollExtent;
    final offset = _controller.offset;

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
