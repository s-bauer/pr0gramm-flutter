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
            child: Row(
              children: <Widget>[
                buildUserInfoText(userMarkStyle, usernameStyle),
                buildBenisColumn(headerStyle, usernameStyle),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildBadges(headerStyle),
              buildActions(headerStyle),
            ],
          )
        ],
      ),
    );
  }

  Column buildActions(TextStyle headerStyle) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          "ACTIONS",
          style: headerStyle,
          textAlign: TextAlign.right,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.reply, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.email, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
      ],
    );
  }

  Expanded buildBadges(TextStyle headerStyle) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            "Registriert ${formatTime(info.user.registered * 1000)}"
                .toUpperCase(),
            style: headerStyle,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: info.badges
                  .map((b) => Padding(
                        child: Image.network(
                          badgesUrl + b.image,
                          height: 24,
                          width: 24,
                        ),
                        padding: EdgeInsets.all(12),
                      ))
                  .toList(),
            ),
          ),
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
