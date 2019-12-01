import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pr0gramm/api/apiClient.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/itemApi.dart';
import 'package:pr0gramm/api/profileApi.dart';
import 'package:pr0gramm/data/sharedPrefKeys.dart';
import 'package:pr0gramm/widgets/inherited.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'loginView.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future _initFuture;
  var _items = List<Item>();
  Future _workingTask;

  Future initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(SharedPrefKeys.Token) &&
          prefs.containsKey(SharedPrefKeys.MeToken) &&
          prefs.containsKey(SharedPrefKeys.UserName)) {
        final apiClient = ApiClient();

        final token = prefs.getString(SharedPrefKeys.Token);
        final meToken = prefs.getString(SharedPrefKeys.MeToken);
        apiClient.setToken(token, meToken);

        final username = prefs.getString(SharedPrefKeys.UserName);

        final api = ProfileApi();
        final profile = await api.getProfileInfo(name: username, flags: 15);

        MyInherited.of(context).onStatusChange(true, profile);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<Item> getItem(int index) async {
    final itemApi = ItemApi();

    while (true) {
      try {
        if (index < _items.length) return _items[index];

        if (_workingTask != null) {
          await _workingTask;
          continue;
        }

        int older;
        if (_items.isNotEmpty) older = _items.last.promoted;

        _workingTask = itemApi.getItems(
          promoted: true,
          flags: 9,
          older: older,
        );
        var getItemsResponse = await _workingTask;
        _workingTask = null;

        _items.addAll(getItemsResponse.items);
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  void logOut() {
    final apiClient = ApiClient();
    apiClient.logout();

    MyInherited.of(context).onStatusChange(false, null);
  }

  @override
  Widget build(BuildContext context) {
    if (_initFuture == null) _initFuture = initialize();

    final isLoggedIn = MyInherited.of(context).isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: Drawer(),
      body: Center(
        child: isLoggedIn ? buildProfile() : buildLoginButton(),
      ),
    );
  }

  FutureBuilder buildLoginButton() {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return RaisedButton(
            child: const Text("Login"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            },
          );

        return CircularProgressIndicator();
      },
    );
  }

  Widget buildProfile() {
    var profile = MyInherited.of(context).profile;

    return GridView.builder(
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        return FutureBuilder<Item>(
          future: getItem(index),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return GestureDetector(
                child: Image.network(
                    "https://thumb.pr0gramm.com/${snapshot.data.thumb}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailView(item: snapshot.data)),
                  );
                },
              );

            return CircularProgressIndicator();
          },
        );
      },
    );

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text("Welcome ${profile.user.name}"),
        RaisedButton(
          child: Text("Logout"),
          onPressed: logOut,
        )
      ],
    );
  }
}

class DetailView extends StatefulWidget {
  final Item item;

  DetailView({Key key, this.item}) : super(key: key);

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    if (widget.item.image.endsWith(".mp4"))
      _controller = VideoPlayerController.network(
          "https://vid.pr0gramm.com/${widget.item.image}")
        ..initialize().then((_) {
          _controller.play();
          _controller.setLooping(true);
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item.image.endsWith(".mp4"))
      return Scaffold(
        backgroundColor: Colors.black45,
        appBar: AppBar(
          title: Text("Top"),
        ),
        body: Center(
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (_controller.value.isPlaying)
                    _controller.pause();
                  else
                    _controller.play();
                },
                child: _controller?.value?.initialized ?? false
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      );

    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text("Post"),
      ),
      body: Image.network("https://img.pr0gramm.com/${widget.item.image}"),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
