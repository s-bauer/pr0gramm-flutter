import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/dtos/itemInfoResponse.dart';
import 'package:pr0gramm/api/itemApi.dart';
import 'package:pr0gramm/services/itemProvider.dart';
import 'package:pr0gramm/views/widgets/imagePost.dart';
import 'package:pr0gramm/views/widgets/postComment.dart';
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

class LinkedComment {
  Comment comment;
  LinkedComment parent;
  int depth;
  List<LinkedComment> comments = new List();

  LinkedComment(List<Comment> commentList,
      [int index, this.depth, this.parent]) {
    var i = 0;
    var id = 0;
    if (index != null) {
      this.comment = commentList[index];
      id = this.comment.id;
    }
    if (this.depth == null) {
      this.depth = 0;
    }

    commentList.forEach((comment) {
      if (comment.parent == id) {
        this.comments.add(new LinkedComment(commentList, i, depth + 1, this));
      }
      i++;
    });
  }
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
            future: _itemProvider.getItem(index).then((item) async =>
                {'item': item, 'info': await ItemApi().getItemInfo(item.id)}),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ItemInfoResponse info = snapshot.data['info'];
                var sortedLinkedComments = [];
                void sortComments([List<LinkedComment> comments]) {
                  if (comments == null) {
                    comments = LinkedComment(info.comments).comments;
                  }
                  comments.sort((a,b) => a.comment.created.compareTo(b.comment.created));
                  comments.forEach((comment) {
                    sortedLinkedComments.add(comment);
                    if (comment.comments.length > 0) {
                      sortComments(comment.comments);
                    }
                  });
                }
                sortComments();

                return ListView(
                  children: <Widget>[
                    DetailView(item: snapshot.data['item']),
                    Column(
                      children: sortedLinkedComments.map((comment) {
                        return new PostComment(
                          comment: comment.comment,
                          depth: comment.depth,
                        );
                      }).toList(growable: true),
                    )
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
