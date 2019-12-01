class GetItemsResponse {
  bool atEnd;
  bool atStart;
  Null error;
  List<Item> items;
  int ts;
  String cache;
  int rt;
  int qc;

  GetItemsResponse(
      {this.atEnd,
        this.atStart,
        this.error,
        this.items,
        this.ts,
        this.cache,
        this.rt,
        this.qc});

  GetItemsResponse.fromJson(Map<String, dynamic> json) {
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

class Item {
  int id;
  int promoted;
  int userId;
  int up;
  int down;
  int created;
  String image;
  String thumb;
  String fullsize;
  int width;
  int height;
  bool audio;
  String source;
  int flags;
  int deleted;
  String user;
  int mark;
  int gift;

  Item(
      {this.id,
        this.promoted,
        this.userId,
        this.up,
        this.down,
        this.created,
        this.image,
        this.thumb,
        this.fullsize,
        this.width,
        this.height,
        this.audio,
        this.source,
        this.flags,
        this.deleted,
        this.user,
        this.mark,
        this.gift});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    promoted = json['promoted'];
    userId = json['userId'];
    up = json['up'];
    down = json['down'];
    created = json['created'];
    image = json['image'];
    thumb = json['thumb'];
    fullsize = json['fullsize'];
    width = json['width'];
    height = json['height'];
    audio = json['audio'];
    source = json['source'];
    flags = json['flags'];
    deleted = json['deleted'];
    user = json['user'];
    mark = json['mark'];
    gift = json['gift'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['promoted'] = this.promoted;
    data['userId'] = this.userId;
    data['up'] = this.up;
    data['down'] = this.down;
    data['created'] = this.created;
    data['image'] = this.image;
    data['thumb'] = this.thumb;
    data['fullsize'] = this.fullsize;
    data['width'] = this.width;
    data['height'] = this.height;
    data['audio'] = this.audio;
    data['source'] = this.source;
    data['flags'] = this.flags;
    data['deleted'] = this.deleted;
    data['user'] = this.user;
    data['mark'] = this.mark;
    data['gift'] = this.gift;
    return data;
  }
}