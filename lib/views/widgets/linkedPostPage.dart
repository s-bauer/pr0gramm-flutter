import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/commonTypes/linkedStuff/linkedComments.dart';
import 'package:pr0gramm/entities/commonTypes/linkedStuff/linkedPostInfo.dart';
import 'package:pr0gramm/entities/postInfo.dart';
import 'package:pr0gramm/services/linkedPostInfoProvider.dart';
import 'package:pr0gramm/views/postView.dart';
import 'package:pr0gramm/views/widgets/postPage.dart';

class LinkedPostPage extends StatefulWidget {
  final int initialItemId;

  LinkedPostPage({Key key, this.initialItemId}) : super(key: key);

  @override
  _LinkedPostPageState createState() {
    return _LinkedPostPageState();
  }
}

class _LinkedPostPageState extends State<LinkedPostPage> {
  @override
  void initState() {
    super.initState();
  }

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = LinkedPostInfoProvider(context);
    var future =
        provider.getLinkedPostInfo(initialItemId: widget.initialItemId);
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text("Top"),
      ),
      body: FutureBuilder<LinkedPostInfo>(
          future: future,
          builder: (context, linkedPostInfoAsync) {
            if (!linkedPostInfoAsync.hasData)
              return Center(child: CircularProgressIndicator());
            var linkedPost = linkedPostInfoAsync.data;
            linkedPost.makeCurrent();
            var postInfo = linkedPost.toPostInfo();
            void next() {
              if(linkedPost.next == null) return;
              setState(() {
                linkedPost = linkedPost.next..makeCurrent();
                postInfo = linkedPost.toPostInfo();
              });
            }

            void prev() {
              if(linkedPost.prev == null) return;
              setState(() {
                linkedPost = linkedPost.prev..makeCurrent();
                postInfo = linkedPost.toPostInfo();
              });
            }
            // TODO: fix swiping
            return FutureBuilder<PostInfo>(
                future: postInfo,
                builder: (context, info) {
                  if (!info.hasData)
                    return Center(child: CircularProgressIndicator());

                  var comments = linkComments(info.data);
                  return GestureDetector(
                    onPanUpdate: (details) {
                      if (details.delta.dx > 20) {
                        prev();
                      } else if (details.delta.dx < -20) {
                        next();
                      }
                    },
                    child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          future = provider.getLinkedPostInfo(
                              initialItemId: widget.initialItemId);
                        });
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            PostView(item: info.data.item),
                            PostButtons(info: info.data),
                            buildTags(context, info.data),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 20.0, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    comments.map((c) => c.build()).toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}