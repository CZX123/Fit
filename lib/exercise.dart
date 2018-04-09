import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

List<Activity> activityList = [
  new Activity(
    image: 'assets/icons/pushup.webp',
    name: 'Push Ups',
    completionState: 'Completed',
    onPressed: () {},
  ),
  new Activity(
    image: 'assets/icons/cycling.webp',
    name: 'Cycling',
    completionState: 'Pending',
    onPressed: () {},
  ),
  new Activity(
    image: 'assets/icons/running.webp',
    name: 'Running',
    completionState: 'Incomplete',
    onPressed: () {},
  ),
];


class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({
    @required this.counter,
  });
  final int counter;

  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    double minHeight = MediaQuery.of(context).size.height;
    double windowTopPadding = MediaQuery.of(context).padding.top;
    // double width = MediaQuery.of(context).size.width;
    return new Container(
      padding: new EdgeInsets.only(top: windowTopPadding),
      constraints: new BoxConstraints(
        minHeight: minHeight - 56.0,
      ),
      child: new Column(
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 40.0),
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
          new Container(
            padding: new EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 32.0),
            child: new Grid(
              children: activityList,
              columnCount: orientation == Orientation.portrait ? 2 : 3,
            ),
          ),
        ],
      ),
    );
  }
}


class Grid extends StatelessWidget {

  const Grid({
    @required this.children,
    this.columnCount: 2,
  });

  final List<Widget> children;
  final int columnCount;

  List<Widget> _buildGrid() {

    List<Widget> rows = [];
    List<Widget> columns = [];
    int _columnCount = columnCount;
    int _rowCount = (children.length / columnCount).ceil();
    int _lastRowColumnCount = children.length % columnCount;

    for (int i = 0; i < _rowCount; i++) {
      columns = [];
      if (i == _rowCount - 1 && _lastRowColumnCount != 0) _columnCount = _lastRowColumnCount;

      for (int j = 0; j < _columnCount; j++) {
        int index = i * columnCount + j;
        columns.add(children[index]);
      }

      rows.add(
        new Row(
          children: columns,
        ),
      );
    }

    return rows;
  }

  Widget build(BuildContext context) {
    return new Column(
      children: _buildGrid(),
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
  final String image;
  final String name;
  final String completionState;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double width = MediaQuery.of(context).size.width / ((orientation == Orientation.portrait) ? 2 : 3) - 12.0;
    return new Container(
      height: width / ((orientation == Orientation.portrait) ? 1.1 : 1.3),
      width: width,
      margin: new EdgeInsets.all(4.0),
      child: new RaisedButton(
        color: Colors.white,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: new Container(
          padding: new EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              (image != null)
                ? new Image.asset(
                  image,
                  height: 64.0,
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
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              new CompletionState(completionState),
            ],
          ),
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
