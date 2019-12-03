import 'package:flutter/cupertino.dart';
import 'package:pr0gramm/api/apiClient.dart';
import 'package:pr0gramm/api/profileApi.dart';
import 'package:pr0gramm/data/sharedPrefKeys.dart';
import 'package:pr0gramm/widgets/inherited.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitializeService {
  static InitializeService _instance = InitializeService._internal();
  InitializeService._internal();
  factory InitializeService() => _instance;

  Future initialize(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(SharedPrefKeys.Token) &&
          prefs.containsKey(SharedPrefKeys.MeToken) &&
          prefs.containsKey(SharedPrefKeys.UserName)) {
        final apiClient = ApiClient();

        final token = prefs.getString(SharedPrefKeys.Token);
        final meToken = prefs.getString(SharedPrefKeys.MeToken);
        apiClient.setToken(token, meToken);

        final username = prefs.getString(SharedPrefKeys.UserName);

        final api = ProfileApi();
        final profile = await api.getProfileInfo(name: username, flags: 15);

        MyInherited.of(context).onStatusChange(true, profile);
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}

