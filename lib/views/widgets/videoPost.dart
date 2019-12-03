import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:video_player/video_player.dart';

class VideoPost extends StatefulWidget {
  final Item item;

  VideoPost({Key key, this.item}) : super(key: key);

  @override
  _VideoPostState createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    final url = "https://vid.pr0gramm.com/${widget.item.image}";

    VideoPlayerController.
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (_controller.value.isPlaying)
              _controller.pause();
            else
              _controller.play();
          },
          child: _controller?.value?.initialized ?? false
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : CircularProgressIndicator(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
