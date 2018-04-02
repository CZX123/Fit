import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({
    @required this.counter,
    @required this.orientation,
  });
  final int counter;
  final Orientation orientation;
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: const Alignment(0.0, -1.0),
          end: const Alignment(0.0, 0.6),
          colors: <Color>[
            const Color(0xFF2196F3),
            const Color(0x112196F3)
          ],
        ),
      ),
      child: new CustomScrollView(
        slivers: <Widget>[
          new SliverPadding(
            padding: new EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
            sliver: new SliverToBoxAdapter(
              child: new Column(
                children: <Widget>[
                  new Text(
                    '$counter',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 56.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  new Text(
                    counter == 1 ? 'Step' : 'Steps',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          new SliverPadding(
            padding: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
            sliver: new SliverGrid.count(
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: (orientation == Orientation.portrait) ? 1.1 : 1.3,
              children: <Widget>[
                new Activity(
                  image: new AssetImage('assets/icons/pushup.webp'),
                  name: 'Push Ups',
                  completionState: 'Completed',
                  onPressed: () {},
                ),
                new Activity(
                  image: new AssetImage('assets/icons/cycling.webp'),
                  name: 'Cycling',
                  completionState: 'Pending',
                  onPressed: () {},
                ),
                new Activity(
                  image: new AssetImage('assets/icons/running.webp'),
                  name: 'Running',
                  completionState: 'Incomplete',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Activity extends StatelessWidget {
  const Activity({
    this.icon: const Icon(Icons.help),
    this.image,
    @required this.name,
    @required this.completionState,
    @required this.onPressed,
  });
  final Icon icon;
  final ImageProvider<dynamic> image;
  final String name;
  final String completionState;
  final VoidCallback onPressed;
  @override
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
                  color: Theme.of(context).primaryColor,
                ),
                child: icon,
                ),
            new Text(
              name,
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.black87,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                ),
            ),
            new CompletionState(completionState),
          ],
        ),
      ),
    );
  }
}

class CompletionState extends StatelessWidget {
  const CompletionState(this.completionState);
  final String completionState;
  @override
  Widget build(BuildContext context) {
    if (completionState == 'Completed') {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconTheme(
            data: new IconThemeData(
              color: Colors.green,
            ),
            child: new Icon(Icons.check_circle),
          ),
          new Padding(
            padding: new EdgeInsets.only(left: 4.0),
            child: new Text(
              'Completed',
              style: new TextStyle(
                color: Colors.green,
              ),
            ),
          ),
        ],
      );
    }
    else if (completionState == 'Pending') {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconTheme(
            data: new IconThemeData(
              color: Colors.purple,
            ),
            child: new Icon(Icons.timer),
          ),
          new Padding(
            padding: new EdgeInsets.only(left: 4.0),
            child: new Text(
              'Pending',
              style: new TextStyle(
                color: Colors.purple,
              ),
            ),
          ),
        ],
      );
    }
    else {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconTheme(
            data: new IconThemeData(
              color: Colors.red,
            ),
            child: new Icon(Icons.warning),
          ),
          new Padding(
            padding: new EdgeInsets.only(left: 4.0),
            child: new Text(
              'Incomplete',
              style: new TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    }
  }
}
