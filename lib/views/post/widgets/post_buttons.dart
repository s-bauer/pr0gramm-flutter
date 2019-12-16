import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/entities/post_info.dart';
import 'package:pr0gramm/helpers/time_formatter.dart';
import 'package:pr0gramm/services/vote_service.dart';
import 'package:pr0gramm/views/widgets/user_mark.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

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

class PostButtons extends StatefulWidget {
  final PostInfo info;

  PostButtons({Key key, this.info}) : super(key: key);

  @override
  _PostButtonsState createState() => _PostButtonsState();
}

class _PostButtonsState extends State<PostButtons> {
  final VoteService _voteService = VoteService.instance;
  Vote currentVote;

  Future voteItem(Vote vote) async {
    if (vote == currentVote) {
      if (vote == Vote.favorite) {
        vote = Vote.up;
      } else {
        vote = Vote.none;
      }
    } else if(vote == Vote.up && currentVote == Vote.favorite) {
      vote = Vote.none;
    }

    try {
      await _voteService.voteItem(widget.info.item, vote);
      setState(() {
        currentVote = vote;
      });
    } on Exception catch (e) {
      print(e);
      // ignore for now
    }
  }

  @override
  void initState() {
    _voteService.getVoteOfItem(widget.info.item).then((vote) {
      setState(() {
        currentVote = vote;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = GlobalInherited.of(context).isLoggedIn;
    final votedColor = new Color(0xffee4d2e);
    final enabledColor = Colors.white60;
    final disabledColor = Colors.white30;
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          color: currentVote == Vote.up || currentVote == Vote.favorite
              ? votedColor
              : enabledColor,
          onPressed: loggedIn ? () => voteItem(Vote.up) : null,
          disabledColor: disabledColor,
        ),
        IconButton(
          color: currentVote == Vote.down ? Colors.white : enabledColor,
          icon: Icon(Icons.remove_circle_outline),
          onPressed: loggedIn ? () => voteItem(Vote.down) : null,
          disabledColor: disabledColor,
        ),
        IconButton(
          color: currentVote == Vote.favorite ? votedColor : enabledColor,
          icon: Icon(
            currentVote == Vote.favorite
                ? Icons.favorite
                : Icons.favorite_border,
          ),
          onPressed: loggedIn ? () => voteItem(Vote.favorite) : null,
          disabledColor: disabledColor,
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
                    widget.info.item.user,
                    style: authorTextStyle,
                  ),
                  UserMarkWidget(
                    userMark: widget.info.item.mark,
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
                      (widget.info.item.up - widget.info.item.down).toString(),
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
                    formatTime(widget.info.item.created * 1000),
                    style: postTimeTextStyle,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
