import 'package:pr0gramm/api/dtos/item/item.dart';
import 'package:pr0gramm/api/item_api.dart';
import 'package:pr0gramm/data/sharedPrefKeys.dart';
import 'package:pr0gramm/db/cached_vote_repository.dart';
import 'package:pr0gramm/entities/enums/item_type.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/entities/me_cookie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoteService {
  static VoteService instance = new VoteService._();

  VoteService._();

  final ItemApi _itemApi = new ItemApi();
  CachedVoteRepository _voteRepository = CachedVoteRepository.instance;

  Future voteItem(Item item, Vote vote) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(SharedPrefKeys.MeToken)) {
      final urlEncodedMeCookie = prefs.getString(SharedPrefKeys.MeToken);
      final meToken = MeCookie.fromUrlEncodedJson(urlEncodedMeCookie);
      final nonce = meToken.id.substring(0, 16);

      _itemApi.vote(item.id, vote, nonce);
      _voteRepository.saveVote(
        itemId: item.id,
        itemType: ItemType.item,
        vote: vote,
      );
    }
  }

  Future<Vote> getVoteOfItem(Item item) => _voteRepository
          .findOne(itemId: item.id, itemType: ItemType.item)
          .then((cached) {
        if (cached == null) {
          _voteRepository.saveVote(
              itemId: item.id, itemType: ItemType.item, vote: Vote.none);
        }
        return cached?.voteValue ?? Vote.none;
      });
}
