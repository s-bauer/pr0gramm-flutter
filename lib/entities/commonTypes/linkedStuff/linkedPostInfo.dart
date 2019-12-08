import 'package:pr0gramm/api/dtos/itemInfoResponse.dart';
import 'package:pr0gramm/api/itemApi.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/entities/commonTypes/itemRange.dart';
import 'package:pr0gramm/entities/postInfo.dart';
import 'package:pr0gramm/services/imageProvider.dart';
import 'package:pr0gramm/views/widgets/linkedPostPage.dart';
enum WalkDirection {
  next,
  prev
}
class LinkedPostInfo with LinkedIterator<LinkedPostInfo> {
  ImageProvider imageProvider = ImageProvider();
  static const preloadThreshold = 3;
  Item item;
  @override
  LinkedPostInfo next;
  @override
  LinkedPostInfo prev;
  ItemInfoResponse _info;
  bool hasInfo = false;

  Function(ItemRange range, int itemId) requestRange;

  Future<ItemInfoResponse> get info async {
    if (!hasInfo) {
      _info = await ItemApi().getItemInfo(item.id);
      hasInfo = true;
    }
    return _info;
  }

  Future<void> cacheData() async {
    if (ImageProvider.cachedThumbs[item.id] == null)
      await imageProvider.getThumb(item);
    if (ImageProvider.cachedImages[item.id] == null)
      await imageProvider.getImage(item);
    if (!hasInfo) await info;
  }

  LinkedPostInfo(this.item, this.requestRange);

  Future<PostInfo> toPostInfo() async => PostInfo(info: await info, item: item);


  void preloadSurrounding() {
    preloadMe(preloadThreshold + 1, true);
    preloadMe(preloadThreshold + 1, false);
  }

  void preloadMe(int toPreload, bool directionNext) {
    cacheData();
    if (toPreload > 0) if (directionNext) if (next != null)
      next.preloadMe(toPreload - 1, directionNext);
    else
      requestRange(ItemRange.older, item.id);
    else if (prev != null)
      prev.preloadMe(toPreload - 1, directionNext);
    else
      requestRange(ItemRange.newer, item.id);
  }

  LinkedPostInfo walk(WalkDirection direction, [int count = 1]){
    if(count == 0) {
      return this;
    }
    return direction == WalkDirection.next
        ? next?.walk(direction, count - 1) ?? this
        : prev?.walk(direction, count - 1) ?? this;
  }
}
