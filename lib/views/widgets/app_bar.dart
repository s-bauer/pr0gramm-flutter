import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/search_arguments.dart';
import 'package:pr0gramm/views/overview_view.dart';
import 'package:pr0gramm/views/widgets/scaffold.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(FeedInherited.of(context).feed.feedDetails.name),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => openSearch(context),
        )
      ],
    );
  }

  void openSearch(BuildContext context) {
    StartSearchNotification().dispatch(context);
  }

  @override
  final Size preferredSize = Size.fromHeight(kToolbarHeight);
}

class MySearchBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _MySearchBarState createState() => _MySearchBarState();

  @override
  final Size preferredSize = Size.fromHeight(kToolbarHeight);
}

class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController _controller = new TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = UnderlineInputBorder(
        borderSide: BorderSide(
          width: 2,
          color: Colors.white,
        )
    );

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => closeSearch(context),
      )
      ,
      title: TextField(
        controller: _controller,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          isDense: true,
          enabledBorder: border,
          focusedBorder: border,
          hintText: "Suchen",
          hintStyle: TextStyle(
            color: Colors.white70,
          )
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => doSearch(context),
        )
      ],
    );
  }

  void closeSearch(BuildContext context) {
    EndSearchNotification().dispatch(context);
  }

  void doSearch(BuildContext context) {
    EndSearchNotification().dispatch(context);

    final args = new SearchArguments(
      searchString: _controller.text,
      baseType: FeedInherited.of(context).feed.feedType,
    );
    Navigator.pushReplacementNamed(context, "/search", arguments: args);
  }
}
