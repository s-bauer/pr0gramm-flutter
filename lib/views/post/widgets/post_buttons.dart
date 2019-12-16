import 'package:flare_flutter/flare_actor.dart';
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
  String _upAnimationName = "enabled";
  String _downAnimationName = "enabled";
  String _favoriteAnimationName = "enabled";

  Future voteItem(Vote vote) async {
    if (vote == currentVote) {
      if (vote == Vote.favorite) {
        vote = Vote.up;
      } else {
        vote = Vote.none;
      }
    } else if (vote == Vote.up && currentVote == Vote.favorite) {
      vote = Vote.none;
    }

    try {
      await _voteService.voteItem(widget.info.item, vote);
      setState(() {
        if(vote == Vote.down) {
          _downAnimationName = "vote";
          if(currentVote == Vote.favorite){
            _upAnimationName = "clear";
            _favoriteAnimationName = "clear";
          }
          if(currentVote == Vote.up){
            _upAnimationName = "clear";
          }
        }
        if(vote == Vote.none) {
          if(currentVote == Vote.favorite){
            _upAnimationName = "clear";
            _favoriteAnimationName = "clear";
          }
          if(currentVote == Vote.up){
            _upAnimationName = "clear";
          }
          if(currentVote == Vote.down){
            _downAnimationName = "clear";
          }
        }
        if(vote == Vote.up) {
          _upAnimationName = "vote";
          if(currentVote == Vote.favorite){
            _upAnimationName = "voted";
            _favoriteAnimationName = "clear";
          }
          if(currentVote == Vote.down){
            _downAnimationName = "clear";
          }
        }
        if(vote == Vote.favorite) {
          _favoriteAnimationName = "vote";
          if(currentVote != Vote.up){
            _upAnimationName = "vote";
          } else {
            _upAnimationName = "voted";
          }
          if(currentVote == Vote.down){
            _downAnimationName = "clear";
          }
        }
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
        if (vote == Vote.up || vote == Vote.favorite)
          _upAnimationName = "voted";
        if (vote == Vote.down) _downAnimationName = "voted";
        if (vote == Vote.favorite) _favoriteAnimationName = "voted";
        currentVote = vote;
        init = false;
      });
    });
    super.initState();
  }

  bool init = true;

  @override
  Widget build(BuildContext context) {
    final loggedIn = GlobalInherited.of(context).isLoggedIn;
    if (!loggedIn) {
      _upAnimationName =
          _downAnimationName = _favoriteAnimationName = "disabled";
    }
    if (init) return Center(child: CircularProgressIndicator());
    print("up: $_upAnimationName");
    print("down: $_downAnimationName");
    print("fav: $_favoriteAnimationName");
    return Row(
      children: [
        Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: GestureDetector(
              onTap: () => voteItem(Vote.up),
              child: FlareActor(
                'assets/vote_add.flr',
                animation: _upAnimationName,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: GestureDetector(
              onTap: () => voteItem(Vote.down),
              child: FlareActor(
                'assets/vote_remove.flr',
                animation: _downAnimationName,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: GestureDetector(
              onTap: () => voteItem(Vote.favorite),
              child: FlareActor(
                'assets/vote_favorite.flr',
                animation: _favoriteAnimationName,
                fit: BoxFit.fitWidth,
              ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Row(
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
                      "${widget.info.item.up - widget.info.item.down} Benis",
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
