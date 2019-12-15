import 'package:pr0gramm/api/dtos/item_batch.dart';
import 'package:pr0gramm/api/item_api.dart';
import 'package:pr0gramm/entities/enums/item_range.dart';
import 'package:pr0gramm/entities/enums/promotion_status.dart';
import 'package:pr0gramm/services/feedProvider.dart';

class ItemProvider {
  final FeedDetails feedDetails;
  final GetItemsConfiguration _getConfig;
  final _itemApi = ItemApi();

  ItemBatch _newestBatch;
  ItemBatch _oldestBatch;

  ItemProvider(this.feedDetails)
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