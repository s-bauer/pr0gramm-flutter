import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pr0gramm/views/vote/vote_button.dart';

mixin SizedVoteButton<T extends VoteButton> on State<T> {
  Widget buildSized({Widget child}) {
    if (!widget.isSized) return child;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: child,
    );
  }

  double get iconSize => widget.isSized ? min(widget.height, widget.width) : 24;
}
