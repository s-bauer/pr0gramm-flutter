import 'package:flutter/material.dart';
import 'package:pr0gramm/constants/vote_constants.dart';
import 'package:pr0gramm/entities/enums/vote_button_type.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/views/vote/sized_vote_button.dart';
import 'package:pr0gramm/views/vote/vote_button.dart';
import 'package:pr0gramm/views/vote/vote_button_animation_integration.dart';
import 'package:pr0gramm/views/vote/vote_button_color_animation.dart';

class FavoriteVoteButton extends VoteButton {
  FavoriteVoteButton({
    Key key,
    @required VoteAnimationService animationService,
    bool disabled,
    double width,
    double height,
  }) : super(
          key: key,
          type: VoteButtonType.favorite,
          disabled: disabled,
          animationService: animationService,
          width: width,
          height: height,
        );

  @override
  _FavoriteVoteButtonState createState() {
    return _FavoriteVoteButtonState();
  }
}

class _FavoriteVoteButtonState extends State<FavoriteVoteButton>
    with
        TickerProviderStateMixin,
        SizedVoteButton,
        VoteButtonAnimationIntegration<FavoriteVoteButton>,
        VoteButtonColorAnimation<FavoriteVoteButton> {
  AnimationController _controller;
  CurvedAnimation _morphCurve;
  Animation<double> _morphProgress;
  bool _votedColorAtBegin;

  @override
  onStateChange(VoteAnimation voteAnimation, [bool skipAnimation = false]) {
    super.onStateChange(voteAnimation, skipAnimation);

    var fadeIn = voteAnimation == VoteAnimation.vote;
    var fadeOut = voteAnimation == VoteAnimation.clear;
    if (fadeIn || fadeOut) {
      if (fadeIn ^ _votedColorAtBegin)
        _controller.forward();
      else
        _controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();

    _votedColorAtBegin = false;
    _controller = new AnimationController(
      vsync: this,
      duration: voteAnimationDuration,
    );

    widget.animationService.addListener(widget.type, onStateChange);

    _morphCurve = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic);
    _morphProgress = Tween(
      begin: _votedColorAtBegin ? 1.0 : 0.0,
      end: !_votedColorAtBegin ? 1.0 : 0.0,
    ).animate(_morphCurve);
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildSized(
      child: buildColorAnimation(
        builder: (context, color) {
          return IconButton(
            iconSize: iconSize,
            padding: EdgeInsets.all(0.0),
            icon: AnimatedBuilder(
              animation: _morphProgress,
              builder: (_, __) => Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ScaleTransition(
                    scale: _morphProgress,
                    child: Icon(Icons.favorite),
                  ),
                  Opacity(
                    opacity: _morphProgress.value != 1 ? 1 : 0,
                    child: Icon(Icons.favorite_border),
                  ),
                ],
              ),
            ),
            color: color,
            onPressed: !widget.disabled
                ? () => widget.animationService.voteItem(widget.type.toVote())
                : null,
            disabledColor: disabledColor,
          );
        }
      ),
    );
  }
}
