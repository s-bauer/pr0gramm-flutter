import 'package:pr0gramm/api/itemApi.dart';
import 'package:pr0gramm/entities/commonTypes/flags.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/entities/commonTypes/itemRange.dart';
import 'package:pr0gramm/entities/commonTypes/linkedStuff/linkedPostInfo.dart';
import 'package:pr0gramm/entities/commonTypes/promotionStatus.dart';

class LinkedPostInfoProvider {
  final _itemApi = ItemApi();
  final _context;
  static LinkedPostInfo _current;
  static Map<int, LinkedPostInfo> idMap = Map();

  LinkedPostInfoProvider(this._context);

  setCurrent(int id) {
    _current = (idMap[id] ?? _current)..preloadSurrounding();
  }

  get _loggedIn => false;

  Future<LinkedPostInfo> getLinkedPostInfo({int initialItemId}) async {
    var inMemory = idMap.keys.contains(initialItemId);
    var linkedPostInfo;
    if (inMemory) {
      linkedPostInfo = _current = idMap[initialItemId];
    } else {
      linkedPostInfo = await _build(initialItemId);
    }
    return linkedPostInfo;
  }

  Future<LinkedPostInfo> _build(int initialItemId) async {
    var items = await _get(itemId: initialItemId);
    if (items == null) return null;
    return _buildLinkedItems(items, initialItemId);
  }

  Future<List<Item>> _get({int itemId, range}) async =>
      (await _itemApi.getItems(
              config: GetItemsConfiguration(
                  flags: _loggedIn ? Flags.SFW : Flags.GUEST,
                  promoted: PromotionStatus.Promoted,
                  id: itemId,
                  range: range ?? ItemRange.around)))
          ?.items;

  LinkedPostInfo _buildLinkedItems(List<Item> items, int initialId,
      [LinkedPostInfo next, current]) {
    LinkedPostInfo cur;
    if (items.length == 0) {
      if (initialId == null) {
        current = idMap.values.first;
      }
      if (current == null) {
        var tmp = idMap[initialId];
        return tmp;
      }
      return current;
    }

    if (next == null) {
      var firstWhere = idMap[initialId];
      cur = firstWhere != null
          ? firstWhere
          : LinkedPostInfo(items.removeAt(0), newItemRequestHandler);
    } else {
      cur = next;
    }
    idMap[cur.item.id] = cur;

    if (cur.next == null) {
      cur.next = LinkedPostInfo(items.removeAt(0), newItemRequestHandler);
      cur.next.prev = cur;
    }

    if (initialId == cur.item.id) _current = current = cur;
    return _buildLinkedItems(items, initialId, cur.next, current);
  }

  Future<void> newItemRequestHandler(ItemRange range, int itemId) async {
    var items;
    try {
      items = await _get(itemId: itemId, range: range);
    } catch (e) {
      print(e);
    }
    if (items == null) return;
    var forward = ItemRange.older == range;
    var cur = idMap[itemId];
    if (!forward) {
      items = items.reversed.toList();
    }
    int requester = items.indexWhere((i) => i.id == itemId);
    if (requester != -1) {
      items = forward ? items.skip(requester + 1) : items.take(requester);
    }
    items.forEach((item) {
      var linkedPostInfo = LinkedPostInfo(item, newItemRequestHandler);
      forward ? cur.next = linkedPostInfo : cur.prev = linkedPostInfo;
      cur = cur.next;
    });
  }
}
