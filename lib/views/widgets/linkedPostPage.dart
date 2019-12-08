import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/commonTypes/linkedStuff/linkedComments.dart';
import 'package:pr0gramm/entities/commonTypes/linkedStuff/linkedPostInfo.dart';
import 'package:pr0gramm/entities/postInfo.dart';
import 'package:pr0gramm/services/linkedPostInfoProvider.dart';
import 'package:pr0gramm/views/widgets/linkedPageView.dart';

class LinkedPostPage extends StatefulWidget {
  final int initialItemId;

  LinkedPostPage({Key key, this.initialItemId}) : super(key: key);

  @override
  _LinkedPostPageState createState() {
    return _LinkedPostPageState();
  }
}

class _LinkedPostPageState extends State<LinkedPostPage> {
  PageController _controller;
  LinkedPostInfoProvider provider;
  var preloadFuture;

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
    curPage?.dispose();
    super.dispose();
  }

  var startIndex = 0;
  var toShowFuture;
  var first = true;
  ValueNotifier<int> curPage = ValueNotifier<int>(-1);

  @override
  Widget build(BuildContext context) {
    _controller = PageController(initialPage: startIndex, keepPage: false);
    provider = LinkedPostInfoProvider(context);
    toShowFuture =
        provider.getLinkedPostInfo(initialItemId: widget.initialItemId);

    return Scaffold(
        backgroundColor: Colors.black45,
        appBar: AppBar(
          title: Text("Top"),
        ),
        body: FutureBuilder<LinkedPostInfo>(
            future: toShowFuture,
            builder: (context, initialLinkedPostAsync) {
              if (!initialLinkedPostAsync.hasData)
                return Center(child: CircularProgressIndicator());
              void onChange(index) {
                var diff = startIndex - index;
                var walkNext = startIndex < index;
                var toShow = initialLinkedPostAsync.data.walk(
                    walkNext ? WalkDirection.next : WalkDirection.prev, diff);
                print("index $index assigned to ${toShow.item.user}");
                provider.setCurrent(toShow.item.id);
                if (toShow.prev != null && curPage.value == 0) {
                  startIndex += 1;
                  print(
                      "${toShow.item.user} has prev extending and correcting one more prev if existing");
                  _controller.jumpToPage(curPage.value + 1);
                }
              }

              int findChildIndexCallback(Key key) {
                var index = 0;
                var str = key.toString();
                var cur = LinkedPostInfoProvider
                    .idMap[int.parse(str.substring(3, str.length - 3))];
                while (cur.prev != null) {
                  cur = cur.prev;
                  index++;
                }
                return index;
              }

              // curPage.addListener(() => onChange(curPage.value));
              return LinkedPageView<IntIterator>.builder(
                iterator: IntIterator(0),
                buildChild: (IntIterator data) {
                  return Text("$data",
                      style: TextStyle(
                        color: RandomColor.getColor(),
                      ));
                },
              );

/*                  itemBuilder: (context, index) {
                    var diff = startIndex - index;
                    var walkNext = startIndex < index;
                    diff = diff.abs();
                    var toShow = initialLinkedPostAsync.data.walk(
                        walkNext ? WalkDirection.next : WalkDirection.prev,
                        diff);
                    print("build: ${toShow.item.user}");

                    return FutureBuilder<PostInfo>(
                        key: Key("${toShow.item.id}"),
                        future: toShow.toPostInfo(),
                        builder: (context, info) {
                          if (!info.hasData)
                            return Center(child: CircularProgressIndicator());

                          var comments = linkComments(info.data);
                          return RefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                toShowFuture = provider.getLinkedPostInfo(
                                    initialItemId: info.data.item.id);
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: comments
                                          .map((c) => c.build())
                                          .toList(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }*/
            }));
  }
}
