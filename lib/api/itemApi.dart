import 'package:dio/dio.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/dtos/itemInfoResponse.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/entities/enums/itemRange.dart';
import 'package:pr0gramm/entities/enums/promotionStatus.dart';
import 'package:pr0gramm/entities/enums/vote.dart';

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

  GetItemsConfiguration withValues({
    PromotionStatus promoted,
    Flags flags,
    ItemRange range,
    int id,
    String tags,
  }) {
    return new GetItemsConfiguration(
      promoted: promoted ?? this.promoted,
      flags: flags ?? this.flags,
      range: range ?? this.range,
      id: id ?? this.id,
      tags: tags ?? this.tags,
    );
  }
}

class ItemApi extends BaseApi {
  Future<ItemBatch> getItems(GetItemsConfiguration config) async {
    final queryStr = config.toQueryString();
    final response = await client.get("/items/get?$queryStr");
    return ItemBatch.fromJson(response.data);
  }

  Future<ItemInfoResponse> getItemInfo(int itemId) async {
    final response = await client.get("/items/info?itemId=$itemId");
    return ItemInfoResponse.fromJson(response.data);
  }

  Future vote(int itemId, Vote vote, String nonce) async {
    final data = {
      "id": itemId,
      "vote": vote.value,
      "_nonce": nonce,
    };

    await client.post(
      "/items/vote",
      data: data,
      options: new Options(contentType: Headers.formUrlEncodedContentType),
    );
  }
}
