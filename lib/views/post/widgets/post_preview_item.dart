import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/services/imageProvider.dart';

class PreviewItem extends StatelessWidget {
  final MyImageProvider _imageProvider = MyImageProvider();
  final Item item;

  PreviewItem({this.item});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final isHorizontalImage = item.width > item.height;
    final previewWidth = isHorizontalImage ? deviceSize.height : deviceSize.width;
    final previewFit = isHorizontalImage ? BoxFit.fitHeight : BoxFit.fitWidth;

    return FutureBuilder(
      future: _imageProvider.getThumb(item),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Image.memory(
            snapshot.data,
            fit: previewFit,
            width: previewWidth,
          );

        return Container();
      },
    );
  }
}
