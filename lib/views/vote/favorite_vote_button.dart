import 'package:flutter/material.dart';
import 'package:pr0gramm/constants/vote_constants.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/entities/enums/vote_button_type.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/views/vote/vote_button.dart';
import 'package:pr0gramm/views/vote/vote_button_animation_integration.dart';

class FavoriteVoteButton extends VoteButton {
  FavoriteVoteButton({
    Key key,
    @required VoteAnimationService animationService,
    bool disabled,
  }) : super(
            key: key,
            type: VoteButtonType.favorite,
            disabled: disabled,
            animationService: animationService);

  @override
  _FavoriteVoteButtonState createState() {
    return _FavoriteVoteButtonState();
  }
}

class _FavoriteVoteButtonState extends State<FavoriteVoteButton>
    with
        TickerProviderStateMixin,
        VoteButtonAnimationIntegration<FavoriteVoteButton> {
  AnimationController _controller;
  CurvedAnimation _morphCurve;
  Animation<double> _morphProgress;
  bool _votedColorAtBegin;

  @override
  onStateChange(VoteAnimation voteAnimation) {
    super.onStateChange(voteAnimation);

    var fadeIn = voteAnimation == VoteAnimation.voteFocused ||
        voteAnimation == VoteAnimation.voteUnfocused;
    var fadeOut = voteAnimation == VoteAnimation.clearFocused ||
        voteAnimation == VoteAnimation.clearUnfocused;
    if (fadeIn || fadeOut) {
      setState(() {
        print("animate favorite ${(fadeIn || fadeOut) ^ _votedColorAtBegin}");
        if (fadeIn ^ _votedColorAtBegin)
          _controller.forward();
        else
          _controller.reverse();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _votedColorAtBegin = widget.animationService.initialVote == Vote.favorite;
    _controller = new AnimationController(
      vsync: this,
      duration: voteAnimationDuration,
    );

    widget.animationService.addButtonStateListener(widget.type, onStateChange);

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
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
}
