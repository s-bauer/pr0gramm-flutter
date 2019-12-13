import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/dtos/itemInfoResponse.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/entities/enums/itemRange.dart';
import 'package:pr0gramm/entities/enums/promotionStatus.dart';

import 'baseApi.dart';

class GetItemsConfiguration {
  final PromotionStatus promoted;
  final Flags flags;
  final bool self;
  final ItemRange range;
  final int id;
  final String tags;

  GetItemsConfiguration({
    this.tags,
    this.id,
    this.range,
    this.self,
    this.promoted,
    this.flags,
  });

  String toQueryString() {
    final promotedStr = promoted == PromotionStatus.Promoted
        ? "&promoted=${promoted.value}"
        : "";

    final rangeStr = id != null ? "&${range.value}=$id" : "";
    final selfStr = self != null ? self ? 1 : 0 : "";
    final tagStr = tags != null ? "&tags=$tags" : "";
    final flagStr = "flags=${flags.value}";

    return flagStr + promotedStr + rangeStr + selfStr + tagStr;
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
