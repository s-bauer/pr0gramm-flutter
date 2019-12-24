import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/profile_info.dart';

class ProfileInfoBar extends StatefulWidget {
  final ProfileInfo info;
  ProfileInfoBar({Key key, @required this.info}) : super(key: key);

  @override
  _ProfileInfoBarState createState() {
    return _ProfileInfoBarState();
  }
}

class _ProfileInfoBarState extends State<ProfileInfoBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row();
  }
}