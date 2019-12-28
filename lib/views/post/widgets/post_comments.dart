import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/linked_comment.dart';
import 'package:pr0gramm/entities/post_info.dart';
import 'package:pr0gramm/views/widgets/post_comment.dart';

class PostComments extends StatelessWidget {
  final PostInfo info;

  const PostComments({Key key, this.info}) : super(key: key);

  List<LinkedComment> linkComments() {
    final plainComments = info.info.comments;
    final linkedComments = plainComments
        .where((c) => c.parent == 0)
        .map((c) => LinkedComment.root(c, plainComments))
        .toList();

    return linkedComments
      ..sort((a, b) => b.comment.confidence.compareTo(a.comment.confidence));
  }

  @override
  Widget build(BuildContext context) {
    var comments = linkComments();

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 20.0, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: comments.map((c) => PostComment(linkedComment: c)).toList(),
      ),
    );
  }
}
