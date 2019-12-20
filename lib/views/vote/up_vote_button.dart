import 'package:flutter/material.dart';
import 'package:pr0gramm/constants/vote_constants.dart';
import 'package:pr0gramm/entities/enums/vote_button_type.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/views/vote/sized_vote_button.dart';
import 'package:pr0gramm/views/vote/vote_button.dart';
import 'package:pr0gramm/views/vote/vote_button_animation_integration.dart';
import 'package:pr0gramm/views/vote/vote_button_color_animation.dart';
import 'package:pr0gramm/views/vote/vote_button_rotate_animation.dart';

class UpVoteButton extends VoteButton {
  UpVoteButton({
    Key key,
    @required VoteAnimationService animationService,
    bool disabled,
    double width,
    double height,
  }) : super(
          key: key,
          type: VoteButtonType.up,
          disabled: disabled,
          animationService: animationService,
          width: width,
          height: height,
        );

  @override
  _UpVoteButtonState createState() {
    return _UpVoteButtonState();
  }
}

class _UpVoteButtonState extends State<UpVoteButton>
    with
        TickerProviderStateMixin,
        SizedVoteButton,
        VoteButtonAnimationIntegration<UpVoteButton>,
        VoteButtonColorAnimation<UpVoteButton>,
        VoteButtonRotateAnimation<UpVoteButton> {
  @override
  void initState() {
    super.initState();
    widget.animationService.addButtonStateListener(widget.type, onStateChange);
  }

  @override
  Widget build(BuildContext context) {
    return buildRotatingButton(
      button: buildSized(
        child: IconButton(
          iconSize: iconSize,
          padding: EdgeInsets.all(0.0),
          icon: Icon(Icons.add_circle_outline),
          color: color,
          onPressed: !widget.disabled
              ? () => widget.animationService.voteItem(widget.type.toVote())
              : null,
          disabledColor: disabledColor,
        ),
      ),
    );
  }
}
