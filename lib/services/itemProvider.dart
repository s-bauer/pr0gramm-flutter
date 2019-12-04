import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/itemApi.dart';
import 'package:pr0gramm/entities/postInfo.dart';

class ItemProvider {
  static ItemProvider _instance = ItemProvider._internal();
  ItemProvider._internal();
  factory ItemProvider() => _instance;

  final _itemApi = ItemApi();

  var _items = List<Item>();
  Future _workingTask;

  Future<Item> getItem(int index) async {
    while (true) {
      try {
        if (index < _items.length) return _items[index];

        if (_workingTask != null) {
          await _workingTask;
          continue;
        }

        int older;
        if (_items.isNotEmpty) older = _items.last.promoted;

        _workingTask = _itemApi.getItems(
          promoted: true,
          flags: 1,
          older: older,
        );
        var getItemsResponse = await _workingTask;
        _workingTask = null;

        _items.addAll(getItemsResponse.items);
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  Future<Item> getItemById(int id) async {
    var index = _items.lastIndexWhere((item) => item.id == id);
    if (index != -1) return await getItem(index);
    while (true) {
      try {
        if (_workingTask != null) {
          await _workingTask;
          continue;
        }

        _workingTask = _itemApi.getItemsById(id, promoted: true, flags: 1);
        var getItemsResponse = await _workingTask;
        _workingTask = null;
        if (getItemsResponse != null) _items = getItemsResponse.items;
      } on Exception catch (e) {
        print(e);
      }
      index = _items.lastIndexWhere((item) => item.id == id);
      if (index != -1) return await getItem(index);
    }
  }

  Future<PostInfo> getItemWithInfo(int index) async {
    final item = await getItem(index);
    final info = await _itemApi.getItemInfo(item.id);
    return PostInfo(info: info, item: item);
  }
}