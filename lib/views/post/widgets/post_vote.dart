import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/entities/enums/vote_button_type.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/services/vote_service.dart';
import 'package:pr0gramm/views/post/widgets/vote_button.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

class PostVote extends StatelessWidget {
  final Item item;
  final Vote initialVote;
  final VoteService _voteService = VoteService.instance;

  PostVote({
    Key key,
    this.item,
    this.initialVote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VoteAnimationService animationService = VoteAnimationService(
      voteItemHandler: (vote) => _voteService.voteItem(item, vote),
      initialVote: initialVote,
    );
    final isLoggedIn = GlobalInherited.of(context).isLoggedIn;
    return Row(
      children: <Widget>[
        VoteButton(
          type: VoteButtonType.up,
          disabled: !isLoggedIn,
          animationService: animationService,
        ),
        VoteButton(
          type: VoteButtonType.down,
          disabled: !isLoggedIn,
          animationService: animationService,
        ),
        VoteButton(
          type: VoteButtonType.favorite,
          disabled: !isLoggedIn,
          animationService: animationService,
        ),
      ],
    );
  }
}
