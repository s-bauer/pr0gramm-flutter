import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/services/imageProvider.dart' as imgProv;


class ImagePost extends StatefulWidget {
  final Item item;

  ImagePost({Key key, this.item}) : super(key: key);

  @override
  _ImagePostState createState() => _ImagePostState();
}

class _ImagePostState extends State<ImagePost> {
  final imgProv.ImageProvider _imageProvider = imgProv.ImageProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _imageProvider.getImage(widget.item),
      builder: (context, snap) {
        if(snap.hasData)
          return Image.memory(snap.data);

        return Container();
      },
    );
  }
}
