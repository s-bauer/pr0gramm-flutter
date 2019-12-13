import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pr0gramm/entities/commonTypes/linkedStuff/linkedPostInfo.dart';
import 'package:pr0gramm/services/feedProvider.dart';
import 'package:pr0gramm/views/linkedExtention2/LinkedPageView.dart';

class LinkedPostPage extends StatefulWidget {
  final int initialItemId;

  final FeedProvider feedProvider;

  LinkedPostPage({Key key, this.initialItemId, this.feedProvider})
      : super(key: key);

  @override
  _LinkedPostPageState createState() {
    return _LinkedPostPageState();
  }
}

class _LinkedPostPageState extends State<LinkedPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black45,
        appBar: AppBar(
          title: Text("Top"),
        ),
        body: LinkedPageView(
          initial: IntIterator(0),
          itemBuilder: (context, LinkedIterator current) {
            current = current as IntIterator;
            return Text(
              (current as IntIterator).value.toString(),
              style: TextStyle(color: Colors.white),
            );
          },
        ));
  }
}

class IntIterator with LinkedIterator {
  int value;

  IntIterator(this.value);

  @override
  LinkedIterator get next => IntIterator(value + 1);

  @override
  LinkedIterator get prev => IntIterator(value - 1);

  bool operator ==(object) => object is IntIterator && object.value == value;

  int get hashCode => value;

  @override
  String toString() => "value: $value";
}
