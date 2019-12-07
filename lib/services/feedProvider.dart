import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/entities/postInfo.dart';
import 'package:pr0gramm/services/itemProvider.dart';

class FeedProvider {
  final FeedType feedType;
  final FeedDetails feedDetails;
  final ItemProvider _itemProvider;

  FeedProvider({this.feedType})
      : feedDetails = new FeedDetails(feedType),
        _itemProvider = new ItemProvider(new FeedDetails(feedType));

  Future<Item> getItem(int index) =>
      _itemProvider.getItem(index);

  Future<PostInfo> getItemWithInfo(int index) =>
      _itemProvider.getItemWithInfo(index);
}

class FeedDetails {
  final int flags;
  final bool promoted;
  final String tags;

  FeedDetails._internal({this.flags, this.promoted, this.tags});

  factory FeedDetails(FeedType feedType) {
    switch (feedType) {
      case FeedType.RANDOMTOP:
        final bust = DateTime.now().millisecond / 1000.0;
        return FeedDetails._internal(
            flags: 9, promoted: true, tags: "!-(x:random | x:$bust)");

      case FeedType.RANDOMNEW:
        final bust = DateTime.now().millisecond / 1000.0;
        return FeedDetails._internal(
            flags: 9, promoted: false, tags: "!-(x:random | x:$bust)");

      case FeedType.TOP:
        return FeedDetails._internal(flags: 9, promoted: true, tags: null);

      case FeedType.NEW:
      default:
        return FeedDetails._internal(flags: 9, promoted: false, tags: null);
    }
  }
}

enum FeedType {
  TOP,
  NEW,
  RANDOMTOP,
  RANDOMNEW,
}
