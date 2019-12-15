import 'package:path/path.dart';
import 'package:pr0gramm/api/api_client.dart';
import 'package:pr0gramm/api/dtos/profile_info.dart';
import 'package:pr0gramm/api/profile_api.dart';
import 'package:pr0gramm/data/sharedPrefKeys.dart';
import 'package:pr0gramm/db/base/repository_manager.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class InitializationResult {
  final String username;
  final ProfileInfo profile;
  final bool loggedIn;

  InitializationResult({_UserProfile profile})
      : username = profile.username,
        profile = profile.profile,
        loggedIn = profile.loggedIn;

  InitializationResult.failure()
      : loggedIn = false,
        profile = null,
        username = null;
}

class _UserProfile {
  final String username;
  final ProfileInfo profile;
  final bool loggedIn;

  _UserProfile.loggedIn({this.username, this.profile}) : loggedIn = true;

  _UserProfile.notLoggedIn()
      : loggedIn = false,
        profile = null,
        username = null;
}

class InitializationService {
  static InitializationService _instance = InitializationService._internal();

  InitializationService._internal();

  factory InitializationService() => _instance;

  Future<InitializationResult> initialize() async {
    try {
      final db = await _initDB();
      RepositoryManager.db = db;

      final profile = await _initProfile();

      return InitializationResult(profile: profile);
    } on Exception {
      return InitializationResult.failure();
    }
  }

  Future<_UserProfile> _initProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(SharedPrefKeys.Token) &&
          prefs.containsKey(SharedPrefKeys.MeToken) &&
          prefs.containsKey(SharedPrefKeys.UserName)) {
        final apiClient = new ApiClient();

        final token = prefs.getString(SharedPrefKeys.Token);
        final meToken = prefs.getString(SharedPrefKeys.MeToken);
        apiClient.setToken(token, meToken);

        final username = prefs.getString(SharedPrefKeys.UserName);

        final api = ProfileApi();
        final profile =
            await api.getProfileInfo(name: username, flags: Flags.all);

        return new _UserProfile.loggedIn(
          username: username,
          profile: profile,
        );
      } else {
        return new _UserProfile.notLoggedIn();
      }
    } on Exception {
      return new _UserProfile.notLoggedIn();
    }
  }

  Future<Database> _initDB() async {
    final dbBasePath = await getDatabasesPath();
    final dbPath = join(dbBasePath, "default.db");

    final db = await openDatabase(
      dbPath,
      version: RepositoryManager.dbVersion,
      onCreate: RepositoryManager.onDBCreate,
    );

    return db;
  }
}
