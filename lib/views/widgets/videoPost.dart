import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/services/imageProvider.dart' as imgProv;
import 'package:pr0gramm/views/postView.dart';
import 'package:video_player/video_player.dart';


class VideoPost extends StatefulWidget {
  final Item item;

  VideoPost({Key key, this.item}) : super(key: key);

  @override
  _VideoPostState createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  VideoPlayerController _controller;
  final imgProv.ImageProvider _imageProvider = imgProv.ImageProvider();

  @override
  void initState() {
    super.initState();

    final url = "https://vid.pr0gramm.com/${widget.item.image}";

    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  void handleTap() {
    if (_controller.value.isPlaying)
      _controller.pause();
    else
      _controller.play();
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
    super.dispose();
  }
}
