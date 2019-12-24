import 'package:pr0gramm/db/cached_vote_repository.dart';
import 'package:sqflite/sqlite_api.dart';

class RepositoryManager {
  static Database db;
  static int dbVersion = 1;

  static Future onDBCreate(Database db, int version) async {
    CachedVoteRepository.createTable(db);
  }
}
