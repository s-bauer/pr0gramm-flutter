import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/profile_info.dart';
import 'package:pr0gramm/helpers/time_formatter.dart';
import 'package:pr0gramm/views/widgets/user_mark.dart';

const badgesUrl = "https://pr0gramm.com/media/badges/";

class ProfileInfoBar extends StatelessWidget {
  final ProfileInfo info;

  ProfileInfoBar({Key key, @required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double headerFontSize = 10;

    final userMarkStyle = TextStyle(
      color: info.user.mark.color,
      fontSize: headerFontSize,
    );

    final usernameStyle = TextStyle(
      color: Colors.white70,
      fontSize: headerFontSize * 2,
    );

    final headerStyle = TextStyle(
      color: Colors.white54,
      fontSize: headerFontSize,
    );

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
      Padding(
      padding: EdgeInsets.only(bottom: 15),
      child:
          Row(
            children: <Widget>[
              buildUserInfoText(userMarkStyle, usernameStyle),
              buildBenisColumn(headerStyle, usernameStyle),
            ],
          ),),
          Row(
            children: <Widget>[],
          )
        ],
      ),
    );
  }

  Expanded buildUserInfoText(TextStyle userMarkStyle, TextStyle usernameStyle) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            info.user.mark.name.toUpperCase(),
            style: userMarkStyle,
          ),
          Row(
            children: [
              Text(
                info.user.name,
                style: usernameStyle,
              ),
              UserMarkWidget(
                userMark: info.user.mark,
                radius: 2.5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column buildBenisColumn(TextStyle headerStyle, TextStyle usernameStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          "BENIS",
          style: headerStyle,
          textAlign: TextAlign.right,
        ),
        Text(
          "${info.user.score}",
          style: usernameStyle,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
