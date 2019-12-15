import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/postInfo.dart';
import 'package:pr0gramm/services/timeFormatter.dart';
import 'package:pr0gramm/views/widgets/userMark.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/itemApi.dart';
import '../../../data/sharedPrefKeys.dart';
import '../../../entities/enums/vote.dart';
import '../../../widgets/inherited.dart';

const authorTextStyle = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  letterSpacing: 1,
);

const postTimeTextStyle = const TextStyle(
  fontSize: 8,
  color: Colors.white70,
);

class PostButtons extends StatelessWidget {
  final PostInfo info;

  const PostButtons({Key key, this.info}) : super(key: key);
  onVote(Vote vote, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(SharedPrefKeys.MeToken)) {
      final meToken = prefs.getString(SharedPrefKeys.MeToken);
      final nonce = (json.decode(Uri.decodeFull(meToken))["id"] as String)
          .substring(0, 16);
      ItemApi().vote(info.item.id, vote, nonce);
    }
  }

  @override
  Widget build(BuildContext context) {
    var loggedIn = GlobalInherited.of(context).isLoggedIn;
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          color: Colors.white,
          onPressed: loggedIn ? () => onVote(Vote.up, context) : null,
          disabledColor: Colors.white30,
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.remove_circle_outline),
          onPressed: loggedIn ? () => onVote(Vote.down, context) : null,
          disabledColor: Colors.white30,
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.favorite_border),
          onPressed: loggedIn ? () => onVote(Vote.favorite, context) : null,
          disabledColor: Colors.white30,
        ),
        Container(
          height: 30.0,
          width: 1.0,
          color: Colors.white30,
          margin: const EdgeInsets.only(left: 10.0, right: 20.0),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    info.item.user,
                    style: authorTextStyle,
                  ),
                  UserMarkWidget(
                    userMark: info.item.mark,
                    radius: 2.5,
                  )
                ],
              ),
              Text(
                formatTime(info.item.created * 1000),
                style: postTimeTextStyle,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        )
      ],
    );
  }
}
