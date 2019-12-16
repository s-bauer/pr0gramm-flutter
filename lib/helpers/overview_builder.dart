import 'package:flutter/cupertino.dart';
import 'package:pr0gramm/entities/enums/feed_type.dart';
import 'package:pr0gramm/entities/feed.dart';
import 'package:pr0gramm/entities/feed_details.dart';
import 'package:pr0gramm/views/overview_view.dart';

class OverviewBuilder {
  static OverviewBuilder instance = OverviewBuilder._();
  OverviewBuilder._();

  Widget buildByType(FeedType type) {
    final feedDetails = new FeedDetails(type);
    return buildByDetails(feedDetails);
  }

  Widget buildByDetails(FeedDetails details) {
    final feed = new Feed(feedDetails: details);
    return FeedInherited(
      feed: feed,
      child: OverviewView(),
    );
  }
}