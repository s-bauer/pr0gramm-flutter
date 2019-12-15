import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/entities/feed_details.dart';
import 'package:pr0gramm/services/item_provider.dart';

class Feed {
  final FeedDetails feedDetails;
  final ItemProvider _itemProvider;

  List<Item> _forwardList = [];
  List<Item> _backwardsList = [];

  final StreamController<List<Item>> _forwardStream =
  new StreamController.broadcast();
  final StreamController<List<Item>> _backwardStream =
  new StreamController.broadcast();

  Feed({
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
