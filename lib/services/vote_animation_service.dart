import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/entities/enums/vote_button_type.dart';

enum VoteAnimation {
  voted,
  focused,
  unfocused,
  voteFocused,
  voteUnfocused,
  clearFocused,
  clearUnfocused,
}

typedef VoteItemFn = Future Function(Vote vote);
typedef VoteStateChangedHandler = void Function(VoteAnimation voteAnimation);

class VoteAnimationService {
  final VoteItemFn voteItemHandler;
  final Map<VoteButtonType, VoteStateChangedHandler> _stateChangeHandlers =
      new Map();
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

  void addListener(VoteButtonType type, VoteStateChangedHandler handler) {
    _stateChangeHandlers[type] = handler;
  }

  void disposeStateListener(VoteButtonType type) {
    _stateChangeHandlers.remove(type);
  }

  void dispose() {
    _stateChangeHandlers.clear();
    _buttonStates.clear();
  }

  void _notifySubscribers() {
    final buttonTypes = _stateChangeHandlers.keys;
    for (final bType in buttonTypes) {
      _buttonStates[bType] = _getState(bType, _currentVote);

      final callback = _stateChangeHandlers[bType];
      callback(_buttonStates[bType]);
    }
  }

  VoteAnimation _getState(VoteButtonType buttonType, Vote vote) {
    final currentState = _buttonStates[buttonType];

    bool isVoted = [
      VoteAnimation.voted,
      VoteAnimation.voteFocused,
      VoteAnimation.voteUnfocused,
    ].contains(currentState);

    if (isVoted) {
      final whenVoted = VoteAnimation.voted;
      final whenFocused = VoteAnimation.clearFocused;
      final whenElse = VoteAnimation.clearUnfocused;
    }

    bool isFocused = !isVoted &&
        [
          VoteAnimation.focused,
          VoteAnimation.clearFocused,
        ].contains(currentState);

    VoteAnimation whenVoted;
    VoteAnimation whenFocused;
    VoteAnimation whenElse;

     else {
      whenVoted =
          isFocused ? VoteAnimation.voteFocused : VoteAnimation.voteUnfocused;
      whenFocused = VoteAnimation.focused;
      whenElse = VoteAnimation.unfocused;
    }

    return _reduceState(
      vote: vote,
      button: buttonType,
      whenVoted: whenVoted,
      whenFocused: whenFocused,
      whenElse: whenElse,
    );
  }

  VoteAnimation _reduceState({
    Vote vote,
    VoteButtonType button,
    VoteAnimation whenFocused,
    VoteAnimation whenVoted,
    VoteAnimation whenElse,
  }) {
    if (_shouldFocus(vote)) {
      return whenFocused;
    } else {
      if (_shouldVote(vote, button.toVote())) {
        return whenVoted;
      } else {
        return whenElse;
      }
    }
  }

  bool _shouldFocus(Vote vote) => vote == Vote.none;

  bool _shouldVote(Vote vote, Vote button) =>
      vote == button || (vote == Vote.favorite && button == Vote.up);
}
