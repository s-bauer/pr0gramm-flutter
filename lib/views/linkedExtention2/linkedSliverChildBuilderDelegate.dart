import 'dart:collection';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pr0gramm/entities/commonTypes/linkedStuff/linkedPostInfo.dart';
import 'package:pr0gramm/views/linkedExtention2/LinkedPageView.dart';

typedef CorrectFn = Function();

class LinkedSliverChildBuilderDelegate extends SliverChildBuilderDelegate {
  final LinkedWidgetBuilder linkedBuilder;
  final LinkedIterator initial;
  CorrectFn correctByOne;
  HashMap<LinkedIterator, Widget> map = new HashMap();
  SplayTreeMap<int, LinkedIterator> indexMap = new SplayTreeMap();

  ViewportOffset position;

  IndexedWidgetBuilder get builder => (BuildContext context, int index) {
        if (map.length == 0) {
          return _build(context, initial, index);
        } else {
          if (indexMap[index] == null) {
            return _appendBuild(context, index);
          } else {
            if (map[indexMap[index]] != null) {
              return map[indexMap[index]];
            } else {
              _build(context, indexMap[index], index);
            }
          }
        }
        return null;
      };

  LinkedSliverChildBuilderDelegate(LinkedWidgetBuilder builder, this.initial)
      : linkedBuilder = builder,
        super((BuildContext context, int index) => null);

  Widget _build(BuildContext context, LinkedIterator cursor, int index) {
    map[cursor] = linkedBuilder(context, cursor);
    indexMap[index] = cursor;
    if (index == 0) {
      indexMap = SplayTreeMap.from(indexMap.map((k, v) => MapEntry(k + 1, v)));
      indexMap.remove(0);
      map.removeWhere((k, _) => k != cursor);
    }
    return map[cursor];
  }

  Widget _appendBuild(BuildContext context, int index) {
    assert(indexMap[index] == null);
    if (indexMap[index - 1] != null) {
      return _build(context, indexMap[index - 1].next, index);
    }
    if (indexMap[index + 1] != null) {
      return _build(context, indexMap[index + 1].prev, index);
    }
    assert(false);
    return null;
  }

  @override
  Widget build(BuildContext context, int index) {
    assert(builder != null);
    if ((childCount != null && index >= childCount)) return null;
    Widget child;
    try {
      child = builder(context, index);
    } catch (exception) {}
    if (child == null) return null;
    final Key key = child.key != null ? _SaltedValueKey(child.key) : null;
    if (addRepaintBoundaries) child = RepaintBoundary(child: child);
    if (addSemanticIndexes) {
      final int semanticIndex = semanticIndexCallback(child, index);
      if (semanticIndex != null)
        child = IndexedSemantics(
            index: semanticIndex + semanticIndexOffset, child: child);
    }
    if (addAutomaticKeepAlives) child = AutomaticKeepAlive(child: child);
    return KeyedSubtree(child: child, key: key);
  }
}

class _SaltedValueKey extends ValueKey<Key> {
  const _SaltedValueKey(Key key)
      : assert(key != null),
        super(key);
}
