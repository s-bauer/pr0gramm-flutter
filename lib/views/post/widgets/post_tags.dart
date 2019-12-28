import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/tag/tag.dart';
import 'package:pr0gramm/entities/post_info.dart';
import 'package:pr0gramm/entities/search_arguments.dart';
import 'package:pr0gramm/views/overview_grid.dart';

class PostTags extends StatelessWidget {
  final PostInfo info;

  const PostTags({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tags = info.info.tags
      ..sort((a, b) => b.confidence.compareTo(a.confidence));

    var tagWidgets = tags.map((t) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: GestureDetector(
          onTap: () => openTag(context, t),
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

  void openTag(BuildContext context, Tag t) {
    final searchArgs = new SearchArguments(
      searchString: t.tag,
      baseType: FeedInherited.of(context).feed.feedType,
    );

    Navigator.pushNamed(context, "/search", arguments: searchArgs);
  }
}
