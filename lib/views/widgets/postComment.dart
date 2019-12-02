import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/dtos/itemInfoResponse.dart';

class PostComment extends StatefulWidget {
  final Comment comment;
  final int depth;

  PostComment({Key key, this.comment, this.depth}) : super(key: key);

  @override
  _PostCommentState createState() => _PostCommentState();
}

class _PostCommentState extends State<PostComment> {
  @override
  Widget build(BuildContext context) {
    print(widget.depth);
    return Row(children: [
      Flexible(
        child: Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 5.0 * widget.depth.toDouble()),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.comment.content,
                  style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      backgroundColor: Color(0x333333FF)),
                  textAlign: TextAlign.left,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                )
              ]),
        ),
      ),
    ]);
  }
}
