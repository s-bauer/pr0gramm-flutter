import 'dart:math';

import 'package:pr0gramm/api/dtos/comment/profile_comment.dart';
import 'package:pr0gramm/api/dtos/comment/profile_comment_batch.dart';
import 'package:pr0gramm/api/profile_api.dart';
import 'package:pr0gramm/entities/enums/flags.dart';

class ProfileCommentProvider {
  final _profileApi = ProfileApi();
  final String name;
  final Flags flags;
  final ProfileComment firstComment;
  ProfileCommentBatch _oldestBatch;

  ProfileCommentProvider({this.name, this.firstComment, this.flags});

  void reset() {
    _oldestBatch = null;
  }

  Future<ProfileCommentBatch> getNextBatch() async {
    var beforeCreated;

    if (_oldestBatch == null) {
      beforeCreated = firstComment.created + 1;
    } else {
      if (!_oldestBatch.hasOlder)
        return null;

      beforeCreated = _oldestBatch.comments
          .map((c) => c.created)
          .reduce(min);
    }

    return _oldestBatch = await _profileApi.getProfileCommentBatch(
      name: name,
      flags: flags,
      beforeCreated: beforeCreated,
    );
  }
}
