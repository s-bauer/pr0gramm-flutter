import 'package:flutter/widgets.dart';
import 'package:pr0gramm/entities/enums/vote_button_type.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';

abstract class VoteButton extends StatefulWidget {
  final VoteAnimationService animationService;
  final VoteButtonType type;
  final bool disabled;
  final double height;
  final double width;

  bool get isSized => height != null && width != null;

  VoteButton({
    Key key,
    @required this.type,
    @required this.animationService,
    this.disabled = false,
    this.height,
    this.width,
  }) : super(key: key);
}
