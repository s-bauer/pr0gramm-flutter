

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pr0gramm/entities/commonTypes/linkedStuff/linkedPostInfo.dart';

class RandomColor {
  static Random random = new Random();

  static Color getColor() {
    return Color.fromARGB(
        255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }
}

class LinkedPageView<T> extends StatefulWidget {
  final LinkedIterator<T> iterator;
  final buildChild;

  const LinkedPageView.builder({this.iterator, this.buildChild});

  @override
  _LinkedPageViewState createState() => _LinkedPageViewState();
}

class _LinkedPageViewState extends State<LinkedPageView> {
  PageController _pageController;
  Slots<IntIterator> slots;
  ValueNotifier<int> onPageChanged;

  Widget build(BuildContext context) {
    var pageView = PageView.custom(
      controller: _pageController,
      childrenDelegate: SliverChildBuilderDelegate((c, i) {
        return widget.buildChild(slots.getByIndex(i));
      },
          findChildIndexCallback: (key) => null,
          addAutomaticKeepAlives: false,
          childCount: 5),
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      onPageChange();
    });
    return pageView;
  }

  void _onScroll() {
    if (_pageController.hasClients &&
        _pageController.page.toInt() == _pageController.page &&
        onPageChanged?.value != _pageController.page.toInt()) {
      setState(() {
        onPageChanged?.value = _pageController.page.toInt();
      });
    }
  }

  @override
  void initState() {
    onPageChanged = new ValueNotifier(2);
    slots = Slots(widget.iterator);
    _pageController =
    PageController(initialPage: slots.curIndex, keepPage: false)
      ..addListener(_onScroll);
    super.initState();
  }

  var first = true;
  var pageView;

  onPageChange() {
    if (slots.curIndex == onPageChanged?.value)
      return;
    if (slots.prevSlot != null && slots.curIndex > onPageChanged?.value) {
      slots.movePrev();
      _pageController.jumpToPage(onPageChanged.value);
    } else {
      slots.moveNext();
      _pageController.jumpToPage(onPageChanged.value);
    }
  }
}

class IntIterator extends LinkedIterator<IntIterator> {
  final int value;
  static int lowerEnd = -6;
  static int upperEnd = 6;

  @override
  IntIterator get next =>
      (value + 1) >= upperEnd ? null : IntIterator(value + 1);

  @override
  IntIterator get prev =>
      (value - 1) <= lowerEnd ? null : IntIterator(value - 1);

  IntIterator(this.value);

  @override
  String toString() => value.toString();
}

class Slots<T> {
  LinkedIterator<T> _cur;

  LinkedIterator<T> get cPrevSlot => prevSlot?.prev;

  LinkedIterator<T> get prevSlot => curSlot?.prev;

  LinkedIterator<T> get curSlot => _cur;

  LinkedIterator<T> get nextSlot => curSlot?.next;

  LinkedIterator<T> get cNextSlot => nextSlot?.next;

  int get curIndex => [cPrevSlot, prevSlot].where((i) => i != null).length;

  int get count => this.toList().where((i) => i != null).length;

  Slots(this._cur);

  void moveNext() {
    _cur = _cur.next;
  }

  void movePrev() {
    _cur = _cur.prev;
  }

  List<LinkedIterator<T>> toList() => [
    cPrevSlot,
    prevSlot,
    curSlot,
    nextSlot,
    cNextSlot,
  ].toList();

  LinkedIterator<T> getByIndex(int index) {
    return this.toList().elementAt(index);
  }
}

