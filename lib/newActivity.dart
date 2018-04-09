import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Package extends StatelessWidget {
  const Package({
    this.icon: const Icon(Icons.help),
    this.image,
    this.color: Colors.blue,
    @required this.name,
    @required this.onPressed,
  });
  final Icon icon;
  final ImageProvider<dynamic> image;
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
              ? new Image(
                  height: 64.0,
                  image: image,
                )
              : new IconTheme(
                data: new IconThemeData(
                  size: 64.0,
                  color: color,
                ),
                child: icon,
                ),
            new Text(
              name,
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
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
    this.icon: const Icon(Icons.help),
    this.image,
    @required this.name,
    @required this.onPressed,
  });

  final Icon icon;
  final ImageProvider<dynamic> image;
  final String name;
  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return new FlatButton(
      onPressed: onPressed,
      child: new Container(
        //padding: new EdgeInsets.symmetric(horizontal: 16.0),
        child: new Row(
          children: <Widget>[
            (image != null)
              ? new Image(
                  height: 28.0,
                  image: image,
                )
              : new IconTheme(
                data: new IconThemeData(
                  size: 28.0,
                  color: Theme.of(context).primaryColor,
                ),
                child: icon,
              ),
            new Padding(
              padding: new EdgeInsets.only(left: 16.0),
              child: new Text(
                name,
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewActivityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final double width = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('New Activity'),
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
              childAspectRatio: (orientation == Orientation.portrait) ? 1.4 : 1.6,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              children: <Widget>[
                new Package(
                  image: new AssetImage('assets/icons/running.webp'),
                  name: 'NAPFA',
                  onPressed: () {},
                ),
                new Package(
                  image: new AssetImage('assets/icons/6-pack.webp'),
                  name: '6-Pack',
                  onPressed: () {},
                ),
              ],
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
            sliver: new SliverGrid(
              delegate: new SliverChildListDelegate(
                <Widget>[
                  new Task(
                    image: new AssetImage('assets/icons/crunches.webp'),
                    name: 'Crunches',
                    onPressed: () {},
                  ),
                  new Task(
                    image: new AssetImage('assets/icons/cycling.webp'),
                    name: 'Cycling',
                    onPressed: () {},
                  ),
                  new Task(
                    image: new AssetImage('assets/icons/planking.webp'),
                    name: 'Planking',
                    onPressed: () {},
                  ),
                  new Task(
                    image: new AssetImage('assets/icons/pushup.webp'),
                    name: 'Push Ups',
                    onPressed: () {},
                  ),
                  new Task(
                    image: new AssetImage('assets/icons/running.webp'),
                    name: 'Running',
                    onPressed: () {},
                  ),
                  new Task(
                    image: new AssetImage('assets/icons/situp.webp'),
                    name: 'Situps',
                    onPressed: () {},
                  ),
                  new Task(
                    image: new AssetImage('assets/icons/walking.webp'),
                    name: 'Walking',
                    onPressed: () {},
                  ),
                ],
              ),
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                childAspectRatio: width / (orientation == Orientation.portrait ? 2 : 3) / 48.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
