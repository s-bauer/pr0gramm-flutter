import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/comment/comment.dart';
import 'package:pr0gramm/api/dtos/comment/item_comment.dart';
import 'package:pr0gramm/views/post/widgets/post_comment.dart';

class LinkedComment {
  final Comment comment;
  final LinkedComment parent;
  final int depth;

  List<LinkedComment> children;

  LinkedComment.root(this.comment, List<Comment> allComments)
      : parent = null,
        depth = 0 {
    children = getChildren(allComments);
  }

  LinkedComment.child(this.comment, List<Comment> allComments, this.parent)
      : depth = parent.depth + 1 {
    children = getChildren(allComments);
  }

  List<LinkedComment> getChildren(List<Comment> allComments) {
    return allComments
        .where((c) => (c as ItemComment).parent == comment.id)
        .map((c) => LinkedComment.child(c, allComments, this))
        .toList()
          ..sort((a, b) => (a.comment as ItemComment)
              .confidence
              .compareTo((b.comment as ItemComment).confidence));
  }

  Widget buildWidget() {
    return PostComment(
      linkedComment: this,
    );
  }
}
