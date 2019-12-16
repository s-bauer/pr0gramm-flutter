import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/services/vote_service.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

class PostButtons extends StatefulWidget {
  final Item item;
  final Axis direction;


  PostButtons({Key key, this.item, this.direction}) : super(key: key);

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
    } else if (vote == Vote.up && currentVote == Vote.favorite) {
      vote = Vote.none;
    }

    try {
      await _voteService.voteItem(widget.item, vote);
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
    _voteService.getVoteOfItem(widget.item).then((vote) {
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

    return Flex(
      direction: widget.direction,
      children: [
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          color: currentVote == Vote.up || currentVote == Vote.favorite
              ? votedColor
              : Colors.white,
          onPressed: loggedIn ? () => voteItem(Vote.up) : null,
          disabledColor: Colors.white30,
        ),
        IconButton(
          color: currentVote == Vote.down ? votedColor : Colors.white,
          icon: Icon(Icons.remove_circle_outline),
          onPressed: loggedIn ? () => voteItem(Vote.down) : null,
          disabledColor: Colors.white30,
        ),
        IconButton(
          color: currentVote == Vote.favorite ? votedColor : Colors.white,
          icon: Icon(
            currentVote == Vote.favorite
                ? Icons.favorite
                : Icons.favorite_border,
          ),
          onPressed: loggedIn ? () => voteItem(Vote.favorite) : null,
          disabledColor: Colors.white30,
        ),
      ],
    );
  }
}
