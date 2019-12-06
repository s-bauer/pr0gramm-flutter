import 'package:pr0gramm/api/dtos/itemInfoResponse.dart';
import 'package:pr0gramm/api/itemApi.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/entities/commonTypes/itemRange.dart';
import 'package:pr0gramm/entities/postInfo.dart';

class LinkedPostInfo {
  static const preloadThreshold = 3;
  bool hasData = false;
  Item item;
  LinkedPostInfo next;
  LinkedPostInfo prev;
  ItemInfoResponse _info;
  Function(ItemRange range, int itemId) requestRange;

  Future<ItemInfoResponse> get info async {
    if (!hasData) {
      _info = await ItemApi().getItemInfo(item.id);
      hasData = true;
    }
    return _info;
  }

  LinkedPostInfo(this.item, this.requestRange);

  Future<PostInfo> toPostInfo() async => PostInfo(info: await info, item: item);

  void makeCurrent() {
    preloadSurrounding();
  }

  void preloadSurrounding() {
    LinkedPostInfo nLast, pLast = nLast = this;
    LinkedPostInfo nCursor = next;
    LinkedPostInfo pCursor = prev;
    for (int i = 0; i < preloadThreshold; i++) {
      if (nCursor != null) {
        if (!nCursor.hasData) {
          nCursor.info.then((_) => {});
        }
        nLast = nCursor;
        nCursor = nCursor.next;
      } else {
          return requestRange(ItemRange.older, nLast.item.id);
      }
      if (pCursor != null) {
        if (!pCursor.hasData) {
          pCursor.info.then((_) => {});
        }
        pLast = nCursor;
        pCursor = pCursor.prev;
      } else {
        return requestRange(ItemRange.newer, pLast.item.id);
      }
    }
  }
}
