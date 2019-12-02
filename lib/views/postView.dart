
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/views/widgets/imagePost.dart';
import 'package:pr0gramm/views/widgets/videoPost.dart';

class PostView extends StatefulWidget {
  final Item item;

  PostView({Key key, this.item}) : super(key: key);

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return widget.item.image.endsWith(".mp4")
          ? VideoPost(item: widget.item)
          : ImagePost(item: widget.item);
  }
}