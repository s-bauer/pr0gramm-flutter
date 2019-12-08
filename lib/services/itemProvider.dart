import 'package:pr0gramm/api/itemApi.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/entities/commonTypes/itemRange.dart';
import 'package:pr0gramm/entities/postInfo.dart';
import 'package:pr0gramm/services/feedProvider.dart';

class ItemProvider {
  final FeedDetails feedDetails;
  final _itemApi = ItemApi();

  var _items = List<Item>();
  Future _workingTask;

  ItemProvider(this.feedDetails);

  Future<Item> getItem(int index) async {
    while (true) {
      try {
        if (index < _items.length) return _items[index];

        if (_workingTask != null) {
          await _workingTask;
          continue;
        }

        int older;
        if (_items.isNotEmpty) older = _items.last.id;

        _workingTask = _itemApi.getItems(
          config: GetItemsConfiguration(
              promoted: feedDetails.promoted,
              flags: feedDetails.flags,
              tags: feedDetails.tags,
              id: older,
              range: ItemRange.older),
        );
        var getItemsResponse = await _workingTask;
        _workingTask = null;

        _items.addAll(getItemsResponse.items);
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  Future<PostInfo> getItemWithInfo(int index) async {
    final item = await getItem(index);
    final info = await _itemApi.getItemInfo(item.id);
    return PostInfo(info: info, item: item);
  }
}
