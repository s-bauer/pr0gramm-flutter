import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pr0gramm/constants/vote_constants.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/views/vote/vote_button.dart';
import 'package:pr0gramm/views/vote/vote_button_animation_integration.dart';
import 'package:pr0gramm/views/vote/vote_button_color_animation.dart';

mixin VoteButtonRotateAnimation<T extends VoteButton>
    on VoteButtonAnimationIntegration<T>, VoteButtonColorAnimation<T> {
  AnimationController rotationController;

  @override
  onStateChange(VoteAnimation voteAnimation) {
    super.onStateChange(voteAnimation);

    var fadeIn = voteAnimation == VoteAnimation.voteFocused ||
        voteAnimation == VoteAnimation.voteUnfocused;
    var fadeOut = voteAnimation == VoteAnimation.clearFocused ||
        voteAnimation == VoteAnimation.clearUnfocused;
    if (fadeIn || fadeOut) {
      setState(() {
        if (fadeIn)
          rotationController.forward();
        else
          rotationController.reverse();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    rotationController = new AnimationController(
      vsync: this,
      duration: voteAnimationDuration,
    );
  }

  @override
  void dispose() {
    super.dispose();
    rotationController.dispose();
  }

  Widget buildRotatingButton({Widget button}) {
    return AnimatedBuilder(
      animation: colorTween,
      child: button,
      builder: (_, _child) => RotationTransition(
        turns: rotationController,
        child: _child,
      ),
    );
  }
}
