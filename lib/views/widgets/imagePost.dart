import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/services/imageProvider.dart' as imgProv;

import '../postView.dart';

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
      future: getImage(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Image(
            image: snapshot.data,
            fit: BoxFit.fitWidth,
          );

        return PreviewItem(item: widget.item);
      },
    );
  }

  Future<ImageProvider> getImage() async {
    final imgBytes = await _imageProvider.getImage(widget.item);
    final img = MemoryImage(imgBytes);
    await precacheImage(img, context);

    return img;
  }
}