import 'package:pr0gramm/api/apiClient.dart';
import 'package:pr0gramm/api/dtos/profileInfoResponse.dart';
import 'package:pr0gramm/api/profileApi.dart';
import 'package:pr0gramm/data/sharedPrefKeys.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitializationResult {
  final String username;
  final ProfileInfoResponse profile;
  final bool loggedIn;

  InitializationResult.loggedIn({this.username, this.profile}) : loggedIn = true;
  InitializationResult.failure() : username = null, profile = null, loggedIn = false;
  InitializationResult.notLoggedIn(): username = null, profile = null, loggedIn = false;
}

class InitializeService {
  static InitializeService _instance = InitializeService._internal();
  InitializeService._internal();
  factory InitializeService() => _instance;

//  Future initialize(BuildContext context) async {
//    try {
//      final prefs = await SharedPreferences.getInstance();
//      if (prefs.containsKey(SharedPrefKeys.Token) &&
//          prefs.containsKey(SharedPrefKeys.MeToken) &&
//          prefs.containsKey(SharedPrefKeys.UserName)) {
//        final apiClient = ApiClient();
//
//        final token = prefs.getString(SharedPrefKeys.Token);
//        final meToken = prefs.getString(SharedPrefKeys.MeToken);
//        apiClient.setToken(token, meToken);
//
//        final username = prefs.getString(SharedPrefKeys.UserName);
//
//        final api = ProfileApi();
//        final profile = await api.getProfileInfo(name: username, flags: Flags.all);
//
//        GlobalInherited.of(context).onStatusChange(true, profile);
//      }
//    } on Exception catch (e) {
//      print(e);
//    }
//  }

  Future<InitializationResult> initialize2() async {
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
        final profile = await api.getProfileInfo(name: username, flags: Flags.all);

        return new InitializationResult.loggedIn(
          username: username,
          profile: profile,
        );
      } else {
        return new InitializationResult.notLoggedIn();
      }
    } on Exception {
      return InitializationResult.failure();
    }
  }

}

