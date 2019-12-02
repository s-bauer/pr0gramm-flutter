import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/itemApi.dart';

class ItemProvider {
  static ItemProvider _instance = ItemProvider._internal();
  ItemProvider._internal();
  factory ItemProvider() => _instance;


  var _items = List<Item>();
  Future _workingTask;

  Future<Item> getItem(int index) async {
    final itemApi = ItemApi();

    while (true) {
      try {
        if (index < _items.length) return _items[index];

        if (_workingTask != null) {
          await _workingTask;
          continue;
        }

        int older;
        if (_items.isNotEmpty) older = _items.last.promoted;

        _workingTask = itemApi.getItems(
          promoted: true,
          flags: 9,
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
}