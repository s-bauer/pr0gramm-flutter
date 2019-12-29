import 'package:flutter/widgets.dart';
import 'package:pr0gramm/api/profile_api.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/views/profile/profile_view.dart';

class ProfileBuilder {
  static ProfileBuilder instance = new ProfileBuilder._();
  final ProfileApi profileAPi = new ProfileApi();

  ProfileBuilder._();

  Widget buildByRoute(BuildContext context) {
    final String user = ModalRoute.of(context).settings.arguments;
    print(user);
    return ProfileView(
      infoFuture: profileAPi.getProfileInfo(name: user, flags: Flags.sfw),
    );
  }
}
