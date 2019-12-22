import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pr0gramm/constants/vote_constants.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/views/vote/vote_button.dart';
import 'package:pr0gramm/views/vote/vote_button_animation_integration.dart';

mixin VoteButtonRotateAnimation<T extends VoteButton>
    on VoteButtonAnimationIntegration<T> {

  AnimationController _rotationController;

  @override
  void onStateChange(VoteAnimation voteAnimation, [bool skipAnimation = false]) {
    super.onStateChange(voteAnimation);

    var isFadeIn = voteAnimation == VoteAnimation.voteFocused ||
        voteAnimation == VoteAnimation.voteUnfocused;
    var isFadeOut = voteAnimation == VoteAnimation.clearFocused ||
        voteAnimation == VoteAnimation.clearUnfocused;

    if (isFadeIn || isFadeOut) {
      if (isFadeIn) {
        _rotationController.forward();
      } else {
        _rotationController.reverse();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _rotationController = new AnimationController(
      vsync: this,
      duration: voteAnimationDuration,
    );
  }

  Widget buildRotatingAnimation({Widget child}) {
    return RotationTransition(
      turns: _rotationController,
      child: child,
    );
  }

  @override
  void dispose() {
    _rotationController?.dispose();
    super.dispose();
  }
}
