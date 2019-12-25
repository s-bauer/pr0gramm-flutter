import 'dart:async';

import 'package:pr0gramm/api/dtos/comment/profile_comment.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/services/profile_comment_provider.dart';
import 'package:retry/retry.dart';

class ProfileCommentFeed {
  final ProfileCommentProvider _itemProvider;

  final retryConfig =
      new RetryOptions(maxAttempts: 7, maxDelay: Duration(seconds: 5));

  List<ProfileComment> _forwardList = [];
  List<ProfileComment> _backwardsList = [];

  bool _isBusy = false;

  final StreamController<List<ProfileComment>> _forwardStream =
      new StreamController.broadcast();
  final StreamController<List<ProfileComment>> _backwardStream =
      new StreamController.broadcast();

  ProfileCommentFeed({
    String user,
    Flags flags,
    ProfileComment firstComment,
  }) : _itemProvider = ProfileCommentProvider(
          name: user,
          firstComment: firstComment,
          flags: flags,
        ) {
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

      final nextBatch =
          await retryConfig.retry(() => _itemProvider.getOlderBatch());

      if (nextBatch != null) {
        _forwardList.addAll(nextBatch.comments);
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

      final prevBatch =
          await retryConfig.retry(() => _itemProvider.getNewerBatch());

      if (prevBatch != null) {
        _backwardsList.addAll(prevBatch.comments);
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

      final firstBatch =
          await retryConfig.retry(() => _itemProvider.getFirstBatch());

      _backwardsList = null;
      _forwardList = firstBatch.comments;

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
