import 'package:flutter/material.dart';
import 'package:pr0gramm/constants/vote_constants.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/entities/enums/vote_button_type.dart';
import 'package:pr0gramm/views/post/widgets/vote_button.dart';

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
    return (initialState == VoteAnimation.focused ||
            initialState == VoteAnimation.clearFocused)
        ? focusedColor
        : (initialState == VoteAnimation.voted ||
                initialState == VoteAnimation.voteFocused ||
                initialState == VoteAnimation.voteUnfocused)
            ? (type == VoteButtonType.down) ? downVotedColor : votedColor
            : unfocusedColor;
  }

  Future voteItem(Vote vote) async {
    if (vote == lastVote) {
      vote = vote == Vote.favorite ? Vote.up : Vote.none;
    } else if (vote == Vote.up && lastVote == Vote.favorite) vote = Vote.none;
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
    if ([
      VoteAnimation.voted,
      VoteAnimation.voteFocused,
      VoteAnimation.voteUnfocused,
    ].contains(currentState))
      return _reduceState(
        vote: vote,
        button: button,
        whenFocused: VoteAnimation.clearFocused,
        whenVoted: VoteAnimation.voted,
        whenElse: VoteAnimation.clearUnfocused,
      );

    if ([
      VoteAnimation.focused,
      VoteAnimation.clearFocused,
    ].contains(currentState))
      return _reduceState(
        vote: vote,
        button: button,
        whenFocused: VoteAnimation.focused,
        whenVoted: VoteAnimation.voteFocused,
        whenElse: VoteAnimation.unfocused,
      );

    if ([
      VoteAnimation.unfocused,
      VoteAnimation.clearUnfocused,
    ].contains(currentState))
      return _reduceState(
        vote: vote,
        button: button,
        whenFocused: VoteAnimation.focused,
        whenVoted: VoteAnimation.voteUnfocused,
        whenElse: VoteAnimation.unfocused,
      );

    assert(currentState == VoteAnimation.initial);
    return _reduceState(
      vote: vote,
      button: button,
      whenFocused: VoteAnimation.focused,
      whenVoted: VoteAnimation.voted,
      whenElse: VoteAnimation.unfocused,
    );
  }

  VoteAnimation _reduceState({
    Vote vote,
    Vote button,
    VoteAnimation whenFocused,
    VoteAnimation whenVoted,
    VoteAnimation whenElse,
  }) =>
      _shouldFocus(vote)
          ? whenFocused
          : _shouldVote(vote, button) ? whenVoted : whenElse;

  bool _shouldFocus(Vote vote) => vote == Vote.none;

  bool _shouldVote(Vote vote, Vote button) =>
      vote == button || vote == Vote.favorite && button == Vote.up;
}
