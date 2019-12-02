import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/linkedComments.dart';

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
      bottom: 5,
      left: widget.linkedComment.parent != null ? 10 : 0,
    );

    const textStyle = const TextStyle(
      color: Color(0xFFFFFFFF),
      backgroundColor: Color(0x333333FF),
    );


    final commentWidget = Column(
      children: <Widget>[
        Row(
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
                    style: textStyle,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                  SizedBox(height: 3),
                  Divider(color: Colors.white24, height: 0.1),
                ],
              ),
            ),
          ],
        ),
      ],
    );

    if(widget.linkedComment.children.length > 0) {
      final children = widget.linkedComment.children
          .map((c) => PostComment(linkedComment: c))
          .toList();

      commentWidget.children.addAll(children);
    }


    return Padding(
      padding: padding,
      child: commentWidget,
    );
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
