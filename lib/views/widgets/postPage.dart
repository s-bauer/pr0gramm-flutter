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
          ..sort(
              (a, b) => b.comment.confidence.compareTo(a.comment.confidence));
  }

  Widget buildTags(BuildContext context, PostInfo info) {
    var tags = info.info.tags
      ..sort((a, b) => b.confidence.compareTo(a.confidence));

    var tagWidgets = tags.map((t) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Text(
              t.tag,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: tagWidgets),
      ),
    );
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
            future: _itemProvider.getItemWithInfo(index),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              var comments = linkComments(snapshot.data);

              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    PostView(item: snapshot.data.item),
                    buildTags(context, snapshot.data),
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
