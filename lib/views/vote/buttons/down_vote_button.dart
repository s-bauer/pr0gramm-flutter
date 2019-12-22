import 'package:flutter/material.dart';
import 'package:pr0gramm/constants/vote_constants.dart';
import 'package:pr0gramm/entities/enums/vote_button_type.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/views/vote/mixins/vote_button_color_animation.dart';
import 'package:pr0gramm/views/vote/mixins/vote_button_rotate_animation.dart';
import 'package:pr0gramm/views/vote/sized_vote_button.dart';
import 'package:pr0gramm/views/vote/buttons/base/vote_button.dart';
import 'package:pr0gramm/views/vote/mixins/vote_button_animation_integration.dart';

class DownVoteButton extends VoteButton {
  DownVoteButton({
    Key key,
    @required VoteAnimationService animationService,
    bool disabled,
    double width,
    double height,
  }) : super(
          key: key,
          type: VoteButtonType.down,
          disabled: disabled,
          animationService: animationService,
          width: width,
          height: height,
        );

  @override
  _DownVoteButtonState createState() {
    return _DownVoteButtonState();
  }
}

class _DownVoteButtonState extends State<DownVoteButton>
    with
        TickerProviderStateMixin,
        SizedVoteButton,
        VoteButtonAnimationIntegration,
        VoteButtonColorAnimation,
        VoteButtonRotateAnimation {
  @override
  void initState() {
    super.initState();
    widget.animationService.addListener(widget.type, onStateChange);
  }

  @override
  Color getColorByAnimation(VoteAnimation voteAnimation) {
    if(voteAnimation == VoteAnimation.vote)
      return downVotedColor;

    return super.getColorByAnimation(voteAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return buildRotatingAnimation(
      child: buildColorAnimation(
        builder: (context, color) {
          return buildSized(
            child: IconButton(
              iconSize: iconSize,
              padding: EdgeInsets.all(0.0),
              icon: Icon(Icons.remove_circle_outline),
              color: color,
              onPressed: !widget.disabled
                  ? () => widget.animationService.voteItem(widget.type.toVote())
                  : null,
              disabledColor: disabledColor,
            ),
          );
        }
      ),
    );
  }
}
