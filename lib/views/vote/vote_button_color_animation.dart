import 'package:flutter/widgets.dart';
import 'package:pr0gramm/constants/vote_constants.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/views/vote/vote_button.dart';
import 'package:pr0gramm/views/vote/vote_button_animation_integration.dart';

mixin VoteButtonColorAnimation<T extends VoteButton>
on VoteButtonAnimationIntegration<T> {
  Color _endColor;
  Color _beginColor;

  AnimationController _colorController;
  Animation<Color> _colorTweenAnimation;
  ColorTween _colorTween;


  @override
  void initState() {
    super.initState();

    _colorController = new AnimationController(
      vsync: this,
      duration: voteAnimationDuration,
    );

    _colorTween = ColorTween();
    _colorTweenAnimation = _colorTween.animate(_colorController);
  }

  @override
  void onStateChange(VoteAnimation voteAnimation, [bool skipAnimation = false]) {
    super.onStateChange(voteAnimation, false);

    _beginColor = _endColor;
    _endColor = getColorByAnimation(voteAnimation);

    if (_beginColor != _endColor) {
      if(skipAnimation) {
        _colorTween.begin = _endColor;
      } else {
        _colorTween.begin = _beginColor;
      }

      _colorTween.end = _endColor;
      _colorController.forward(from: 0);
    }
  }

  Color getColorByAnimation(VoteAnimation voteAnimation) {
    if(voteAnimation == VoteAnimation.none)
      return focusedColor;

    if(voteAnimation == VoteAnimation.vote)
      return votedColor;

    return unfocusedColor;
  }

  Widget buildColorAnimation({Widget Function(BuildContext context, Color color) builder}) {
    return AnimatedBuilder(
      animation: _colorTweenAnimation,
      builder: (context, _) => builder(context, _colorTweenAnimation.value),
    );
  }

  @override
  void dispose() {
    _colorController?.dispose();
    super.dispose();
  }
}
