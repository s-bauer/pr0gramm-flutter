import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/services/vote_service.dart';
import 'package:pr0gramm/views/vote/buttons/favorite_vote_button.dart';
import 'package:pr0gramm/views/vote/buttons/up_vote_button.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

import 'buttons/down_vote_button.dart';

class PostVoteButtons extends StatefulWidget {
  final Item item;

  PostVoteButtons({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  _PostVoteButtonsState createState() => _PostVoteButtonsState();
}

class _PostVoteButtonsState extends State<PostVoteButtons> {
  final VoteService _voteService = VoteService.instance;
  VoteAnimationService animationService;

  @override
  void initState() {
    super.initState();

    animationService = VoteAnimationService(
      voteItemHandler: (vote) => _voteService.voteItem(widget.item, vote),
      initialVoteFuture: _voteService.getVoteOfItem(widget.item),
    );
  }

  @override
  Widget build(BuildContext context) {
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

  @override
  void dispose() {
    animationService.dispose();

    super.dispose();
  }
}
