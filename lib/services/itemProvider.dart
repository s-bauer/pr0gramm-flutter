import 'package:flutter/material.dart';
import 'package:pr0gramm/api/itemApi.dart';
import 'package:pr0gramm/entities/commonTypes/flags.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/entities/commonTypes/itemRange.dart';
import 'package:pr0gramm/entities/commonTypes/promotionStatus.dart';
import 'package:pr0gramm/entities/postInfo.dart';
import 'package:pr0gramm/widgets/inherited.dart';

class ItemProvider {
  static ItemProvider _instance = ItemProvider._internal();

  bool loggedIn;

  ItemProvider._internal();

  factory ItemProvider(BuildContext context) {
    _instance.loggedIn = MyInherited.of(context).isLoggedIn;
    return _instance;
  }

  final _itemApi = ItemApi();

  var _items = List<Item>();
  Future _workingTask;

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
          config: GetItemsConfiguration(
              flags: loggedIn ? Flags.SFW : Flags.GUEST,
              promoted: PromotionStatus.Promoted,
              id: older,
              range: ItemRange.older
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

  Future<Item> getItemById(int id) async {
    var index = _items.lastIndexWhere((item) => item.id == id);
    if (index != -1) return await getItem(index);
    while (true) {
      try {
        if (_workingTask != null) {
          await _workingTask;
          continue;
        }

        _workingTask = _itemApi.getItems(
          config: GetItemsConfiguration(
              flags: loggedIn ? Flags.SFW : Flags.GUEST,
              promoted: PromotionStatus.Promoted,
              id: id,
              range: ItemRange.start
          ),
        );
        var getItemsResponse = await _workingTask;
        _workingTask = null;
        if (getItemsResponse != null) _items = getItemsResponse.items;
      } on Exception catch (e) {
        print(e);
      }
      index = _items.lastIndexWhere((item) => item.id == id);
      if (index != -1) return await getItem(index);
    }
  }

  Future<PostInfo> getItemWithInfo(int index) async {
    final item = await getItem(index);
    final info = await _itemApi.getItemInfo(item.id);
    return PostInfo(info: info, item: item);
  }
}
