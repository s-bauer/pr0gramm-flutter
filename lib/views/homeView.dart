import 'package:flutter/material.dart';

import 'package:pr0gramm/api/apiClient.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/services/initializeService.dart';
import 'package:pr0gramm/services/itemProvider.dart';
import 'package:pr0gramm/services/imageProvider.dart' as imgProv;
import 'package:pr0gramm/views/widgets/postPage.dart';
import 'package:pr0gramm/widgets/inherited.dart';

import 'loginView/loginView.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future _initFuture;
  int _gridRefreshKey = 0;

  final ItemProvider _itemProvider = ItemProvider();
  final imgProv.ImageProvider _imageProvider = imgProv.ImageProvider();

  @override
  void initState() {
    super.initState();
    _initFuture = InitializeService().initialize(context);
  }

  void logOut() {
    final apiClient = ApiClient();
    apiClient.logout();
    MyInherited.of(context).onStatusChange(false, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top"),
      ),
      drawer: Drawer(),
      body: Center(
        child: buildProfile(),
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

  Future refreshItems() async {
    setState(() {
      _gridRefreshKey++;
    });
  }

  Widget buildProfile() {
    final page = RefreshIndicator(
      onRefresh: refreshItems,
      child: GridView.builder(
        key: Key(_gridRefreshKey.toString()),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) {
          return FutureBuilder<Item>(
            future: _itemProvider.getItem(index),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return GestureDetector(
                  child: new FutureBuilder(
                    future: _imageProvider.getThumb(snapshot.data),
                    builder: (context, snap) {
                      if(snap.hasData)
                        return Image.memory(snap.data);

                      return Container(color: Colors.red);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostPage(index: index)),
                    );
                  },
                );

              return CircularProgressIndicator();
            },
          );
        },
      ),
    );

    return FutureBuilder(
      future: _initFuture,
        builder: (context, snap) {
          if(snap.connectionState == ConnectionState.done)
            return page;

          return Container();
        },
    );
  }
}

