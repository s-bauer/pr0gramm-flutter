import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/enums/feed_type.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/entities/enums/promotion_status.dart';
import 'package:pr0gramm/entities/feed_details.dart';
import 'package:pr0gramm/helpers/overview_builder.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

class ProfileUploadOverview extends StatelessWidget {
  final String user;
  ProfileUploadOverview({Key key, this.user}) : super(key: key);
  final OverviewBuilder _overviewBuilder = OverviewBuilder.instance;

  @override
  Widget build(BuildContext context) {
    final feedDetails = FeedDetails(
      promoted: PromotionStatus.none,
      flags: GlobalInherited.of(context).isLoggedIn ? Flags.sfw : Flags.guest,
      tags: "!u:$user",
      name: "by $user",
    );
    return _overviewBuilder.buildByDetails(
        feedDetails,
        GlobalInherited.of(context).isLoggedIn
            ? FeedType.NEW
            : FeedType.PUBLICNEW);
  }
}
