import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/entities/post_info.dart';
import 'package:pr0gramm/services/vote_service.dart';
import 'package:pr0gramm/views/post/widgets/op_info.dart';
import 'package:pr0gramm/views/post/widgets/post_buttons.dart';
import 'package:pr0gramm/widgets/global_inherited.dart';

class ItemDetail extends StatefulWidget {
  final Item item;

  ItemDetail({Key key, this.item}) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PostButtons(item: widget.item, direction: Axis.horizontal,),
        Container(
          height: 30.0,
          width: 1.0,
          color: Colors.white30,
          margin: const EdgeInsets.only(left: 10.0, right: 20.0),
        ),
        OPInfo(
          item: widget.item,
        ),
      ],
    );
  }
}
