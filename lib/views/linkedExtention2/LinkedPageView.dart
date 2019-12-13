import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pr0gramm/entities/commonTypes/linkedStuff/linkedPostInfo.dart';
import 'package:pr0gramm/views/linkedExtention2/linkedSliverChildBuilderDelegate.dart';

class LinkedPageView extends StatefulWidget {
  final LinkedSliverChildBuilderDelegate childrenDelegate;
  final ValueChanged<int> onPageChanged;
  final LinkedIterator cursor;

  var controller = PageController();

  LinkedPageView({
    Key key,
    @required LinkedIterator initial,
    @required LinkedWidgetBuilder itemBuilder,
    this.onPageChanged,
  })  : childrenDelegate = LinkedSliverChildBuilderDelegate(itemBuilder, initial),
        cursor = initial,
        super(key: key);

  @override
  _LinkedPageViewState createState() {
    return _LinkedPageViewState();
  }
}
class _LinkedPageViewState extends State<LinkedPageView> {
  int _lastReportedPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final AxisDirection axisDirection =
    textDirectionToAxisDirection(textDirection);
    final ScrollPhysics physics = _ForceImplicitScrollPhysics(
      allowImplicitScrolling: false,
    ).applyTo(PageScrollPhysics());

    var controller = widget.controller;
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.depth == 0 &&
            widget.onPageChanged != null &&
            notification is ScrollUpdateNotification) {
          final PageMetrics metrics = notification.metrics;
          final int currentPage = int.parse(metrics.page.toStringAsFixed(0));
          if (currentPage != _lastReportedPage) {
            _lastReportedPage = currentPage;
            widget.onPageChanged(currentPage);
          }
        }
        return false;
      },
      child: Scrollable(
        dragStartBehavior: DragStartBehavior.start,
        axisDirection: axisDirection,
        controller: controller,
        physics: physics,
        viewportBuilder: (BuildContext context, ViewportOffset position) {
          widget.childrenDelegate.position = position;
          return Viewport(
            cacheExtent: 0.0,
            cacheExtentStyle: CacheExtentStyle.viewport,
            axisDirection: axisDirection,
            offset: position,
            slivers: <Widget>[
              SliverFillViewport(
                  delegate: widget.childrenDelegate,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ForceImplicitScrollPhysics extends ScrollPhysics {
  const _ForceImplicitScrollPhysics({
    @required this.allowImplicitScrolling,
    ScrollPhysics parent,
  })  : assert(allowImplicitScrolling != null),
        super(parent: parent);

  @override
  _ForceImplicitScrollPhysics applyTo(ScrollPhysics ancestor) {
    return _ForceImplicitScrollPhysics(
      allowImplicitScrolling: allowImplicitScrolling,
      parent: buildParent(ancestor),
    );
  }

  @override
  final bool allowImplicitScrolling;
}

typedef LinkedWidgetBuilder = Widget Function(
    BuildContext context, LinkedIterator current);