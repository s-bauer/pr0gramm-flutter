import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/entities/feed_details.dart';
import 'package:pr0gramm/services/item_provider.dart';
import 'package:retry/retry.dart';

import 'enums/feed_type.dart';

class Feed {
  FeedDetails feedDetails;
  final FeedType feedType;
  final ItemProvider _itemProvider = new ItemProvider();
  final retryConfig =
      new RetryOptions(maxAttempts: 7, maxDelay: Duration(seconds: 5));

  List<Item> _forwardList = [];
  List<Item> _backwardsList = [];

  bool _isBusy = false;

  final StreamController<List<Item>> _forwardStream =
      new StreamController.broadcast();
  final StreamController<List<Item>> _backwardStream =
      new StreamController.broadcast();

  Feed({
    @required this.feedDetails,
    @required this.feedType,
  }) {
    refresh();
  }

  get forwardStream => _forwardStream.stream;

  get backwardStream => _backwardStream.stream;

  get forwardData => _forwardList;

  get backwardData => _backwardsList;

  Future loadForward() async {
    if (_isBusy) return;

    try {
      _isBusy = true;

      final nextBatch = await retryConfig
          .retry(() => _itemProvider.getOlderBatch(feedDetails));

      if (nextBatch != null) {
        _forwardList.addAll(nextBatch.items);
        _forwardStream.add(_forwardList);
      }
    } finally {
      _isBusy = false;
    }
  }

  Future loadBackwards() async {
    if (_isBusy) return;

    try {
      _isBusy = true;

      final prevBatch = await retryConfig
          .retry(() => _itemProvider.getNewerBatch(feedDetails));

      if (prevBatch != null) {
        _backwardsList.addAll(prevBatch.items);
        _backwardStream.add(_backwardsList);
      }
    } finally {
      _isBusy = false;
    }
  }

  Future refresh() async {
    if (_isBusy) return;

    try {
      _isBusy = true;

      feedDetails = feedDetails.refresh();

      final firstBatch = await retryConfig
          .retry(() => _itemProvider.getFirstBatch(feedDetails));

      _backwardsList = null;
      _forwardList = firstBatch.items;

      _forwardStream.add(_forwardList);
      _backwardStream.add(_backwardsList);
    } finally {
      _isBusy = false;
    }
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
