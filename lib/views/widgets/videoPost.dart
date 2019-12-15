import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
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


  @override
  void didChangeDependencies() {
    if(!_didInitState) {
      final firstScrollable = Scrollable.of(context);
      _scrollable = Scrollable.of(firstScrollable.context);
      _scrollable.position.isScrollingNotifier.addListener(_onScrollNotifier);

      final isScrolling = _scrollable.position.isScrollingNotifier.value;
      final url = "https://vid.pr0gramm.com/${widget.item.image}";

      _controller = VideoPlayerController.network(url)
        ..initialize().then((_) {
          if(!isScrolling)
            _controller.play();
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
    // final isInViewport = determineIsInViewport();

    if (isScrolling) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  bool determineIsInViewport() {
    final RenderObject object = context.findRenderObject();


    final RenderAbstractViewport viewport = RenderAbstractViewport.of(object);
    final double vpWidth = viewport.paintBounds.width;
    final ScrollPosition scrollPosition = _scrollable.position;
    final RevealedOffset vpOffset = viewport.getOffsetToReveal(object, 0.0);

    // Retrieve the dimensions of the item
    final Size size = object?.semanticBounds?.size;

    // Check if the item is in the viewport
    final double deltaLeft = vpOffset.offset - scrollPosition.pixels;
    final double deltaRight = deltaLeft + size.width;

    bool isInViewport = false;

    isInViewport = (deltaLeft >= 0.0 && deltaRight < vpWidth);
    return isInViewport;
  }

  @override
  Widget build(BuildContext context) {
    return _controller?.value?.initialized ?? false
        ? GestureDetector(
            onTap: handleTap,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          )
        : PreviewItem(item: widget.item);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scrollable.position.isScrollingNotifier.removeListener(_onScrollNotifier);

    super.dispose();
  }
}
