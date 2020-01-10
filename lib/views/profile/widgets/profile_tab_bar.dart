import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const TextStyle titleTextStyle = TextStyle(fontSize: 14, color: Colors.white70);

class ProfileTabBar extends StatelessWidget {
  final int uploadCount;
  final int commentCount;
  final int favoriteCount;
  final int tagCount;
  final VoidCallback showUploadsHandler;
  final VoidCallback showCommentsHandler;
  final VoidCallback showFavoritesHandler;

  ProfileTabBar({
    Key key,
    this.uploadCount,
    this.commentCount,
    this.tagCount,
    this.favoriteCount,
    this.showUploadsHandler,
    this.showCommentsHandler,
    this.showFavoritesHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tabButtons = <Widget>[
      Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: showUploadsHandler,
          child: ProfileTabButton(
            title: "UPLOADS",
            count: uploadCount,
          ),
        ),
      ),
      Container(
        height: 30.0,
        width: 1.0,
        color: Colors.white30,
        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
      ),
      Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: showCommentsHandler,
          child: ProfileTabButton(
            title: "COMMENTS",
            count: commentCount,
          ),
        ),
      ),
      Container(
        height: 30.0,
        width: 1.0,
        color: Colors.white30,
        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
      ),
      Expanded(
        child: ProfileTabButton(
          title: "TAGS",
          count: tagCount,
        ),
      ),
    ];

    if (showFavoritesHandler != null) {
      tabButtons.insert(
        1,
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: showFavoritesHandler,
            child: ProfileTabButton(
              title: "FAVORITES",
              count: favoriteCount,
            ),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white30,
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Flex(
          mainAxisSize: MainAxisSize.max,
          direction: Axis.horizontal,
          children: tabButtons,
        ),
      ),
    );
  }
}

class ProfileTabButton extends StatelessWidget {
  final String title;
  final int count;

  ProfileTabButton({Key key, this.title, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
