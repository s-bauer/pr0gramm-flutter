import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/views/post/widgets/post_preview_item.dart';
import 'package:video_player/video_player.dart';

class VideoPost extends StatefulWidget {
  final Item item;

  VideoPost({Key key, this.item}) : super(key: key);

  @override
  _VideoPostState createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  VideoPlayerController _controller;
  ScrollableState _scrollable;

  bool _didInitState = false;
  bool _isDisposed = false;

  @override
  void didChangeDependencies() {
    if (!_didInitState) {
      VisibilityDetectorController.instance.updateInterval =
          Duration(milliseconds: 150);

      final firstScrollable = Scrollable.of(context);
      _scrollable = Scrollable.of(firstScrollable.context);
      _scrollable.position.isScrollingNotifier.addListener(_onScrollNotifier);

      final isScrolling = _scrollable.position.isScrollingNotifier.value;
      final url = "https://vid.pr0gramm.com/${widget.item.image}";

      _controller = VideoPlayerController.network(url)
        ..initialize().then((_) {
          if (!isScrolling) _controller.play();
          _controller.setLooping(true);
          setState(() {});
        });

      _didInitState = true;
    }

    super.didChangeDependencies();
  }

  void handleTap() {
    if (_controller.value.isPlaying)
      _controller.pause();
    else
      _controller.play();
  }

  void _onScrollNotifier() {
    final isScrolling = _scrollable.position.isScrollingNotifier.value;

    if (isScrolling) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (_isDisposed) return;

    if (info.visibleFraction < 0.8) {
      _controller.setVolume(0);
    } else {
      _controller.setVolume(1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller?.value?.initialized == false) {
      return PreviewItem(item: widget.item);
    }

    return VisibilityDetector(
      onVisibilityChanged: _handleVisibilityChanged,
      key: ValueKey(widget.item.id),
      child: GestureDetector(
        onTap: handleTap,
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller?.dispose();
    _scrollable.position.isScrollingNotifier.removeListener(_onScrollNotifier);

    super.dispose();
  }
}
