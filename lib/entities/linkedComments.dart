import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/itemInfoResponse.dart';
import 'package:pr0gramm/views/widgets/postComment.dart';

class LinkedComment {
  final Comment comment;
  final LinkedComment parent;

  List<LinkedComment> children;

  LinkedComment.root(this.comment, List<Comment> allComments)
      : parent = null {
    children = getChildren(allComments);
  }

  LinkedComment.child(this.comment, List<Comment> allComments, this.parent) {
    children = getChildren(allComments);
  }

  List<LinkedComment> getChildren(List<Comment> allComments) {
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
