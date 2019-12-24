import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const TextStyle titleTextStyle = TextStyle(
  fontSize: 8,
);

class ProfileTabBar extends StatelessWidget {
  final int uploadCount;
  final int commentCount;
  final int tagCount;
  final void Function() showUploadsHandler;
  final void Function() showCommentsHandler;

  ProfileTabBar({
    Key key,
    this.uploadCount,
    this.commentCount,
    this.tagCount,
    this.showUploadsHandler,
    this.showCommentsHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: showUploadsHandler,
          child: ProfileTabButton(
            title: "UPLOADS",
            count: uploadCount,
          ),
        ),
        GestureDetector(
          onTap: showCommentsHandler,
          child: ProfileTabButton(
            title: "COMMENTS",
            count: commentCount,
          ),
        ),
        ProfileTabButton(
          title: "TAGS",
          count: tagCount,
        ),
      ],
    );
  }
}

class ProfileTabButton extends StatelessWidget {
  final String title;
  final int count;

  ProfileTabButton({Key key, this.title, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              title,
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Text(
              "$count",
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
