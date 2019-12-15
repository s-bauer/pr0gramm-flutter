import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/profile_info.dart';
import 'package:pr0gramm/services/initialization_service.dart';

class GlobalInherited extends StatefulWidget {
  final Widget child;
  final InitializationResult initResult;

  GlobalInherited({Key key, this.child, this.initResult}) : super(key: key);

  static GlobalInheritedData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlobalInheritedData>();
  }

  @override
  State<StatefulWidget> createState() => _GlobalInheritedState(initResult);
}

class _GlobalInheritedState extends State<GlobalInherited> {
  final InitializationResult initResult;

  ProfileInfo profile;
  bool isLoggedIn;
  String username;

  _GlobalInheritedState(this.initResult) {
    isLoggedIn = initResult.loggedIn;
    profile = initResult.profile;
    username = initResult.username;
  }

  void onStatusChange(bool newLoggedIn, ProfileInfo newProfile) {
    setState(() {
      isLoggedIn = newLoggedIn;
      profile = newProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalInheritedData(
      child: widget.child,
      isLoggedIn: isLoggedIn,
      profile: profile,
      username: username,
      onStatusChange: onStatusChange,
    );
  }
}

class GlobalInheritedData extends InheritedWidget {
  final ProfileInfo profile;
  final bool isLoggedIn;
  final String username;

  final Function(bool, ProfileInfo) onStatusChange;

  GlobalInheritedData({
    Key key,
    this.profile,
    this.isLoggedIn,
    this.onStatusChange,
    this.username,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(GlobalInheritedData oldWidget) {
    return true;
  }
}