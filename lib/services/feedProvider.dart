import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/entities/enums/promotionStatus.dart';
import 'package:pr0gramm/services/itemProvider.dart';

class Feed {
  final FeedType feedType;
  final FeedDetails feedDetails;
  final ItemProvider _itemProvider;

  List<Item> _forwardList = [];
  List<Item> _backwardsList = [];

  final StreamController<List<Item>> _forwardStream =
      new StreamController.broadcast();
  final StreamController<List<Item>> _backwardStream =
      new StreamController.broadcast();

  Feed({
    @required this.feedType,
    @required this.feedDetails,
  }) : _itemProvider = new ItemProvider(feedDetails)
  {
    refresh();
  }

  get forwardStream => _forwardStream.stream;
  get backwardStream => _backwardStream.stream;
  get forwardData => _forwardList;
  get backwardData => _backwardsList;

  Future loadForward() async {
    final nextBatch = await _itemProvider.getOlderBatch();
    if (nextBatch != null) {
      _forwardList.addAll(nextBatch.items);
      _forwardStream.add(_forwardList);
    }
  }

  Future loadBackwards() async {
    final prevBatch = await _itemProvider.getNewerBatch();
    if (prevBatch != null) {
      _backwardsList.addAll(prevBatch.items);
      _backwardStream.add(_backwardsList);
    }
  }

  Future refresh() async {
    final firstBatch = await _itemProvider.getFirstBatch();

    _backwardsList = null;
    _forwardList = firstBatch.items;

    _forwardStream.add(_forwardList);
    _backwardStream.add(_backwardsList);
  }

  void dispose() {
    _forwardStream.close();
    _backwardStream.close();
  }

  @deprecated
  getItemWithInfo(int index) {
    return _forwardList[index];
  }
}

class FeedProvider {
  final FeedType feedType;
  final FeedDetails feedDetails;

  FeedProvider({this.feedType})
      : feedDetails = new FeedDetails(feedType);

  Feed getFeed() {
    return Feed(
      feedType: feedType,
      feedDetails: feedDetails,
    );
  }
}

class FeedDetails {
  final Flags flags;
  final PromotionStatus promoted;
  final String tags;

  FeedDetails._internal({this.flags, this.promoted, this.tags});

  factory FeedDetails(FeedType feedType) {
    switch (feedType) {
      case FeedType.RANDOMTOP:
        final bust = DateTime.now().millisecond / 1000.0;
        return FeedDetails._internal(
            flags: Flags.sfw,
            promoted: PromotionStatus.promoted,
            tags: "!-(x:random | x:$bust)");

      case FeedType.RANDOMNEW:
        final bust = DateTime.now().millisecond / 1000.0;
        return FeedDetails._internal(
            flags: Flags.sfw,
            promoted: PromotionStatus.none,
            tags: "!-(x:random | x:$bust)");

      case FeedType.PUBLICTOP:
        return FeedDetails._internal(
            flags: Flags.guest, promoted: PromotionStatus.promoted, tags: null);

      case FeedType.PUBLICNEW:
        return FeedDetails._internal(
            flags: Flags.guest, promoted: PromotionStatus.none, tags: null);

      case FeedType.TOP:
        return FeedDetails._internal(
            flags: Flags.sfw, promoted: PromotionStatus.promoted, tags: null);

      case FeedType.NEW:
      default:
        return FeedDetails._internal(
            flags: Flags.sfw, promoted: PromotionStatus.none, tags: null);
    }
  }
}

enum FeedType {
  PUBLICTOP,
  PUBLICNEW,
  TOP,
  NEW,
  RANDOMTOP,
  RANDOMNEW,
}
