import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/dtos/itemInfoResponse.dart';

import 'baseApi.dart';

class ItemApi extends BaseApi {
  Future<GetItemsResponse> getItems({int flags, bool promoted = false, int older}) async {
    final response = await client.get("/items/get?flags=$flags${promoted ? "&promoted=1" : ""}${older != null ? "&older=$older" : ""}");
    return GetItemsResponse.fromJson(response.data);
  }

  Future<GetItemsResponse> getItemsById(int id,
      {int flags, bool promoted = false}) async {
    var response;
    var temp;

    print("/items/get?id=$id&flags=$flags${promoted ? "&promoted=1" : ""}");
    try {
      response = await client.get(
          "/items/get?id=$id&flags=$flags${promoted ? "&promoted=1" : ""}");
      temp = GetItemsResponse.fromJson(response?.data);
    } catch (e) {
    }
    return temp;
  }

  Future<ItemInfoResponse> getItemInfo(int itemId) async {
    final response = await client.get("/items/info?itemId=$itemId");
    return ItemInfoResponse.fromJson(response.data);
  }
}