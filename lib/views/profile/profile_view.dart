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
  TabController _tabController;

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
        final showFavBtn = info.likesArePublic ||
            info.user.id == GlobalInherited.of(context).profile.user.id;

        final tabs = buildTabs(info, showFavBtn);
        _tabController = new TabController(length: tabs.length, vsync: this);

        return MyScaffold(
          name: "von ${info.user.name}",
          body: Column(
            children: <Widget>[
              ProfileInfoBar(info: info),
              ProfileTabBar(
                showUploadsHandler: onShowUploads,
                showFavoritesHandler: showFavBtn ? onShowFavorites : null,
                showCommentsHandler: () => onShowComments(showFavBtn ? 2 : 1),
                commentCount: info.commentCount,
                uploadCount: info.uploadCount,
                tagCount: info.tagCount,
                favoriteCount: info.likeCount,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: tabs,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> buildTabs(ProfileInfo info, bool showFavBtn) {
    final tabs = new List<Widget>();
    if (info.uploadCount > 0) {
      final uploadTab = buildUploadFeedInherited(
        info: info,
        child: OverviewGrid(),
      );
      tabs.add(uploadTab);
    }

    if (showFavBtn) {
      final favTab = buildFavoritesFeedInherited(
        info: info,
        child: OverviewGrid(),
      );
      tabs.add(favTab);
    }

    if (info.commentCount > 0) {
      final commentTab = buildCommentFeedInherited(
        info: info,
        child: ProfileCommentOverview(user: info.user),
      );
      tabs.add(commentTab);
    }

    return tabs;
  }

  FeedInherited buildFavoritesFeedInherited({ProfileInfo info, Widget child}) {
    final user = info.user.name;

    final feedDetails = new FeedDetails(
      promoted: PromotionStatus.none,
      flags: GlobalInherited.of(context).isLoggedIn ? Flags.sfw : Flags.guest,
      likes: user,
      self: true,
    );

    final favoriteFeed = new Feed(
      feedDetails: feedDetails,
      feedType: GlobalInherited.of(context).isLoggedIn
          ? FeedType.NEW
          : FeedType.PUBLICNEW,
    );

    return FeedInherited(
      key: PageStorageKey("profile_${info.user.id}_favs"),
      feed: favoriteFeed,
      child: child,
    );
  }

  FeedInherited buildUploadFeedInherited({ProfileInfo info, Widget child}) {
    final user = info.user.name;

    final feedDetails = new FeedDetails(
      promoted: PromotionStatus.none,
      flags: GlobalInherited.of(context).isLoggedIn ? Flags.sfw : Flags.guest,
      tags: "!u:$user",
    );

    final uploadFeed = new Feed(
      feedDetails: feedDetails,
      feedType: GlobalInherited.of(context).isLoggedIn
          ? FeedType.NEW
          : FeedType.PUBLICNEW,
    );

    return FeedInherited(
      key: PageStorageKey("profile_${info.user.id}_uploads"),
      feed: uploadFeed,
      child: child,
    );
  }

  CommentFeedInherited buildCommentFeedInherited({
    ProfileInfo info,
    Widget child,
  }) {
    final firstComment =
        info.comments.reduce((a, b) => a.created < b.created ? b : a);

    final commentFeed = new ProfileCommentFeed(
      user: info.user.name,
      firstComment: firstComment,
      flags: Flags.sfw,
    );

    return CommentFeedInherited(
      key: PageStorageKey("profile_${info.user.id}_comments"),
      feed: commentFeed,
      child: child,
    );
  }

  void onShowUploads() {
    _tabController.index = 0;
  }

  void onShowComments(int index) {
    _tabController.index = index;
  }

  void onShowFavorites() {
    _tabController.index = 1;
  }
}
