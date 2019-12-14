import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/dtos/itemInfoResponse.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/entities/enums/itemRange.dart';
import 'package:pr0gramm/entities/enums/promotionStatus.dart';

import 'baseApi.dart';

class GetItemsConfiguration {
  final PromotionStatus promoted;
  final Flags flags;
  final ItemRange range;
  final int id;
  final String tags;

  GetItemsConfiguration({
    this.tags,
    this.id,
    this.range,
    this.promoted,
    this.flags,
  });

  String toQueryString() {
    final promotedStr = promoted == PromotionStatus.promoted
        ? "&promoted=${promoted.value}"
        : "";

    final rangeStr = id != null ? "&${range.value}=$id" : "";
    final tagStr = tags != null ? "&tags=$tags" : "";
    final flagStr = "flags=${flags.value}";

    return flagStr + promotedStr + rangeStr + tagStr;
  }
}

class ItemApi extends BaseApi {
  Future<GetItemsResponse> getItems(GetItemsConfiguration config) async {
    final queryStr = config.toQueryString();
    final response = await client.get("/items/get?$queryStr");
    return GetItemsResponse.fromJson(response.data);
  }

  Future<ItemInfoResponse> getItemInfo(int itemId) async {
    final response = await client.get("/items/info?itemId=$itemId");
    return ItemInfoResponse.fromJson(response.data);
  }
}
