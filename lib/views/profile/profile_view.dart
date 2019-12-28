import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/profile_info.dart';
import 'package:pr0gramm/entities/enums/feed_type.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/entities/enums/promotion_status.dart';
import 'package:pr0gramm/entities/feed.dart';
import 'package:pr0gramm/entities/feed_details.dart';
import 'package:pr0gramm/entities/profile_comment_feed.dart';
import 'package:pr0gramm/views/overview_grid.dart';
import 'package:pr0gramm/views/profile/widgets/profile_comment_overview.dart';
import 'package:pr0gramm/views/profile/widgets/profile_info_bar.dart';
import 'package:pr0gramm/views/profile/widgets/profile_tab_bar.dart';
import 'package:pr0gramm/views/widgets/scaffold.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

class ProfileView extends StatefulWidget {
  final Future<ProfileInfo> infoFuture;

  ProfileView({Key key, @required this.infoFuture}) : super(key: key);

  @override
  _ProfileViewState createState() {
    return _ProfileViewState();
  }
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  bool showUploads = true;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileInfo>(
      future: widget.infoFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final info = snapshot.data;
        final mainView = new MyScaffold(
          body: Column(
            children: <Widget>[
              ProfileInfoBar(info: info),
              ProfileTabBar(
                showUploadsHandler: onShowUploads,
                showCommentsHandler: onShowComments,
                commentCount: info.commentCount,
                uploadCount: info.uploadCount,
                tagCount: info.tagCount,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    OverviewGrid(),
                    ProfileCommentOverview(user: info.user)
                  ],
                ),
              ),
            ],
          ),
        );

        return buildFeedInherited(
          info: info,
          child: buildCommentFeedInherited(
            info: info,
            child: mainView,
          ),
        );
      },
    );
  }

  FeedInherited buildFeedInherited({ProfileInfo info, Widget child}) {
    final user = info.user.name;

    final feedDetails = new FeedDetails(
      promoted: PromotionStatus.none,
      flags: GlobalInherited.of(context).isLoggedIn ? Flags.sfw : Flags.guest,
      tags: "!u:$user",
      name: "by $user",
    );

    final uploadFeed = new Feed(
      feedDetails: feedDetails,
      feedType: GlobalInherited.of(context).isLoggedIn
          ? FeedType.NEW
          : FeedType.PUBLICNEW,
    );

    return FeedInherited(
      feed: uploadFeed,
      child: child,
    );
  }

  CommentFeedInherited buildCommentFeedInherited({
    ProfileInfo info,
    Widget child,
  }) {
    final commentFeed = new ProfileCommentFeed(
      user: info.user.name,
      firstComment:
          info.comments.reduce((a, b) => a.created < b.created ? b : a),
      flags: Flags.sfw,
    );

    return CommentFeedInherited(
      feed: commentFeed,
      child: child,
    );
  }

  void onShowUploads() {
    _tabController.index = 0;
  }

  void onShowComments() {
    _tabController.index = 1;
  }
}
