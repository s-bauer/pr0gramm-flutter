import 'dart:math';

import 'package:pr0gramm/api/dtos/comment/profile_comment.dart';
import 'package:pr0gramm/api/dtos/comment/profile_comment_batch.dart';
import 'package:pr0gramm/api/profile_api.dart';
import 'package:pr0gramm/entities/enums/flags.dart';

class ProfileCommentProvider {
  final _profileApi = ProfileApi();
  final String name;
  final ProfileComment firstComment;
  ProfileCommentBatch _newestBatch;
  ProfileCommentBatch _oldestBatch;

  ProfileCommentProvider({this.name, this.firstComment});

  Future<ProfileCommentBatch> getFirstBatch(Flags flags) async {
    final batch = await _profileApi.getProfileCommentBatch(
        name: name, flags: flags, beforeCreated: firstComment.created + 1);
    _newestBatch = batch;
    _oldestBatch = batch;
    return batch;
  }

  Future<ProfileCommentBatch> getOlderBatch(Flags flags) async {
    if (_oldestBatch == null) return await getFirstBatch(flags);

    if (!_oldestBatch.hasOlder) return null;

    return _oldestBatch = await _profileApi.getProfileCommentBatch(
      name: name,
      flags: flags,
      beforeCreated: _oldestBatch.comments.map((c) => c.created).reduce(min),
    );
  }

  Future<ProfileCommentBatch> getNewerBatch(Flags flags) async {
    if (_newestBatch == null) return await getFirstBatch(flags);

    if (!_newestBatch.hasNewer) return null;

    return _newestBatch = await _profileApi.getProfileCommentBatch(
      name: name,
      flags: flags,
      afterCreated: _newestBatch.comments.map((c) => c.created).reduce(max),
    );
  }
}
