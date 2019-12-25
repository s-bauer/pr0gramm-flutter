import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/comment/profile_comment.dart';
import 'package:pr0gramm/entities/linked_comment.dart';

class ProfileCommentOverview extends StatelessWidget {
  final List<ProfileComment> comments;

  ProfileCommentOverview({
    Key key,
    this.comments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: comments.map((c) => LinkedComment.root(c, []).buildWidget()),
    );
  }
}
