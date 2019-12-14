import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/itemApi.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/entities/enums/itemRange.dart';
import 'package:pr0gramm/entities/enums/promotionStatus.dart';
import 'package:pr0gramm/entities/postInfo.dart';
import 'package:pr0gramm/services/feedProvider.dart';

class ItemProviderNew {
  final FeedDetails feedDetails;
  final GetItemsConfiguration _getConfig;
  final _itemApi = ItemApi();

  ItemBatch _newestBatch;
  ItemBatch _oldestBatch;

  ItemProviderNew(this.feedDetails)
      : _getConfig = new GetItemsConfiguration(
          promoted: feedDetails.promoted,
          flags: feedDetails.flags,
          tags: feedDetails.tags,
        );

  Future<ItemBatch> getFirstBatch() async {
    final batch = await _itemApi.getItems(_getConfig);
    _newestBatch = batch;
    _oldestBatch = batch;
    return batch;
  }

  Future<ItemBatch> getOlderBatch() async {
    if (_oldestBatch == null) return await getFirstBatch();

    if (_oldestBatch.atEnd) return null;

    final config = _getConfig.withValues(
      range: ItemRange.older,
      id: feedDetails.promoted == PromotionStatus.promoted
          ? _oldestBatch.items.last.promoted
          : _oldestBatch.items.last.id,
    );

    return _oldestBatch = await _itemApi.getItems(config);
  }

  Future<ItemBatch> getNewerBatch() async {
    if (_newestBatch == null) return await getFirstBatch();

    if (_newestBatch.atStart) return null;

    final config = _getConfig.withValues(
      range: ItemRange.newer,
      id: feedDetails.promoted == PromotionStatus.promoted
          ? _newestBatch.items.first.promoted
          : _newestBatch.items.first.id,
    );

    return _newestBatch = await _itemApi.getItems(config);
  }
}

@deprecated
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
          GetItemsConfiguration(
            promoted: feedDetails.promoted,
            flags: feedDetails.flags,
            tags: feedDetails.tags,
            id: older,
            range: ItemRange.older,
          ),
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
