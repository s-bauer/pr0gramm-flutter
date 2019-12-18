import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/services/vote_service.dart';
import 'package:pr0gramm/views/post/widgets/op_info.dart';
import 'package:pr0gramm/views/post/widgets/post_vote.dart';

class PostInfoBar extends StatelessWidget {
  final Item item;
  final VoteService _voteService = VoteService.instance;

  PostInfoBar({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FutureBuilder<Vote>(
          future: _voteService.getVoteOfItem(item),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return PostVote(
              initialVote: snapshot.data,
              item: item,
            );
          },
        ),
        Container(
          height: 30.0,
          width: 1.0,
          color: Colors.white30,
          margin: const EdgeInsets.only(left: 10.0, right: 20.0),
        ),
        OPInfo(
          item: item,
        ),
      ],
    );
  }
}
