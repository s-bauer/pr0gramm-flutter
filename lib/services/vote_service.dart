import 'dart:convert';

import 'package:pr0gramm/api/itemApi.dart';
import 'package:pr0gramm/data/sharedPrefKeys.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoteService {
  static VoteService instance = new VoteService._();
  VoteService._();

  final ItemApi _itemApi = new ItemApi();

  Future executeVote(Item item, Vote vote) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(SharedPrefKeys.MeToken)) {
      final urlEncodedMeToken = prefs.getString(SharedPrefKeys.MeToken);
      final meToken = Uri.decodeFull(urlEncodedMeToken);
      final meTokenJson = json.decode(meToken);
      final meTokenId = meTokenJson["id"] as String;
      final nonce = meTokenId.substring(0, 16);

      _itemApi.vote(item.id, vote, nonce);
    }
  }
}