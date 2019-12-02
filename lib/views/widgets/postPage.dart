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
class PostButtons extends StatelessWidget {
  final PostInfo info;

  const PostButtons({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          color: Colors.white,
          onPressed: () {},
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () {},
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.favorite_border),
          onPressed: () {},
        ),
        Container(
          height: 30.0,
          width: 1.0,
          color: Colors.white30,
          margin:
          const EdgeInsets.only(left: 10.0, right: 20.0),
        ),
        Text(
          info.item.user,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
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
          var future = _itemProvider.getItemWithInfo(index);

          return FutureBuilder<PostInfo>(
            future: future,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              var comments = linkComments(snapshot.data);

              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    future = _itemProvider.getItemWithInfo(index);
                  });
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      PostView(item: snapshot.data.item),
                      PostButtons(info: snapshot.data),
                      buildTags(context, snapshot.data),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: comments.map((c) => c.build()).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
