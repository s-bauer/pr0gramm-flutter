import 'package:pr0gramm/api/dtos/comment/item_comment.dart';
import 'package:pr0gramm/api/dtos/tag/tag.dart';

class ItemInfo {
  String cache;
  int ts;
  int rt;
  int qc;
  List<ItemComment> comments;
  List<Tag> tags;

  ItemInfo({
    this.cache,
    this.ts,
    this.rt,
    this.qc,
    this.comments,
    this.tags,
  });

  ItemInfo.fromJson(Map<String, dynamic> json) {
    this.cache = json['cache'];
    this.ts = json['ts'];
    this.rt = json['rt'];
    this.qc = json['qc'];
    this.comments = (json['comments'] as List) != null
        ? (json['comments'] as List)
            .map((i) => ItemComment.fromJson(i))
            .toList()
        : null;
    this.tags = (json['tags'] as List) != null
        ? (json['tags'] as List).map((i) => Tag.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cache'] = this.cache;
    data['ts'] = this.ts;
    data['rt'] = this.rt;
    data['qc'] = this.qc;
    data['comments'] = this.comments != null
        ? this.comments.map((i) => i.toJson()).toList()
        : null;
    data['tags'] =
        this.tags != null ? this.tags.map((i) => i.toJson()).toList() : null;

    return data;
  }
}
