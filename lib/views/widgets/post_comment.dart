import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:pr0gramm/entities/linked_comment.dart';
import 'package:pr0gramm/helpers/time_formatter.dart';
import 'package:pr0gramm/services/vote_service.dart';
import 'package:pr0gramm/views/widgets/user_mark.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../entities/enums/vote.dart';

class PostComment extends StatefulWidget {
  final LinkedComment linkedComment;

  PostComment({Key key, this.linkedComment}) : super(key: key);

  @override
  _PostCommentState createState() => _PostCommentState();
}

class _PostCommentState extends State<PostComment> {
  Vote currentVote;
  final VoteService _voteService = VoteService.instance;

  String _upAnimationName = "enabled";
  String _downAnimationName = "enabled";

  Future voteComment(Vote vote) async {
    if (vote == currentVote) {
      vote = Vote.none;
    }

    try {
      await _voteService.voteComment(widget.linkedComment.comment, vote);
      setState(() {
        if (vote == Vote.down) {
          if (currentVote == Vote.none)
            _downAnimationName = "voteAll";
          else
            _downAnimationName = "vote";
          _upAnimationName = "unfocus";

          if (currentVote == Vote.up) {
            _upAnimationName = "clear";
          }
        }
        if (vote == Vote.none) {
          _downAnimationName = "enabled";
          _upAnimationName = "enabled";
          if (currentVote == Vote.up) {
            _upAnimationName = "clearAll";
          }
          if (currentVote == Vote.down) {
            _downAnimationName = "clearAll";
          }
        }
        if (vote == Vote.up) {
          if (currentVote == Vote.none)
            _upAnimationName = "voteAll";
          else
            _upAnimationName = "vote";
          _downAnimationName = "unfocus";

          if (currentVote == Vote.down) {
            _downAnimationName = "clear";
          }
        }
        currentVote = vote;
      });
    } on Exception catch (e) {
      print(e);
      // ignore for now
    }
  }

  @override
  void initState() {
    _voteService.getCommentOfItem(widget.linkedComment.comment).then((vote) {
      setState(() {
        if (vote == Vote.up) {
          _upAnimationName = "voted";
          _downAnimationName = "unfocus";
        }
        if (vote == Vote.down) {
          _downAnimationName = "voted";
          _upAnimationName = "unfocus";
        }
        currentVote = vote;
        init = false;
      });
    });
    super.initState();
  }

  bool init = true;

  @override
  Widget build(BuildContext context) {
    if (init) return Center(child: CircularProgressIndicator());
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

    final points =
        widget.linkedComment.comment.up - widget.linkedComment.comment.down;

    final commentsColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(
                painter: CommentHierarchyPainter(
                  comment: widget.linkedComment,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: GestureDetector(
                          onTap: () => voteComment(Vote.up),
                          child: FlareActor(
                            'assets/vote_add.flr',
                            animation: _upAnimationName,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2, left: 1),
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: GestureDetector(
                          onTap: () => voteComment(Vote.down),
                          child: FlareActor(
                            'assets/vote_remove.flr',
                            animation: _downAnimationName,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5),
                Expanded(
                  child: ConstrainedBox(
                    // needed for the painter because we assume that the comment has min height 38
                    constraints: BoxConstraints(
                      minHeight: 40.0,
                    ),
                    child: Opacity(
                      opacity: currentVote == Vote.down ? 0.4 : 1.0,
                      child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Linkify(
                          onOpen: (link) async {
                            if (await canLaunch(link.url)) {
                              await launch(link.url);
                            }
                          },
                          text: widget.linkedComment.comment.content,
                          style: textStyle,
                          textAlign: TextAlign.left,
                          humanize: true,
                          linkStyle: TextStyle(color: Color(0xFFee4d2e)),
                        ),
                        SizedBox(height: 3),
                        Row(children: [
                          Text(
                            widget.linkedComment.comment.name,
                            style: authorTextStyle,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                          UserMarkWidget(
                            userMark: widget.linkedComment.comment.mark,
                            radius: 2,
                          )
                        ]),
                        Text(
                          "$points Punkte  ${formatTime(widget.linkedComment.comment.created * 1000)}",
                          style: pointTextStyle,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                        Divider(color: Colors.white24, height: 0.1),
                      ],
                    ),),
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

  CommentHierarchyPainter({this.comment})
      : hasChildren = comment.children.isNotEmpty,
        isLastInList = comment.parent?.children?.last == comment,
        isRoot = comment.parent == null,
        depth = comment.depth,
        hasSiblings =
            comment.parent != null && comment.parent.children.length > 1;

  @override
  void paint(Canvas canvas, Size size) {
    double lineXPos = -2.5;
    double indentWidth = 10.0;
    double childLineXPos = indentWidth + lineXPos;
    double connectionHeightDifference = 10;
    double connectionLineStartingY = 27.0;
    double connectionLineEndingY =
        connectionLineStartingY + connectionHeightDifference;

    double connectCommentBeforeCorrection = -5;
    if (hasChildren) {
      canvas.drawLine(Offset(childLineXPos, connectionLineEndingY),
          Offset(childLineXPos, size.height), _paint);
    }

    if (!isRoot) {
      if (hasChildren || hasSiblings) {
        final height = isLastInList ? connectionLineStartingY : size.height;
        canvas.drawLine(Offset(lineXPos, connectCommentBeforeCorrection),
            Offset(lineXPos, height), _paint);
      } else {
        canvas.drawLine(Offset(lineXPos, connectCommentBeforeCorrection),
            Offset(lineXPos, connectionLineEndingY), _paint);
      }
    }

    int i = 1;
    LinkedComment current = comment.parent;
    while (current != null && current.parent != null) {
      if (current.parent.children.last != current) {
        canvas.drawLine(
            Offset(lineXPos - indentWidth * i, connectCommentBeforeCorrection),
            Offset(lineXPos - indentWidth * i, size.height),
            _paint);
      }
      current = current.parent;
      i++;
    }

    if (hasChildren && !isRoot) {
      canvas.drawLine(Offset(lineXPos, connectionLineStartingY),
          Offset(childLineXPos, connectionLineEndingY), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
