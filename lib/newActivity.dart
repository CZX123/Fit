import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'data/newActivityList.dart';

class NewActivityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('New Activity'),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {},
          ),
        ],
      ),
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverPadding(
            padding: new EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 16.0),
            sliver: new SliverToBoxAdapter(
              child: new Text(
                'Packages',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          new SliverPadding(
            padding: new EdgeInsets.all(8.0),
            sliver: new SliverGrid.count(
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
              childAspectRatio: (orientation == Orientation.portrait) ? 1.3 : 1.6,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              children: packageList,
            ),
          ),
          new SliverPadding(
            padding: new EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
            sliver: new SliverToBoxAdapter(
              child: new Text(
                'Tasks',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          new SliverPadding(
            padding: new EdgeInsets.only(bottom: 32.0),
            sliver: new SliverList(
              delegate: new SliverChildBuilderDelegate(
                (context, i) {
                  if (i < taskList.length) return taskList[i];
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class Package extends StatelessWidget {
  const Package({
    this.icon: Icons.help,
    this.image,
    this.color: Colors.blue,
    @required this.name,
    @required this.onPressed,
  });
  final IconData icon;
  final String image;
  final Color color;
  final String name;
  final VoidCallback onPressed;
  Widget build(BuildContext context) {
    return new RaisedButton(
      color: Colors.white,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.all(
          const Radius.circular(8.0),
        ),
      ),
      onPressed: onPressed,
      child: new Container(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            (image != null)
              ? new Image.asset(
                  image,
                  height: 64.0,
                )
              : new Icon(
                  icon,
                  size: 64.0,
                  color: Colors.blue,
                ),
            new Text(
              name,
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Task extends StatelessWidget {

  const Task({
    this.icon: Icons.help,
    this.image,
    @required this.name,
    @required this.onPressed,
  });

  final IconData icon;
  final String image;
  final String name;
  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return new ListTile(
      leading: (image != null)
        ? new Image.asset(image)
        : new Icon(
            icon,
            size: 32.0,
            color: Colors.blue,
          ),
      onTap: onPressed,
      title: new Text(name),
    );
  }
}
