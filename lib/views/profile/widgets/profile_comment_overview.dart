import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/comment/profile_comment.dart';
import 'package:pr0gramm/api/dtos/user/user.dart';

class ProfileCommentOverview extends StatelessWidget {
  final SplayTreeMap<int, Widget> commentWidgets = new SplayTreeMap();

  ProfileCommentOverview({
    Key key,
    @required ProfileComment newestComment,
    @required User user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*
    *  .expand((c) => [
                  c.toWidget(user),
                  Divider(color: Colors.white24, height: 0.1),
                ])
                * */
    return ListView(
      children: commentWidgets,
    );
  }
}
