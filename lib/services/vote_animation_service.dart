import 'package:flutter/material.dart';
import 'package:pr0gramm/constants/vote_constants.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/entities/enums/vote_button_type.dart';

enum VoteAnimation {
  initial,
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
  final Vote initialVote;
  Vote lastVote;

  VoteAnimationService({this.voteItemHandler, this.initialVote})
      : lastVote = initialVote;

  final Map<VoteButtonType, ValueNotifier<VoteAnimation>> buttonStates =
      new Map();

  Color getInitialColor(VoteButtonType type) {
    VoteAnimation initialState = _reduceState(
      vote: initialVote,
      button: type.toVote(),
      whenFocused: VoteAnimation.focused,
      whenVoted: VoteAnimation.voted,
      whenElse: VoteAnimation.unfocused,
    );
    if ((initialState == VoteAnimation.focused ||
        initialState == VoteAnimation.clearFocused)) {
      return focusedColor;
    } else if ((initialState == VoteAnimation.voted ||
        initialState == VoteAnimation.voteFocused ||
        initialState == VoteAnimation.voteUnfocused)) {
      return (type == VoteButtonType.down) ? downVotedColor : votedColor;
    } else {
      return unfocusedColor;
    }
  }

  Future voteItem(Vote vote) async {
    if (vote == lastVote) {
      vote = vote == Vote.favorite ? Vote.up : Vote.none;
    } else if (vote == Vote.up && lastVote == Vote.favorite) {
      vote = Vote.none;
    }
    _setStates(vote);
    lastVote = vote;
  }

  void addButtonStateListener(
      VoteButtonType type, VoteStateChangedHandler onStateChange) {
    if (buttonStates[type] == null)
      buttonStates[type] = ValueNotifier<VoteAnimation>(VoteAnimation.initial)
        ..addListener(() => onStateChange(buttonStates[type].value));
    _setState(type, lastVote == null ? initialVote : lastVote);
  }

  void _setStates(Vote vote) =>
      buttonStates.keys.forEach((type) => _setState(type, vote));

  void _setState(VoteButtonType type, Vote vote) => buttonStates[type].value =
      _getState(type.toVote(), buttonStates[type].value, vote);

  VoteAnimation _getState(Vote button, VoteAnimation currentState, Vote vote) {
    bool isVoted = [
      VoteAnimation.voted,
      VoteAnimation.voteFocused,
      VoteAnimation.voteUnfocused,
    ].contains(currentState);

    bool isFocused = !isVoted &&
        [
          VoteAnimation.focused,
          VoteAnimation.clearFocused,
        ].contains(currentState);

    bool isUnfocused = !isVoted &&
        !isFocused &&
        [
          VoteAnimation.unfocused,
          VoteAnimation.clearUnfocused,
        ].contains(currentState);

    bool isInitial = !isVoted &&
        !isFocused &&
        !isUnfocused &&
        currentState == VoteAnimation.initial;

    VoteAnimation whenVoted;
    VoteAnimation whenFocused;
    VoteAnimation whenElse;

    if (isVoted) {
      whenVoted = VoteAnimation.voted;
      whenFocused = VoteAnimation.clearFocused;
      whenElse = VoteAnimation.clearUnfocused;
    } else {
      if (isInitial) {
        whenVoted = VoteAnimation.voted;
      } else {
        whenVoted =
            isFocused ? VoteAnimation.voteFocused : VoteAnimation.voteUnfocused;
      }
      whenFocused = VoteAnimation.focused;
      whenElse = VoteAnimation.unfocused;
    }

    return _reduceState(
      vote: vote,
      button: button,
      whenVoted: whenVoted,
      whenFocused: whenFocused,
      whenElse: whenElse,
    );
  }

  VoteAnimation _reduceState({
    Vote vote,
    Vote button,
    VoteAnimation whenFocused,
    VoteAnimation whenVoted,
    VoteAnimation whenElse,
  }) {
    if (_shouldFocus(vote)) {
      return whenFocused;
    } else {
      if (_shouldVote(vote, button)) {
        return whenVoted;
      } else {
        return whenElse;
      }
    }
  }

  bool _shouldFocus(Vote vote) => vote == Vote.none;

  bool _shouldVote(Vote vote, Vote button) =>
      vote == button || vote == Vote.favorite && button == Vote.up;
}
