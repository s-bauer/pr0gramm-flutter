import 'package:pr0gramm/entities/commonTypes/item.dart';

class ItemBatch {
  bool atEnd;
  bool atStart;
  Null error;
  List<Item> items;
  int ts;
  String cache;
  int rt;
  int qc;

  ItemBatch({
    this.atEnd,
    this.atStart,
    this.error,
    this.items,
    this.ts,
    this.cache,
    this.rt,
    this.qc,
  });

  ItemBatch.fromJson(Map<String, dynamic> json) {
    atEnd = json['atEnd'];
    atStart = json['atStart'];
    error = json['error'];
    if (json['items'] != null) {
      items = new List<Item>();
      json['items'].forEach((v) {
        items.add(new Item.fromJson(v));
      });
    }
    ts = json['ts'];
    cache = json['cache'];
    rt = json['rt'];
    qc = json['qc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['atEnd'] = this.atEnd;
    data['atStart'] = this.atStart;
    data['error'] = this.error;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['ts'] = this.ts;
    data['cache'] = this.cache;
    data['rt'] = this.rt;
    data['qc'] = this.qc;
    return data;
  }
}
