import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/commonTypes/comment/itemComment.dart';
import 'package:pr0gramm/views/widgets/postComment.dart';

class LinkedComment {
  final ItemComment comment;
  final LinkedComment parent;
  final int depth;

  List<LinkedComment> children;

  LinkedComment.root(this.comment, List<ItemComment> allComments)
      : parent = null, depth = 0 {
    children = getChildren(allComments);
  }

  LinkedComment.child(this.comment, List<ItemComment> allComments, this.parent)
      : depth = parent.depth + 1{
    children = getChildren(allComments);
  }

  List<LinkedComment> getChildren(List<ItemComment> allComments) {
    return allComments
        .where((c) => c.parent == comment.id)
        .map((c) => LinkedComment.child(c, allComments, this))
        .toList()
        ..sort((a, b) => a.comment.confidence.compareTo(b.comment.confidence));
  }

  Widget build() {
    return PostComment(
      linkedComment: this,
    );
  }
}
