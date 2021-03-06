import 'package:dio/dio.dart';
import 'package:pr0gramm/api/dtos/item/item_info.dart';
import 'package:pr0gramm/api/dtos/item_batch.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/entities/enums/item_range.dart';
import 'package:pr0gramm/entities/enums/promotion_status.dart';
import 'package:pr0gramm/entities/enums/vote.dart';

import 'base_api.dart';

class GetItemsConfiguration {
  final PromotionStatus promoted;
  final Flags flags;
  final ItemRange range;
  final int id;
  final String tags;
  final bool self;
  final String likes;

  GetItemsConfiguration({
    this.tags,
    this.id,
    this.range,
    this.promoted,
    this.flags,
    this.self,
    this.likes,
  });

  String toQueryString() {
    final promotedStr = promoted == PromotionStatus.promoted
        ? "&promoted=${promoted.value}"
        : "";

    final selfStr = self != null ? "self=$self" : "";
    final likesStr = self != null ? "likes=$likes" : "";
    final rangeStr = id != null ? "&${range.value}=$id" : "";
    final tagStr = tags != null ? "&tags=$tags" : "";
    final flagStr = "flags=${flags.value}";

    return flagStr + promotedStr + rangeStr + tagStr + selfStr + likesStr;
  }

  GetItemsConfiguration copyWith({
    PromotionStatus promoted,
    Flags flags,
    ItemRange range,
    int id,
    String tags,
    bool self,
    String likes,
  }) {
    return new GetItemsConfiguration(
      promoted: promoted ?? this.promoted,
      flags: flags ?? this.flags,
      range: range ?? this.range,
      id: id ?? this.id,
      tags: tags ?? this.tags,
      self: self ?? this.self,
      likes: tags ?? this.likes,
    );
  }
}

class ItemApi extends BaseApi {
  Future<ItemBatch> getItems(GetItemsConfiguration config) async {
    final queryStr = config.toQueryString();
    final response = await client.get("/items/get?$queryStr");
    return ItemBatch.fromJson(response.data);
  }

  Future<ItemInfo> getItemInfo(int itemId) async {
    final response = await client.get("/items/info?itemId=$itemId");
    return ItemInfo.fromJson(response.data);
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
