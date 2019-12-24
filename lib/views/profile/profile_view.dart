import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/profile_info.dart';
import 'package:pr0gramm/views/profile/widgets/profile_info_bar.dart';
import 'package:pr0gramm/views/profile/widgets/profile_tab_bar.dart';
import 'package:pr0gramm/views/profile/widgets/profile_upload_overview.dart';

class ProfileView extends StatefulWidget {
  final ProfileInfo info;

  ProfileView({Key key, @required this.info}) : super(key: key);

  @override
  _ProfileViewState createState() {
    return _ProfileViewState();
  }
}

class _ProfileViewState extends State<ProfileView> {
  bool showUploads = true;

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
    return Column(
      children: <Widget>[
        ProfileInfoBar(
          info: widget.info,
        ),
        ProfileTabBar(
          showUploadsHandler: onShowUploads,
          showCommentsHandler: onShowComments,
          commentCount: widget.info.commentCount,
          uploadCount: widget.info.uploadCount,
          tagCount: widget.info.tagCount,
        ),
        ProfileUploadOverview(user: widget.info.user.name),
      ],
    );
  }

  void onShowUploads() {
    if (!showUploads) {
      setState(() {
        showUploads = true;
      });
    }
  }

  void onShowComments() {
    if (showUploads)
      setState(() {
        showUploads = true;
      });
  }
}
