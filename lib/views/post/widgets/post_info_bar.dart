import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/entities/post_info.dart';
import 'package:pr0gramm/services/vote_service.dart';
import 'package:pr0gramm/views/post/widgets/op_info.dart';
import 'package:pr0gramm/views/post/widgets/vote_buttons.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

class PostInfoBar extends StatelessWidget {
  final Item item;

  PostInfoBar({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoteButtons(item: item, withFavorite: true,),
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
