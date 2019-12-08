import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/dtos/itemInfoResponse.dart';
import 'package:pr0gramm/entities/commonTypes/flags.dart';
import 'package:pr0gramm/entities/commonTypes/itemRange.dart';
import 'package:pr0gramm/entities/commonTypes/promotionStatus.dart';

import 'baseApi.dart';

class GetItemsConfiguration {
  final PromotionStatus promoted;
  final Flags flags;
  final bool self;
  final ItemRange range;
  final int id;
  final String tags;

  GetItemsConfiguration(
      {this.tags, this.id, this.range, this.self, this.promoted, this.flags});

  @override
  String toString() {
    var promotedStr = promoted == PromotionStatus.Promoted
        ? "&promoted=${promoted.value}"
        : "";
    var rangeStr = id != null ? "&${range.value}=$id" : "";
    var selfStr = self != null ? self ? 1 : 0 : "";
    var tagStr = tags != null ? "&tags=$tags" : "";
    return "flags=${flags.value}$promotedStr$rangeStr$selfStr$tagStr";
  }
}

class ItemApi extends BaseApi {
  Future<GetItemsResponse> getItems({GetItemsConfiguration config}) async {
    final response = await client.get("/items/get?$config");
    return GetItemsResponse.fromJson(response.data);
  }

  Future<ItemInfoResponse> getItemInfo(int itemId) async {
    final response = await client.get("/items/info?itemId=$itemId");
    return ItemInfoResponse.fromJson(response.data);
  }
}
