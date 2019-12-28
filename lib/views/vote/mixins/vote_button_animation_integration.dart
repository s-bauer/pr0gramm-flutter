import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pr0gramm/services/vote_animation_service.dart';
import 'package:pr0gramm/views/vote/buttons/base/vote_button.dart';

mixin VoteButtonAnimationIntegration<T extends VoteButton>
    on State<T>, TickerProvider {

  void onStateChange(VoteAnimation voteAnimation, [bool skipAnimation = false]) {}

  @override
  void dispose() {
    widget.animationService.disposeStateListener(widget.type);
    super.dispose();
  }
}
