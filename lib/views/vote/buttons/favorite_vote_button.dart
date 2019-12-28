import 'package:flutter/material.dart';
import 'package:pr0gramm/constants/vote_constants.dart';
import 'package:pr0gramm/entities/enums/vote_button_type.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/views/vote/mixins/vote_button_color_animation.dart';
import 'package:pr0gramm/views/vote/sized_vote_button.dart';
import 'package:pr0gramm/views/vote/buttons/base/vote_button.dart';
import 'package:pr0gramm/views/vote/mixins/vote_button_animation_integration.dart';

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
        VoteButtonAnimationIntegration,
        VoteButtonColorAnimation {
  AnimationController _controller;
  CurvedAnimation _morphCurve;
  Animation<double> _morphAnimation;

  @override
  void onStateChange(VoteAnimation voteAnimation,
      [bool skipAnimation = false]) {
    super.onStateChange(voteAnimation, skipAnimation);

    var fadeIn = voteAnimation == VoteAnimation.vote;
    var fadeOut = voteAnimation == VoteAnimation.clear;

    if (fadeIn) {
      _controller.forward();
    } else if (fadeOut) {
      _controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();

    widget.animationService.addListener(widget.type, onStateChange);

    _controller = new AnimationController(
      vsync: this,
      duration: voteAnimationDuration,
    );

    _morphCurve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _morphAnimation = Tween(
      begin: 0.0,
      end: 1.0,
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
      child: buildColorAnimation(builder: (context, color) {
        return IconButton(
          iconSize: iconSize,
          padding: EdgeInsets.all(0.0),
          icon: AnimatedBuilder(
            animation: _morphAnimation,
            builder: (_, __) => Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ScaleTransition(
                  scale: _morphAnimation,
                  child: Icon(Icons.favorite),
                ),
                Opacity(
                  opacity: _morphAnimation.value != 1 ? 1 : 0,
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
      }),
    );
  }
}
