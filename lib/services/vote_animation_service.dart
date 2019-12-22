import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/entities/enums/vote_button_type.dart';

enum VoteAnimation {
  none,
  vote,
  clear,
}

typedef _VoteItemFunction = Future Function(Vote vote);
typedef _StateChangeHandler = void Function(VoteAnimation voteAnimation);

class VoteAnimationService {
  final _VoteItemFunction voteItemHandler;
  final Map<VoteButtonType, _StateChangeHandler> _changeHandlers = new Map();
  final Map<VoteButtonType, VoteAnimation> _buttonStates = new Map();

  Vote _currentVote;
  Vote get currentVote => _currentVote ?? Vote.none;
  set currentVote(Vote value) {
    _currentVote = value;
    _notifySubscribers();
  }

  VoteAnimationService({this.voteItemHandler, Future<Vote> initialVoteFuture}) {
    initialVoteFuture.then((vote) {
      currentVote = vote;
    });
  }

  Future voteItem(Vote vote) async {
    if (currentVote == Vote.favorite) {
      if (vote == Vote.favorite) {
        vote = Vote.up;
      } else if (vote == Vote.up) {
        vote = Vote.none;
      }
    } else if(currentVote == Vote.up && vote == Vote.up) {
      vote = Vote.none;
    } else if(currentVote == Vote.down && vote == Vote.down) {
      vote = Vote.none;
    }

    final lastVote = _currentVote;
    currentVote = vote;

    voteItemHandler(vote).catchError((err) {
      currentVote = lastVote;
    });
  }

  void addListener(VoteButtonType type, _StateChangeHandler handler) {
    _changeHandlers[type] = handler;
  }

  void disposeStateListener(VoteButtonType type) {
    _changeHandlers.remove(type);
  }

  void dispose() {
    _changeHandlers.clear();
    _buttonStates.clear();
  }

  void _notifySubscribers() {
    final buttonTypes = _changeHandlers.keys;
    for (final bType in buttonTypes) {
      _buttonStates[bType] = _getState(bType);

      final callback = _changeHandlers[bType];
      callback(_buttonStates[bType]);
    }
  }

  VoteAnimation _getState(VoteButtonType buttonType) {
    if(currentVote == Vote.none)
      return VoteAnimation.none;

    if(buttonType.toVote() == currentVote)
      return VoteAnimation.vote;

    if(buttonType == VoteButtonType.up && currentVote == Vote.favorite)
      return VoteAnimation.vote;

    return VoteAnimation.clear;
  }
}
