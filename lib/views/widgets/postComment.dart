import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/linkedComments.dart';

import 'dart:math';

import 'package:pr0gramm/services/timeFormatter.dart';

class PostComment extends StatefulWidget {
  final LinkedComment linkedComment;

  PostComment({Key key, this.linkedComment}) : super(key: key);

  @override
  _PostCommentState createState() => _PostCommentState();
}

class _PostCommentState extends State<PostComment> {
  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.only(
      top: 5,
      left: 10.0,
    );

    const textStyle = const TextStyle(
      fontSize: 12,
      color: Colors.white,
    );


    const authorTextStyle = const TextStyle(
      fontSize: 10,
      color: Colors.white70,
    );

    const pointTextStyle = const TextStyle(
      fontSize: 8,
      color: Colors.white70,
    );

    final points = widget.linkedComment.comment.up - widget.linkedComment.comment.down;


    final commentsColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(
                painter: CommentHierarchyPainter(
                  hasChildren: widget.linkedComment.children.isNotEmpty,
                  hasSiblings: widget.linkedComment.parent != null && widget.linkedComment.parent.children.length > 1,
                  isLastInList: widget.linkedComment.parent != null && widget.linkedComment.parent.children.last == widget.linkedComment,
                  isRoot: widget.linkedComment.parent == null,
                  depth: widget.linkedComment.depth,
                  comment: widget.linkedComment,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    CircularButton(text: "+"),
                    SizedBox(height: 3),
                    CircularButton(text: "-"),
                  ],
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.linkedComment.comment.content,
                        style: textStyle,
                        textAlign: TextAlign.left,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      SizedBox(height: 3),
                      Text(
                        widget.linkedComment.comment.name,
                        style: authorTextStyle,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        "$points Punkte  ${formatTime(widget.linkedComment.comment.created * 1000)}",
                        style: pointTextStyle,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      Divider(color: Colors.white24, height: 0.1),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    if (widget.linkedComment.children.length > 0) {
      final children = widget.linkedComment.children
          .map((c) => PostComment(linkedComment: c))
          .toList();

      commentsColumn.children.addAll(children);
    }

    return Padding(
      padding: padding,
      child: commentsColumn,
    );
  }
}

class CommentHierarchyPainter extends CustomPainter {
  final bool isLastInList;
  final bool isRoot;
  final bool hasChildren;
  final bool hasSiblings;
  final int depth;
  final LinkedComment comment;

  final Paint _paint = Paint()..color = Colors.grey;

  CommentHierarchyPainter(
      {this.isLastInList, this.isRoot, this.hasChildren, this.depth, this.hasSiblings, this.comment});

  @override
  void paint(Canvas canvas, Size size) {
    if (hasChildren) {
      canvas.drawLine(Offset(7.5, 38), Offset(7.5, size.height), _paint);
    }

    if (!isRoot) {
      if (hasChildren || hasSiblings) {
        final height = isLastInList ? 33.0 : size.height;
        canvas.drawLine(Offset(-2.5, -5), Offset(-2.5, height), _paint);
      } else {
        canvas.drawLine(Offset(-2.5, -5), Offset(-2.5, 38), _paint);
      }
    }

    LinkedComment current = comment.parent;
    int i = 1;
    while(current != null && current.parent != null) {
      if(current.parent.children.last != current)
        canvas.drawLine(Offset(-2.5 - 10 * i, -5), Offset(-2.5 - 10 * i, size.height), _paint);

      current = current.parent;
      i++;
    }


    //for (int i = 1; i < depth; i++) {
    //  canvas.drawLine(Offset(-2.5 - 10 * i, -5),
    //      Offset(-2.5 - 10 * i, size.height), _paint);
    //}

    if (hasChildren && !isRoot) {
      canvas.drawLine(Offset(-2.5, 33), Offset(7.5, 38), _paint);
    }

    return;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircularButton extends StatelessWidget {
  final String text;

  const CircularButton({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(color: Colors.grey, height: 1.0),
        ),
      ),
    );
  }
}
