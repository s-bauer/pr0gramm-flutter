import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:video_player/video_player.dart';
import 'package:pr0gramm/services/imageProvider.dart' as imgProv;

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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height =
        (width / (widget.item.width + 0.0)) * (widget.item.height + 0.0);
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
              : Container(
                  color: Colors.white,
                  width: width,
                  height: height,
                  child: FutureBuilder(
                    future: _imageProvider.getThumb(widget.item),
                    builder: (context, snap) {
                      if (snap.hasData)
                        return Image.memory(snap.data,
                            width: width,
                            height: height,
                            fit: BoxFit.fill);

                      return Container(color: Colors.white);
                    },
                  )),
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
