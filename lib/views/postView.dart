import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/services/itemProvider.dart';
import 'package:pr0gramm/views/widgets/imagePost.dart';
import 'package:pr0gramm/views/widgets/videoPost.dart';
import 'package:video_player/video_player.dart';

class DetailView extends StatefulWidget {
  final Item item;

  DetailView({Key key, this.item}) : super(key: key);

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {
    return widget.item.image.endsWith(".mp4")
          ? VideoPost(item: widget.item)
          : ImagePost(item: widget.item);
  }
}

class PostPage extends StatefulWidget {
  const PostPage({Key key, this.index}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();

  final int index;
}

class _PostPageState extends State<PostPage> {
  final ItemProvider _itemProvider = ItemProvider();
  PageController _controller;

  @override
  Widget build(BuildContext context) {
      _controller = PageController(initialPage: widget.index, keepPage: false);

    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text("Top"),
      ),
      body: PageView.builder(
        controller: _controller,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: _itemProvider.getItem(index),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return DetailView(item: snapshot.data);

              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }

}
