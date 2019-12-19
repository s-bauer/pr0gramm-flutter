import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/services/vote_service.dart';
import 'package:pr0gramm/views/vote/down_vote_button.dart';
import 'package:pr0gramm/views/vote/favorite_vote_button.dart';
import 'package:pr0gramm/views/vote/up_vote_button.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

class PostVote extends StatelessWidget {
  final Item item;
  final Future<Vote> initialVoteFuture;
  final VoteService _voteService = VoteService.instance;

  PostVote({
    Key key,
    @required this.item,
    this.initialVoteFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VoteAnimationService animationService = VoteAnimationService(
      voteItemHandler: (vote) => _voteService.voteItem(item, vote),
      initialVoteFuture: initialVoteFuture,
    );
    final isLoggedIn = GlobalInherited.of(context).isLoggedIn;
    return Row(
      children: <Widget>[
        UpVoteButton(
          disabled: !isLoggedIn,
          animationService: animationService,
        ),
        DownVoteButton(
          disabled: !isLoggedIn,
          animationService: animationService,
        ),
        FavoriteVoteButton(
          disabled: !isLoggedIn,
          animationService: animationService,
        ),
      ],
    );
  }
}
