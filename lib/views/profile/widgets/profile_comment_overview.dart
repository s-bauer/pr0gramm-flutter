import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/comment/profile_comment.dart';
import 'package:pr0gramm/api/dtos/user/user.dart';

class ProfileCommentOverview extends StatelessWidget {
  final List<Widget> commentWidgets;

  ProfileCommentOverview({
    Key key,
    @required List<ProfileComment> comments,
    @required User user,
  })  : commentWidgets = comments
            .expand((c) => [
                  c.toWidget(user),
                  Divider(color: Colors.white24, height: 0.1),
                ])
            .toList(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: commentWidgets,
    );
  }
}
