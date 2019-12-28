import 'package:pr0gramm/entities/enums/feed_type.dart';

class SearchArguments {
  final String searchString;
  final FeedType baseType;

  SearchArguments({this.searchString, this.baseType});
}
