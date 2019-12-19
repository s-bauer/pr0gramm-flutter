import 'package:pr0gramm/api/comment_api.dart';
import 'package:pr0gramm/api/dtos/comment/item_comment.dart';
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
  final CommentApi _commentApi = new CommentApi();
  CachedVoteRepository _voteRepository = CachedVoteRepository.instance;

  Future<String> getNonce() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(SharedPrefKeys.MeToken)) return null;
    final urlEncodedMeCookie = prefs.getString(SharedPrefKeys.MeToken);
    final meToken = MeCookie.fromUrlEncodedJson(urlEncodedMeCookie);
    return meToken.id.substring(0, 16);
  }

  Future voteItem(Item item, Vote vote) async {
    _itemApi.vote(item.id, vote, await getNonce());
    _voteRepository.saveVote(
      itemId: item.id,
      itemType: ItemType.item,
      vote: vote,
    );
  }

  Future<Vote> getVoteOfItem(Item item) async {
    final voteItem =
        await _voteRepository.findOne(itemId: item.id, itemType: ItemType.item);

    if (voteItem == null) return Vote.none;

    return voteItem.voteValue;
  }

  Future voteComment(ItemComment comment, Vote vote) async {
    _commentApi.vote(comment.id, vote, await getNonce());
    _voteRepository.saveVote(
      itemId: comment.id,
      itemType: ItemType.comment,
      vote: vote,
    );
  }

  Future<Vote> getCommentOfItem(ItemComment comment) async {
    final voteItem =
    await _voteRepository.findOne(itemId: comment.id, itemType: ItemType.comment);

    if (voteItem == null) return Vote.none;

    return voteItem.voteValue;
  }
}
