import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/helpers/time_formatter.dart';
import 'package:pr0gramm/views/widgets/user_mark.dart';

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


class OPInfo extends StatelessWidget {
  final Item item;
  OPInfo({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return         Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                item.user,
                style: authorTextStyle,
              ),
              UserMarkWidget(
                userMark: item.mark,
                radius: 2.5,
              )
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 2),
                child: Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add_circle,
                      size: 8,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: Text(
                  (item.up - item.down).toString(),
                  style: postTimeTextStyle,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 2),
                child: Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.watch_later,
                      size: 8,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              Text(
                formatTime(item.created * 1000),
                style: postTimeTextStyle,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ],
          )
        ],
      ),
    );
  }
}
