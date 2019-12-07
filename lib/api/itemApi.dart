import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/dtos/itemInfoResponse.dart';

import 'baseApi.dart';

class ItemApi extends BaseApi {
  Future<GetItemsResponse> getItems({int flags, String tags, bool promoted = false, int older}) async {
    var url = "/items/get?flags=$flags";
    url += older != null ? "&older=$older" : "";
    url += promoted ? "&promoted=1" : "";
    url += tags != null ? "&tags=$tags" : "";

    final response = await client.get(url);
    return GetItemsResponse.fromJson(response.data);
  }
  Future<ItemInfoResponse> getItemInfo(int itemId) async {
    final response = await client.get("/items/info?itemId=$itemId");
    return ItemInfoResponse.fromJson(response.data);
  }
}