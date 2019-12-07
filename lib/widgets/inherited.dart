import 'package:flutter/material.dart';
import 'package:pr0gramm/api/dtos/profileInfoResponse.dart';

class MyInherited extends StatefulWidget {
  final Widget child;

  MyInherited({Key key, this.child,}) : super(key: key);

  static MyInheritedData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedData>();
  }

  @override
  State<StatefulWidget> createState() => _MyInheritedState();
}

class _MyInheritedState extends State<MyInherited> {
  ProfileInfoResponse profile;
  bool isLoggedIn = false;

  void onProfileChange(ProfileInfoResponse newValue) {
    setState(() {
      profile = newValue;
    });
  }

  void onStatusChange(bool newLoggedIn, ProfileInfoResponse newProfile) {
    setState(() {
      isLoggedIn = newLoggedIn;
      profile = newProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyInheritedData(
      child: widget.child,
      isLoggedIn: isLoggedIn,
      profile: profile,
      onStatusChange: onStatusChange,
    );
  }
}

class MyInheritedData extends InheritedWidget {
  final ProfileInfoResponse profile;
  final bool isLoggedIn;

  final Function(bool, ProfileInfoResponse) onStatusChange;

  MyInheritedData({
    Key key,
    this.profile,
    this.isLoggedIn,
    this.onStatusChange,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(MyInheritedData oldWidget) {
    return true;
  }
}