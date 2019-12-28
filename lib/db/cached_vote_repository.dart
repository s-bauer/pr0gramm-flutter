import 'package:pr0gramm/db/base/repository_base.dart';
import 'package:pr0gramm/entities/enums/item_type.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:sqflite/sqlite_api.dart';

// SQL Table and commands taken from https://github.com/mopsalarm/Pr0/blob/master/model/src/main/sqldelight/com/pr0gramm/app/db/CachedVote.sq

class CachedVoteRepository extends RepositoryBase {
  static CachedVoteRepository instance = new CachedVoteRepository._();

  CachedVoteRepository._();

  Future saveVote({int itemId, ItemType itemType, Vote vote}) async {
    final insertSql =
        "INSERT OR REPLACE INTO cachedVote (id, itemId, itemType, voteValue) VALUES (?, ?, ?, ?)";
    final voteId = itemType.value + 10 * itemId;
    db.rawInsert(insertSql, [voteId, itemId, itemType.value, vote.value]);
  }

  Future<CachedVote> findOne({int itemId, ItemType itemType}) async {
    final querySql =
        "SELECT itemId, itemType, voteValue FROM cachedVote WHERE id=?";
    final voteId = itemType.value + 10 * itemId;
    final result = await db.rawQuery(querySql, [voteId]);
    if (result.isEmpty) return null;

    return CachedVote.fromMap(result.first);
  }

  Future<List<CachedVote>> findSome(
      {List<int> itemIds, ItemType itemType}) async {
    final querySql =
        "SELECT itemId, itemType, voteValue FROM cachedVote WHERE id IN ?";

    final voteIds = itemIds.map((id) => id * 10 + itemType.value);
    final result = await db.rawQuery(querySql, [voteIds]);
    if (result.isEmpty) return null;

    return result.map((m) => CachedVote.fromMap(m));
  }

  static Future createTable(Database db) async {
    await db.execute("""CREATE TABLE cachedVote (
    id INTEGER PRIMARY KEY NOT NULL,
    itemId INTEGER NOT NULL,
    itemType INTEGER NOT NULL,
    voteValue INTEGER NOT NULL
)""");
  }
}

class CachedVote {
  final int id;
  final int itemId;
  final ItemType itemType;
  final Vote voteValue;

  CachedVote({this.id, this.itemId, this.itemType, this.voteValue});

  static CachedVote fromMap(Map<String, dynamic> map) {
    return CachedVote(
      id: map["id"],
      itemId: map["itemId"],
      itemType: ItemType(map["itemType"]),
      voteValue: Vote(map["voteValue"]),
    );
  }
}
