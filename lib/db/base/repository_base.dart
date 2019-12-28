import 'package:pr0gramm/db/base/repository_manager.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class RepositoryBase {
  Database get db => RepositoryManager.db;
}
