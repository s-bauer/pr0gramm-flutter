import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/profile_info.dart';
import 'package:pr0gramm/views/widgets/user_mark.dart';

const userMarkStyle = TextStyle(
  color: Colors.white70,
  fontSize: 16,
);
const usernameStyle = TextStyle(
  color: Colors.white70,
  fontSize: 20,
);

const benisStyle = TextStyle(
  color: Colors.white54,
  fontSize: 16,
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
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      info.user.mark.name,
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
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "BENIS",
                    style: benisStyle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "${info.user.score}",
                    style: usernameStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[],
          )
        ],
      ),
    );
  }
}
