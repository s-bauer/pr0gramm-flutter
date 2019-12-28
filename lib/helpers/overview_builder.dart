import 'package:flutter/cupertino.dart';
import 'package:pr0gramm/entities/enums/feed_type.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/entities/enums/promotion_status.dart';
import 'package:pr0gramm/entities/feed.dart';
import 'package:pr0gramm/entities/feed_details.dart';
import 'package:pr0gramm/entities/search_arguments.dart';
import 'package:pr0gramm/views/overview_grid.dart';
import 'package:pr0gramm/views/overview_view.dart';

class OverviewBuilder {
  static OverviewBuilder instance = OverviewBuilder._();

  OverviewBuilder._();

  Widget buildByType(FeedType type) {
    final feedDetails = new FeedDetails.byFeedType(type);
    return buildByDetails(feedDetails, type);
  }

  Widget buildByDetails(FeedDetails details, [FeedType feedType]) {
    final feed = new Feed(feedDetails: details, feedType: feedType);
    return FeedInherited(
      feed: feed,
      child: OverviewView(),
    );
  }

  Widget buildByRoute(BuildContext context) {
    final SearchArguments arguments = ModalRoute.of(context).settings.arguments;

    final feedDetails = new FeedDetails(
      flags: Flags.sfw,
      promoted: arguments.baseType == FeedType.TOP
          ? PromotionStatus.promoted
          : PromotionStatus.none,
      tags: arguments.searchString,
      name: arguments.searchString,
    );

    return buildByDetails(feedDetails);
  }
}
