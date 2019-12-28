import 'dart:async';

import 'package:pr0gramm/api/dtos/comment/profile_comment.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/services/profile_comment_provider.dart';
import 'package:retry/retry.dart';

class ProfileCommentFeed {
  final ProfileCommentProvider _itemProvider;
  final retryConfig =
      new RetryOptions(maxAttempts: 7, maxDelay: Duration(seconds: 5));
  final StreamController<List<ProfileComment>> _forwardStream =
      new StreamController.broadcast();

  List<ProfileComment> _forwardList = [];
  bool _isBusy = false;

  get forwardStream => _forwardStream.stream;

  get forwardData => _forwardList;

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

  Future loadForward() async {
    if (_isBusy) return;

    try {
      _isBusy = true;

      final nextBatch = await retryConfig
          .retry(() => _itemProvider.getNextBatch());

      if (nextBatch != null) {
        _forwardList.addAll(nextBatch.comments);
        _forwardStream.add(_forwardList);
      }
    } finally {
      _isBusy = false;
    }
  }

  Future refresh() async {
    if (_isBusy)
      return;

    _itemProvider.reset();
    await loadForward();
  }

  void dispose() {
    _forwardStream.close();
  }
}
