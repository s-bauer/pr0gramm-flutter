import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/profile_info.dart';
import 'package:pr0gramm/api/dtos/user/profile_badge.dart';
import 'package:pr0gramm/helpers/time_formatter.dart';
import 'package:pr0gramm/views/widgets/user_mark.dart';

const badgesUrl = "https://pr0gramm.com/media/badges/";

final double _headerFontSize = 10;

final _usernameStyle = TextStyle(
  color: Colors.white70,
  fontSize: _headerFontSize * 2,
);

final _headerStyle = TextStyle(
  color: Colors.white54,
  fontSize: _headerFontSize,
);


class ProfileInfoBar extends StatelessWidget {
  final ProfileInfo info;

  ProfileInfoBar({Key key, @required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Row(
              children: [_userInfoText, _benisColumn],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_badges, _profileActions],
          )
        ],
      ),
    );
  }

  Column get _profileActions {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          "ACTIONS",
          style: _headerStyle,
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

  Expanded get _badges {
    final friendlyDate = formatTime(info.user.registered * 1000);
    final registeredText = "Registriert $friendlyDate".toUpperCase();

    final badgeWidgets = info.badges
        .map(buildBadge)
        .toList();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(registeredText, style: headerStyle),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: badgeWidgets,
            ),
          ),
        ],
      ),
    );
  }

  Expanded get _userInfoText {
    final userMarkStyle = TextStyle(
      color: info.user.mark.color,
      fontSize: _headerFontSize,
    );

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
                style: _usernameStyle,
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

  Column get _benisColumn {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          "BENIS",
          style: _headerStyle,
          textAlign: TextAlign.right,
        ),
        Text(
          "${info.user.score}",
          style: _usernameStyle,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  Widget buildBadge(ProfileBadge badge) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Image.network(
        badgesUrl + badge.image,
        height: 24,
        width: 24,
      ),
    );
  }
}
