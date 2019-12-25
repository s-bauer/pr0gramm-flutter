import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/profile_info.dart';
import 'package:pr0gramm/entities/enums/feed_type.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/entities/enums/promotion_status.dart';
import 'package:pr0gramm/entities/feed.dart';
import 'package:pr0gramm/entities/feed_details.dart';
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

class _ProfileViewState extends State<ProfileView> {
  bool showUploads = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileInfo>(
      future: widget.infoFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        var info = snapshot.data;
        final user = info.user.name;
        final feedDetails = FeedDetails(
          promoted: PromotionStatus.none,
          flags:
              GlobalInherited.of(context).isLoggedIn ? Flags.sfw : Flags.guest,
          tags: "!u:$user",
          name: "by $user",
        );
        final feed = new Feed(
          feedDetails: feedDetails,
          feedType: GlobalInherited.of(context).isLoggedIn
              ? FeedType.NEW
              : FeedType.PUBLICNEW,
        );

        return FeedInherited(
          feed: feed,
          child: MyScaffold(
            body: Column(
              children: <Widget>[
                ProfileInfoBar(
                  info: info,
                ),
                ProfileTabBar(
                  showUploadsHandler: onShowUploads,
                  showCommentsHandler: onShowComments,
                  commentCount: info.commentCount,
                  uploadCount: info.uploadCount,
                  tagCount: info.tagCount,
                ),
                Expanded(
                  child: showUploads
                      ? OverviewGrid()
                      : ProfileCommentOverview(
                          comments: snapshot.data.comments,
                          user: info.user,
                        ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void onShowUploads() {
    if (!showUploads) {
      setState(() {
        showUploads = true;
      });
    }
  }

  void onShowComments() {
    if (showUploads)
      setState(() {
        showUploads = false;
      });
  }
}
