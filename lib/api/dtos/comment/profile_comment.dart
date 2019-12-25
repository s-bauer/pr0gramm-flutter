import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:pr0gramm/api/dtos/comment/comment.dart';
import 'package:pr0gramm/api/dtos/user/user.dart';
import 'package:pr0gramm/helpers/time_formatter.dart';
import 'package:pr0gramm/views/widgets/user_mark.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileComment extends Comment {
  int itemId;
  String thumb;

  ProfileComment({
    this.itemId,
    this.thumb,
    String content,
    int id,
    int created,
    int up,
    int down,
  }) : super(content: content, id: id, created: created, up: up, down: down);

  ProfileComment.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.itemId = json['itemId'];
    this.thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['itemId'] = this.itemId;
    data['thumb'] = this.thumb;
    return data;
  }

  Widget toWidget(User user) {
    return ProfileCommentView(comment: this, user: user);
  }
}

class ProfileCommentView extends StatelessWidget {
  final User user;

  final ProfileComment _comment;

  ProfileCommentView({Key key, ProfileComment comment, this.user})
      : _comment = comment,
        super(key: key);

  @override
  Widget build(BuildContext context) {
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
    final points = _comment.up - _comment.down;
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ConstrainedBox(
            // needed for the painter because we assume that the comment has min height 38
            constraints: BoxConstraints(
              maxHeight: 40.0,
              maxWidth: 40.0,
            ),
            child:
                Image.network("https://thumb.pr0gramm.com/${_comment.thumb}"),
          ),
          SizedBox(width: 5),
          Expanded(
            child: ConstrainedBox(
              // needed for the painter because we assume that the comment has min height 38
              constraints: BoxConstraints(
                minHeight: 40.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Linkify(
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                        await launch(link.url);
                      }
                    },
                    text: _comment.content,
                    style: textStyle,
                    textAlign: TextAlign.left,
                    humanize: true,
                    linkStyle: TextStyle(color: Color(0xFFee4d2e)),
                  ),
                  SizedBox(height: 3),
                  Row(children: [
                    Text(
                      user.name,
                      style: authorTextStyle,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                    UserMarkWidget(
                      userMark: user.mark,
                      radius: 2,
                    )
                  ]),
                  Text(
                    "$points Punkte  ${formatTime(_comment.created * 1000)}",
                    style: pointTextStyle,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
