import 'dart:convert';

import 'package:pr0gramm/db/cached_vote_repository.dart';
import 'package:pr0gramm/entities/enums/itemType.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/itemApi.dart';
import '../data/sharedPrefKeys.dart';
import '../entities/commonTypes/item.dart';
import '../entities/enums/vote.dart';

class VoteService {
  static VoteService _instance = VoteService._internal();

  VoteService._internal();

  factory VoteService() => _instance;

  static ItemApi _itemApi = ItemApi();
  static CachedVoteRepository _voteRepository = CachedVoteRepository.instance;

  voteItem(Item item, Vote vote) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(SharedPrefKeys.MeToken)) {
      final meToken = prefs.getString(SharedPrefKeys.MeToken);
      final nonce = (json.decode(Uri.decodeFull(meToken))["id"] as String)
          .substring(0, 16);
      _itemApi.vote(item.id, vote, nonce);
      _voteRepository.saveVote(
          itemId: item.id, itemType: ItemType.item, vote: vote);
    }
  }

  Future<Vote> getVoteOfItem(Item item) {
    return _voteRepository
        .findOne(itemId: item.id, itemType: ItemType.item)
        .then((cached) => cached.voteValue);
  }
}
