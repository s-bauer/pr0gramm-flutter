import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/itemApi.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/entities/enums/promotionStatus.dart';
import 'package:pr0gramm/services/feedProvider.dart';
import 'package:pr0gramm/services/imageProvider.dart' as imgProv;
import 'package:pr0gramm/views/widgets/postPage.dart';

class FeedInherited extends InheritedWidget {
  final FeedProvider feedProvider;

  FeedInherited({
    Key key,
    @required this.feedProvider,
    @required Widget child,
  })  : assert(feedProvider != null),
        assert(child != null),
        super(key: key, child: child);

  static FeedInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FeedInherited>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class OverviewView extends StatefulWidget {
  final _centerKey = UniqueKey();

  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  final imgProv.ImageProvider _imageProvider = imgProv.ImageProvider();
  final ScrollController _controller = new ScrollController();

  List<Item> _currentItems = new List();
  FeedProvider feedProvider;

  final StreamController<List<Item>> _forwardStream =
      new StreamController.broadcast();

  final StreamController<List<Item>> _backwardStream =
      new StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    if (feedProvider == null)
      feedProvider = FeedInherited.of(context).feedProvider;

    final forwardBuilder = new StreamBuilder<List<Item>>(
      key: widget._centerKey,
      stream: _forwardStream.stream,
      builder: (context, snapshot) {
        List<Widget> childWidgets = [];
        if (snapshot.hasData) {
          childWidgets = snapshot.data.map((i) => buildItem(context, i)).toList();
        }

        final grid = SliverGrid(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          delegate: new SliverChildListDelegate(childWidgets),
        );

        final circ = SliverFillViewport(delegate: SliverChildListDelegate([
          Center(child: CircularProgressIndicator()),
        ]));

        return SliverSafeArea(
          sliver: snapshot.hasData ? grid : circ,
        );
      },
    );

    final backwardsBuilder = new StreamBuilder<List<Item>>(
      stream: _backwardStream.stream,
      builder: (context, snapshot) {
        List<Widget> childWidgets;
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(child: Container());
        } else {
          childWidgets = snapshot.data.map((i) => buildItem(context, i)).toList();
        }

        return SliverGrid(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          delegate: new SliverChildListDelegate(childWidgets),
        );
      },
    );

    return CustomScrollView(
      controller: _controller,
      center: widget._centerKey,
      slivers: <Widget>[
        backwardsBuilder,
        forwardBuilder
      ],
    );

  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onScroll);

    final itemApi = new ItemApi();
    final config = new GetItemsConfiguration(
      promoted: PromotionStatus.promoted,
      flags: Flags.guest,
    );

    itemApi.getItems(config).then((val) {
      print("adding data");
      _currentItems = val.items;
      _forwardStream.add(_currentItems);
    });

//    Future.delayed(Duration(seconds: 15)).then((_) {
//      itemApi.getItems(config).then((val) {
//        print("adding data");
//        _currentItems = val.items;
//        _backwardStream.add(_currentItems);
//      });
//    });
  }

  void _onScroll() {
    final max = _controller.position.maxScrollExtent;
    final min = _controller.position.minScrollExtent;
    final offset = _controller.offset;

//    if(offset - 50 <= min) {
//      final itemApi = new ItemApi();
//      final config = new GetItemsConfiguration(
//        promoted: PromotionStatus.promoted,
//        flags: Flags.guest,
//      );
//
//      itemApi.getItems(config).then((val) {
//        print("adding data (scroll)");
//        _currentItems.addAll(val.items);
//        _backwardStream.add(_currentItems);
//      });
//    }

    if (offset + 50 >= max) {
      final itemApi = new ItemApi();
      final config = new GetItemsConfiguration(
        promoted: PromotionStatus.promoted,
        flags: Flags.guest,
      );

      itemApi.getItems(config).then((val) {
        print("adding data (scroll)");
        _currentItems.addAll(val.items);
        _forwardStream.add(_currentItems);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _forwardStream.close();
    _backwardStream.close();
    super.dispose();
  }

  Widget buildItem(BuildContext context, Item item) {
    return GestureDetector(
      child: new FutureBuilder(
        future: _imageProvider.getThumb(item),
        builder: (context, snap) {
          return snap.hasData ? Image.memory(snap.data) : new Container();
        },
      ),
      onTap: () {},
    );
  }

  Widget buildItemByIndex(BuildContext context, int index) {
    print("BuildItem $index");
    return FutureBuilder<Item>(
      future: feedProvider.getItem(index),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return GestureDetector(
            child: new FutureBuilder(
              future: _imageProvider.getThumb(snapshot.data),
              builder: (context, snap) {
                return snap.hasData ? Image.memory(snap.data) : new Container();
              },
            ),
            onTap: () => onThumbTap(index),
          );

        return Container();
      },
    );
  }

  void onThumbTap(int index) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => PostPage(
          index: index,
          feedProvider: feedProvider,
        ),
      ),
    );
  }
}
