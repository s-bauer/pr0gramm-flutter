import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/comment/comment.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/services/vote_service.dart';
import 'package:pr0gramm/views/vote/buttons/up_vote_button.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

import 'buttons/down_vote_button.dart';

class CommentVoteButtons extends StatefulWidget {
  final Comment comment;

  CommentVoteButtons({
    Key key,
    @required this.comment,
  }) : super(key: key);

  @override
  _CommentVoteButtonsState createState() => _CommentVoteButtonsState();
}

class _CommentVoteButtonsState extends State<CommentVoteButtons> {
  final VoteService _voteService = VoteService.instance;
  VoteAnimationService animationService;


  @override
  void initState() {
    super.initState();
    animationService = VoteAnimationService(
      voteItemHandler: (vote) => _voteService.voteComment(widget.comment, vote),
      initialVoteFuture: _voteService.getVoteOfComment(widget.comment),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = GlobalInherited.of(context).isLoggedIn;
    return Column(
      children: <Widget>[
        UpVoteButton(
          disabled: !isLoggedIn,
          animationService: animationService,
          width: 15,
          height: 15,
        ),
        DownVoteButton(
          disabled: !isLoggedIn,
          animationService: animationService,
          width: 15,
          height: 15,
        ),
      ],
    );
  }
}
