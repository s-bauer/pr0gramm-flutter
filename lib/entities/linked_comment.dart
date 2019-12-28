import 'package:pr0gramm/api/dtos/comment/item_comment.dart';

class LinkedComment {
  final ItemComment comment;
  final LinkedComment parent;
  final int depth;

  List<LinkedComment> children;

  LinkedComment.root(this.comment, List<ItemComment> allComments)
      : parent = null,
        depth = 0 {
    children = getChildren(allComments);
  }

  LinkedComment.child(this.comment, List<ItemComment> allComments, this.parent)
      : depth = parent.depth + 1 {
    children = getChildren(allComments);
  }

  List<LinkedComment> getChildren(List<ItemComment> allComments) {
    final filteredComments = allComments
        .where((c) => c.parent == comment.id)
        .map((c) => LinkedComment.child(c, allComments, this))
        .toList();

    filteredComments
        .sort((a, b) => a.comment.confidence.compareTo(b.comment.confidence));

    return filteredComments;
  }
}
