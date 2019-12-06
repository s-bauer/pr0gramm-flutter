import 'package:dio/src/response.dart';
import 'package:pr0gramm/api/baseApi.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/dtos/itemInfoResponse.dart';
import 'package:pr0gramm/entities/commonTypes/flags.dart';
import 'package:pr0gramm/entities/commonTypes/itemRange.dart';
import 'package:pr0gramm/entities/commonTypes/promotionStatus.dart';

class GetItemsConfiguration {
  final PromotionStatus promoted;
  final Flags flags;
  final bool self;
  final ItemRange range;
  final int id;

  GetItemsConfiguration(
      {this.id, this.range, this.self, this.promoted, this.flags});

  @override
  String toString() {
    var promotedStr = promoted == PromotionStatus.Promoted
        ? "&promoted=${promoted.value}"
        : "";
    var rangeStr = id != null ? "&${range.value}=$id" : "";
    var selfStr = self != null ? self ? 1 : 0 : "";
    return "flags=${flags.value}$promotedStr$rangeStr$selfStr";
  }
}

class ItemApi extends BaseApi {
  Future<GetItemsResponse> getItems({GetItemsConfiguration config}) async {
    Response response;
    var json;
    try{
      response = await client.get("/items/get?$config");
      json = GetItemsResponse.fromJson(response.data);
    }catch(e) {
      print("Error req: $config");
      print(e);
      return null;
    }
    return json;
  }

  Future<ItemInfoResponse> getItemInfo(int itemId) async {
    Response response;
    try{
      response = await client.get("/items/info?itemId=$itemId");
    }catch(e) {
      print(e);
      return null;
    }
    return ItemInfoResponse.fromJson(response.data);
  }
}
