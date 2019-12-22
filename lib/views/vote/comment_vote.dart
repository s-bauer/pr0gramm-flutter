import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/comment/comment.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/services/vote_service.dart';
import 'package:pr0gramm/views/vote/buttons/up_vote_button.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

import 'buttons/down_vote_button.dart';

class CommentVote extends StatelessWidget {
  final Comment comment;
  final Future<Vote> initialVoteFuture;
  final VoteService _voteService = VoteService.instance;

  CommentVote({
    Key key,
    @required this.comment,
    this.initialVoteFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VoteAnimationService animationService = VoteAnimationService(
      voteItemHandler: (vote) => _voteService.voteComment(comment, vote),
      initialVoteFuture: initialVoteFuture,
    );
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
