import 'package:flutter/material.dart';
import 'package:pr0gramm/api/itemApi.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/entities/postInfo.dart';
import 'package:pr0gramm/services/feedProvider.dart';
import 'package:pr0gramm/views/post/widgets/post_buttons.dart';
import 'package:pr0gramm/views/post/widgets/post_comments.dart';
import 'package:pr0gramm/views/post/widgets/post_tags.dart';
import 'package:pr0gramm/views/postView.dart';

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
              PostButtons(info: snapshot.data),
              PostTags(info: snapshot.data),
              PostComments(info: snapshot.data)
            ],
          ),
        );
      },
    );
  }
}
