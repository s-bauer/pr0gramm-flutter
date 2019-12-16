import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

typedef VoteChangedHandler = Future<void> Function(Vote vote);

class VoteButtons<T> extends StatefulWidget {
  final Vote initialVote;
  final double size;
  final Axis direction;
  final VoteChangedHandler onVoteChange;
  final bool withFavorite;

  VoteButtons({
    Key key,
    this.initialVote,
    this.withFavorite,
    this.size,
    this.onVoteChange,
  })  : direction = withFavorite ? Axis.horizontal : Axis.vertical,
        super(key: key);

  @override
  _VoteButtonsState createState() => _VoteButtonsState();
}

class _VoteButtonsState extends State<VoteButtons> {
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
      await widget.onVoteChange(vote);
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
    currentVote = widget.initialVote;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = GlobalInherited.of(context).isLoggedIn;
    final votedColor = new Color(0xffee4d2e);

    var upVoteButton = IconButton(
      icon: Icon(Icons.add_circle_outline),
      color: currentVote == Vote.up || currentVote == Vote.favorite
          ? votedColor
          : Colors.white,
      onPressed: loggedIn ? () => voteItem(Vote.up) : null,
      disabledColor: Colors.white30,
    );
    var downVoteButton = IconButton(
      color: currentVote == Vote.down ? votedColor : Colors.white,
      icon: Icon(Icons.remove_circle_outline),
      onPressed: loggedIn ? () => voteItem(Vote.down) : null,
      disabledColor: Colors.white30,
    );
    var favoriteVoteButton = IconButton(
      color: currentVote == Vote.favorite ? votedColor : Colors.white,
      icon: Icon(
        currentVote == Vote.favorite ? Icons.favorite : Icons.favorite_border,
      ),
      onPressed: loggedIn ? () => voteItem(Vote.favorite) : null,
      disabledColor: Colors.white30,
    );

    var voteButtons = <Widget>[
      upVoteButton,
      downVoteButton,
    ];

    if (widget.withFavorite) voteButtons.add(favoriteVoteButton);

    if (widget.size != null) {
      voteButtons = List.from(voteButtons.map((btn) => SizedBox(
            height: widget.size,
            width: widget.size,
            child: btn,
          )));
    }
    return Flex(
      direction: widget.direction,
      children: voteButtons,
    );
  }
}
