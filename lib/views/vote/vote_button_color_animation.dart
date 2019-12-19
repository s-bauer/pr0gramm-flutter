import 'package:flutter/widgets.dart';
import 'package:pr0gramm/constants/vote_constants.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/views/vote/vote_button.dart';
import 'package:pr0gramm/views/vote/vote_button_animation_integration.dart';

mixin VoteButtonColorAnimation<T extends VoteButton>
on VoteButtonAnimationIntegration<T> {
  Color color;
  Color lastColor;

  AnimationController colorController;
  Animation<Color> colorTween;

  @override
  void initState() {
    super.initState();
    colorController = new AnimationController(
      vsync: this,
      duration: voteAnimationDuration,
    );
    colorTween =
        ColorTween(begin: lastColor, end: color).animate(colorController);
    _initAnimationState();
  }

  _initAnimationState() {
    var currentState = widget.animationService.getInitialState(widget.type);
    onStateChange(currentState);
  }

  @override
  void dispose() {
    super.dispose();
    colorController.dispose();
  }

  @override
  onStateChange(VoteAnimation voteAnimation) {
    setState(() {
      lastColor = color;
      color = getColorByAnimation(voteAnimation);
      if (lastColor != color) {
        colorTween =
            ColorTween(begin: lastColor, end: color).animate(colorController);
        colorController.forward(from: 0);
      }
    });
  }

  Color getColorByAnimation(VoteAnimation voteAnimation) {
    if (voteAnimation == VoteAnimation.focused ||
        voteAnimation == VoteAnimation.clearFocused) {
      return focusedColor;
    } else if (voteAnimation == VoteAnimation.voted ||
        voteAnimation == VoteAnimation.voteFocused ||
        voteAnimation == VoteAnimation.voteUnfocused) {
      return votedColor;
    } else {
      return unfocusedColor;
    }
  }
}
