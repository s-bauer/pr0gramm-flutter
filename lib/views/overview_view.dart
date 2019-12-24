import 'package:flutter/material.dart';
import 'package:pr0gramm/views/overview_grid.dart';
import 'package:pr0gramm/views/widgets/scaffold.dart';

class OverviewView extends StatelessWidget {
  OverviewView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(body: OverviewGrid());
  }
}
