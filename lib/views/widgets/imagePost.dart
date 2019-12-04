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
    var width = MediaQuery.of(context).size.width;
    var height =
        (width / (widget.item.width + 0.0)) * (widget.item.height + 0.0);
    return Container(
        width: width,
        height: height,
        child: FutureBuilder(
          future: _imageProvider.getImage(widget.item),
          builder: (context, snap) {
            if (snap.hasData) return Image.memory(snap.data);
            return FutureBuilder(
              future: _imageProvider.getThumb(widget.item),
              builder: (context, snap) {
                if (snap.hasData)
                  return Image.memory(snap.data,
                      width: width, height: height, fit: BoxFit.fill);
                return Container(color: Colors.white);
              },
            );
          },
        ));
  }
}
