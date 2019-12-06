import 'package:pr0gramm/api/itemApi.dart';
import 'package:pr0gramm/entities/commonTypes/flags.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/entities/commonTypes/itemRange.dart';
import 'package:pr0gramm/entities/commonTypes/linkedStuff/linkedPostInfo.dart';
import 'package:pr0gramm/entities/commonTypes/promotionStatus.dart';
import 'package:pr0gramm/widgets/inherited.dart';
enum Move {
  next,
  prev
}
class LinkedPostInfoProvider {
  final _itemApi = ItemApi();
  final _context;
  LinkedPostInfo _current;
  static Map<String, LinkedPostInfo> idMap = Map();
  LinkedPostInfoProvider(this._context);

  get _loggedIn => MyInherited.of(_context).isLoggedIn;

  Future<LinkedPostInfo> getLinkedPostInfo({int initialItemId, Move move}) async {
    if(move != null && _current != null) {
      var moveTo;
      if (move == Move.next) {
        moveTo = _current.next;
        if(moveTo == null){
          await newItemRequestHandler(ItemRange.older, _current.item.id);
          moveTo = _current.next ?? _current;
        }
      } else {
        moveTo = _current.prev;
        if(moveTo == null){
          await newItemRequestHandler(ItemRange.older, _current.item.id);
          moveTo = _current.prev ?? _current;
        }
      }
      print(moveTo.item.user);
      return moveTo;
    }
    var inMemory = idMap.keys.contains(initialItemId);
    var linkedPostInfo;
    if (inMemory)
      linkedPostInfo = idMap["$initialItemId"];
    else
      linkedPostInfo = await _build(initialItemId);
    return linkedPostInfo;
  }

  Future<LinkedPostInfo> _build(int initialItemId) async {
    var items = await _get(itemId: initialItemId);
    if(items == null) return null;
    return _buildLinkedItems(items, initialItemId);
  }

  Future<List<Item>> _get({int itemId, range}) async =>
      (await _itemApi.getItems(
              config: GetItemsConfiguration(
                  flags: _loggedIn ? Flags.SFW : Flags.GUEST,
                  promoted: PromotionStatus.Promoted,
                  id: itemId,
                  range: range ?? ItemRange.start)))
          ?.items;

  LinkedPostInfo _buildLinkedItems(List<Item> items, int initialId,
      [LinkedPostInfo next, current]) {
    LinkedPostInfo cur;
    if (items.length == 0) {
      if (initialId == null) {
        current = idMap.values.first;
      }
      if (current == null) {
        var tmp = idMap.values.firstWhere((i) => i.item.id == initialId);
        return tmp;
      }
      return current;
    }


    if (next == null) {
      var firstWhere = idMap["$initialId"];
      cur = firstWhere != null ? firstWhere : LinkedPostInfo(items.removeAt(0), newItemRequestHandler);
    } else {
      cur = next;
    }
    idMap["${cur.item.id}"] = cur;

    if(cur.next == null) {
      cur.next = LinkedPostInfo(items.removeAt(0), newItemRequestHandler);
      cur.next.prev = cur;
    }

    if (initialId == cur.item.id) _current = current = cur;
    return _buildLinkedItems(items, initialId, cur.next, current);
  }

  Future<void> newItemRequestHandler(ItemRange range, int itemId) async {
    var items = await _get(itemId: itemId, range: range);
    if(items == null) return;
    var forward = ItemRange.older == range;
    var cur = idMap.values.firstWhere((i) => i.item.id == itemId);
    if (!forward) {
      items = items.reversed.toList();
    }
    int requester = items.indexWhere((i) => i.id == itemId);
    if(requester != -1) {
      items = forward ? items.skip(requester + 1) : items.take(requester);
    }
    items.forEach((item) {
      var linkedPostInfo = LinkedPostInfo(item, newItemRequestHandler);
      forward ? cur.next = linkedPostInfo : cur.prev = linkedPostInfo;
      cur = cur.next;
    });
  }
}
