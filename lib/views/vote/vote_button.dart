import 'package:flutter/widgets.dart';
import 'package:pr0gramm/entities/enums/vote_button_type.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';

abstract class VoteButton extends StatefulWidget {
  final VoteAnimationService animationService;
  final VoteButtonType type;
  final bool disabled;

  VoteButton({
    Key key,
    @required this.type,
    this.disabled = false,
    this.animationService,
  }) : super(key: key);
}