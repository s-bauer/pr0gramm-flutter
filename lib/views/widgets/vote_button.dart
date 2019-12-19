import 'package:flutter/material.dart';
import 'package:pr0gramm/constants/vote_constants.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/entities/enums/vote_button_type.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';

class VoteButton extends StatefulWidget {
  final VoteAnimationService animationService;
  final VoteButtonType type;
  final bool disabled;

  VoteButton({
    Key key,
    @required this.type,
    this.disabled = false,
    this.animationService,
  }) : super(key: key);

  @override
  _VoteButtonState createState() {
    return _VoteButtonState();
  }
}

class _VoteButtonState extends State<VoteButton> with TickerProviderStateMixin {
  AnimationController rotationController;
  AnimationController colorController;
  AnimationController favoriteController;
  Animation<Color> colorTween;
  Animation<double> favoriteMorph;
  CurvedAnimation favoriteMorphCurveAnimation;
  Color color;
  Color lastColor;
  IconData icon;

  onStateChange(VoteAnimation voteAnimation) {
    setState(() {
      lastColor = color;
      color = _getColorByAnimation(voteAnimation);

      if (voteAnimation == VoteAnimation.voteFocused ||
          voteAnimation == VoteAnimation.voteUnfocused) {
        if (widget.type == VoteButtonType.favorite) {
          if (widget.animationService.initialVote == Vote.favorite)
            favoriteController.reverse();
          else
            favoriteController.forward();
        } else
          rotationController.forward();
      } else if (voteAnimation == VoteAnimation.clearFocused ||
          voteAnimation == VoteAnimation.clearUnfocused) {
        if (widget.type == VoteButtonType.favorite) {
          if (widget.animationService.initialVote != Vote.favorite)
            favoriteController.reverse();
          else
            favoriteController.forward();
        } else
          rotationController.reverse();
      }

      if (lastColor != color) {
        colorTween =
            ColorTween(begin: lastColor, end: color).animate(colorController);
        colorController.forward(from: 0);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    lastColor = color = _getInitialColor();
    rotationController = new AnimationController(
      vsync: this,
      duration: voteAnimationDuration,
    );
    colorController = new AnimationController(
      vsync: this,
      duration: voteAnimationDuration,
    );
    favoriteController = new AnimationController(
      vsync: this,
      duration: voteAnimationDuration,
    );
    widget.animationService.addButtonStateListener(widget.type, onStateChange);
    icon = widget.type == VoteButtonType.up
        ? Icons.add_circle_outline
        : Icons.remove_circle_outline;
    colorTween =
        ColorTween(begin: lastColor, end: color).animate(colorController);
    if (widget.type == VoteButtonType.favorite) {
      icon = null;
      favoriteMorphCurveAnimation = CurvedAnimation(
          parent: favoriteController,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic);
      favoriteMorph = Tween(
              begin: widget.animationService.initialVote == Vote.favorite
                  ? 1.0
                  : 0.0,
              end: widget.animationService.initialVote != Vote.favorite
                  ? 1.0
                  : 0.0)
          .animate(favoriteMorphCurveAnimation);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorTween,
      builder: (_, __) => RotationTransition(
        turns: rotationController,
        child: _buildBaseVoteButton(color: colorTween.value, icon: icon),
      ),
    );
  }

  IconButton _buildBaseVoteButton({Color color, IconData icon}) => IconButton(
        icon: icon != null
            ? Icon(icon)
            : AnimatedBuilder(
                animation: favoriteMorph,
                builder: (_, __) => RotationTransition(
                  turns: rotationController,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      ScaleTransition(
                        scale: favoriteMorph,
                        child: Icon(Icons.favorite),
                      ),
                      Opacity(
                        opacity: favoriteMorph.value != 1 ? 1.0 : 0,
                        child: Icon(Icons.favorite_border),
                      ),
                    ],
                  ),
                ),
              ),
        color: color,
        onPressed: !widget.disabled
            ? () => widget.animationService.voteItem(
                widget.type == VoteButtonType.up
                    ? Vote.up
                    : widget.type == VoteButtonType.down
                        ? Vote.down
                        : Vote.favorite)
            : null,
        disabledColor: disabledColor,
      );

  Color _getColorByAnimation(VoteAnimation voteAnimation) => (voteAnimation ==
              VoteAnimation.focused ||
          voteAnimation == VoteAnimation.clearFocused)
      ? focusedColor
      : (voteAnimation == VoteAnimation.voted ||
              voteAnimation == VoteAnimation.voteFocused ||
              voteAnimation == VoteAnimation.voteUnfocused)
          ? (widget.type == VoteButtonType.down) ? downVotedColor : votedColor
          : unfocusedColor;

  Color _getInitialColor() =>
      widget.animationService.getInitialColor(widget.type);
}
