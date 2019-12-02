
import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/linkedComments.dart';
import 'package:pr0gramm/entities/postInfo.dart';
import 'package:pr0gramm/services/itemProvider.dart';

import '../postView.dart';

class PostPage extends StatefulWidget {
  final int index;

  const PostPage({Key key, this.index}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}



class _PostPageState extends State<PostPage> {
  final ItemProvider _itemProvider = ItemProvider();
  PageController _controller;

  List<LinkedComment> linkComments(PostInfo postInfo) {
    final plainComments = postInfo.info.comments;
    return plainComments
      .where((c) => c.parent == 0)
      .map((c) => LinkedComment.root(c, plainComments))
      .toList()
      ..sort((a, b) => b.comment.confidence.compareTo(a.comment.confidence));
  }

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
          return FutureBuilder<PostInfo>(
            future: _itemProvider.getItemWithInfo(widget.index),
            builder: (context, snapshot) {
              if(!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              var comments = linkComments(snapshot.data);
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    PostView(item: snapshot.data.item),
                    Column(children: comments.map((c) => c.build()).toList())
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
