import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/views/widgets/image_post.dart';
import 'package:pr0gramm/views/widgets/video_post.dart';

class PostView extends StatefulWidget {
  final Item item;

  PostView({Key key, this.item}) : super(key: key);

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final aspectRatio = widget.item.width / widget.item.height;
    final containerHeight = deviceSize.width / aspectRatio;

    final innerWidget = widget.item.image.endsWith(".mp4")
        ? VideoPost(item: widget.item)
        : ImagePost(item: widget.item);

    return Container(
      width: deviceSize.width,
      height: containerHeight,
      child: innerWidget,
    );
  }
}

