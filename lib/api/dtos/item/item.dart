import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/api/dtos/user/user_mark.dart';

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
  Flags flags;
  int deleted;
  String user;
  UserMark mark;
  int gift;

  Item({
    this.id,
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
    this.gift,
  });

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
    flags = Flags(json['flags']);
    deleted = json['deleted'];
    user = json['user'];
    mark = UserMark(json['mark']);
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
    data['flags'] = this.flags.value;
    data['deleted'] = this.deleted;
    data['user'] = this.user;
    data['mark'] = this.mark.value;
    data['gift'] = this.gift;
    return data;
  }
}
