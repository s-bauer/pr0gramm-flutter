import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/services/my_image_provider.dart' as imgProv;
import 'package:pr0gramm/views/post/widgets/post_preview_item.dart';

class ImagePost extends StatefulWidget {
  final Item item;

  ImagePost({Key key, this.item}) : super(key: key);

  @override
  _ImagePostState createState() => _ImagePostState();
}

class _ImagePostState extends State<ImagePost> {
  final imgProv.MyImageProvider _imageProvider = imgProv.MyImageProvider();

  @override
  Widget build(BuildContext context) {
    return Image.network(
      _imageProvider.getImageUrl(widget.item),
      frameBuilder: (context, child, frame, sync) {
        if(child != null)
          return child;

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
