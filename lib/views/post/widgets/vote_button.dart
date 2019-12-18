import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/enums/vote.dart';
import 'package:pr0gramm/entities/enums/voteButtonType.dart';
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

class _VoteButtonState extends State<VoteButton>
    with SingleTickerProviderStateMixin {
  Color color;
  IconData icon;

  onStateChange(VoteAnimation voteAnimation) {
    setState(() {
      color = _getColorByAnimation(voteAnimation);
      if (widget.type == VoteButtonType.favorite) {
        icon = voteAnimation == VoteAnimation.voted ||
                voteAnimation == VoteAnimation.voteUnfocused ||
                voteAnimation == VoteAnimation.voteFocused
            ? Icons.favorite
            : Icons.favorite_border;
      }
    });
  }

  @override
  void initState() {
    widget.animationService.addButtonStateListener(widget.type, onStateChange);
    icon = widget.type == VoteButtonType.up
        ? Icons.add_circle_outline
        : widget.type == VoteButtonType.down
            ? Icons.remove_circle_outline
            : Icons.favorite_border;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _baseUpVoteButton(color: color ?? focusedColor, icon: icon);
  }

  IconButton _baseUpVoteButton({Color color, IconData icon}) => IconButton(
        icon: Icon(icon),
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
}

const focusedColor = Color(0x99FFFFFF);
const unfocusedColor = Color(0x66FFFFFF);
const disabledColor = Color(0x33FFFFFF);
const votedColor = Color(0xFFEE4D2E);
const downVotedColor = Color(0xFFFFFFFF);

const voteAnimationDuration = Duration(milliseconds: 500);
