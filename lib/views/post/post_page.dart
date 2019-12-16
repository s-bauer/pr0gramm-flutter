import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/item/item_info.dart';
import 'package:pr0gramm/api/item_api.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/entities/feed.dart';
import 'package:pr0gramm/entities/post_info.dart';
import 'package:pr0gramm/views/post/post_view.dart';
import 'package:pr0gramm/views/post/widgets/item_detail.dart';
import 'package:pr0gramm/views/post/widgets/post_buttons.dart';
import 'package:pr0gramm/views/post/widgets/post_comments.dart';
import 'package:pr0gramm/views/post/widgets/post_tags.dart';

class PostPage extends StatelessWidget {
  final Item item;
  final Feed feed;
  final int index;

  const PostPage({Key key, this.item, this.feed, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final future = ItemApi().getItemInfo(item.id).then((info) {
      return PostInfo(info: info, item: item);
    });

    return FutureBuilder<PostInfo>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PostView(item: snapshot.data.item),
              ItemDetail(item: snapshot.data.item),
              PostTags(info: snapshot.data),
              PostComments(info: snapshot.data)
            ],
          ),
        );
      },
    );
  }
}
