import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/views/vote/vote_button.dart';

mixin VoteButtonAnimationIntegration<T extends VoteButton>
    on State<T>, TickerProvider {
  onStateChange(VoteAnimation voteAnimation);

  @override
  void dispose() {
    super.dispose();
    widget.animationService.disposeStateListener(widget.type);
  }
}
