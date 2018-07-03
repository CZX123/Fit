import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'customWidgets.dart';
import 'startActivity.dart';
import 'sportsIcons.dart';

List<Activity> activeActivityList = [
  new Activity(
    icon: SportsIcons.push_up,
    name: 'Push Ups',
    completionState: 'Completed',
  ),
  new Activity(
    icon: SportsIcons.cycling,
    name: 'Cycling',
    completionState: 'Pending',
  ),
  new Activity(
    icon: SportsIcons.running,
    name: 'NAPFA',
    completionState: 'Incomplete',
  ),
];

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({
    @required this.counter,
  });
  final int counter;

  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final Orientation orientation = MediaQuery.of(context).orientation;
    double height = MediaQuery.of(context).size.height;
    double windowTopPadding = MediaQuery.of(context).padding.top;
    double containerHeight = 175.0;
    return new SingleChildScrollView(
      child: new Stack(
        children: <Widget>[
          new Positioned(
            top: 0.0,
            right: 0.0,
            left: 0.0,
            height: containerHeight + windowTopPadding,
            child: new Container(
              color: darkMode ? Colors.grey[900] : Colors.blue,
            ),
          ),
          new Positioned(
            top: containerHeight + windowTopPadding,
            right: 0.0,
            left: 0.0,
            height: (height - containerHeight < 300 - 48.0)
                ? 300.0
                : height - containerHeight - 48.0,
            child: new DecoratedBox(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: <Color>[
                    darkMode ? Colors.grey[900] : Colors.blue,
                    darkMode ? Colors.grey[900] : Colors.grey[50],
                  ],
                ),
              ),
            ),
          ),
          new Container(
            color: darkMode ? Colors.grey[900] : null,
            constraints: new BoxConstraints(
              minHeight: height - 48.0,
            ),
            padding: new EdgeInsets.only(top: windowTopPadding),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
                  child: new Text(
                    'Exercise',
                    style: new TextStyle(
                      height: 1.2,
                      color: Colors.white,
                      fontFamily: 'Renner*',
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
                  child: new Row(
                    children: <Widget>[
                      new Icon(
                        SportsIcons.footsteps,
                        size: 64.0,
                        color: Colors.white,
                        semanticLabel: 'Footstep',
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              '$counter',
                              style: new TextStyle(
                                fontFamily: 'Renner*',
                                color: Colors.white,
                                fontSize: 56.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            new Text(
                              counter == 1 ? ' STEP' : ' STEPS',
                              style: new TextStyle(
                                color: Colors.white70,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 32.0),
                  child: new Grid(
                    children: activeActivityList,
                    columnCount: orientation == Orientation.portrait ? 2 : 3,
                  ),
                ),
                new Container(),
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
    this.icon: Icons.help,
    this.image,
    @required this.name,
    @required this.completionState,
  });
  final IconData icon;
  final String image;
  final String name;
  final String completionState;
  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    Orientation orientation = MediaQuery.of(context).orientation;
    double width = MediaQuery.of(context).size.width /
            ((orientation == Orientation.portrait) ? 2 : 3) -
        12.0;
    return new Container(
      height: width / ((orientation == Orientation.portrait) ? 1.1 : 1.3),
      width: width,
      margin: const EdgeInsets.all(4.0),
      child: new RaisedButton(
        elevation: darkMode ? 0.0 : 2.0,
        color: darkMode ? Colors.grey[850] : Colors.white,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new StartActivityScreen(
                      icon: icon,
                      image: image,
                      color: darkMode ? Colors.lightBlue : Colors.blue,
                      name: name,
                    ),
              ));
        },
        child: new Container(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new SizedBox(
                height: 64.0,
                width: 64.0,
                child: new Hero(
                  tag: name + 'a',
                  child: (image != null)
                      ? new Image.asset(
                          image,
                          fit: BoxFit.contain,
                        )
                      : new FittedBox(
                          child: new Icon(
                            icon,
                            color: darkMode ? Colors.lightBlue : Colors.blue,
                          ),
                        ),
                ),
              ),
              new Text(
                name,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  height: 1.2,
                  fontFamily: 'Renner*',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              new Transform.translate(
                offset: const Offset(0.0, -6.0),
                child: new CompletionState(completionState),
              ),
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
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    if (completionState == 'Completed') {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconTheme(
            data: new IconThemeData(
              color: darkMode ? Colors.green[400] : Colors.green,
            ),
            child: new Icon(Icons.check_circle),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: new Text(
              'Completed',
              style: new TextStyle(
                color: darkMode ? Colors.green[400] : Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    } else if (completionState == 'Pending') {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconTheme(
            data: new IconThemeData(
              color: darkMode ? Colors.purple[300] : Colors.purple,
            ),
            child: new Icon(Icons.timer),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: new Text(
              'Pending',
              style: new TextStyle(
                color: darkMode ? Colors.purple[300] : Colors.purple,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    } else {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconTheme(
            data: new IconThemeData(
              color: darkMode ? Colors.redAccent[200] : Colors.red,
            ),
            child: new Icon(Icons.warning),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: new Text(
              'Incomplete',
              style: new TextStyle(
                color: darkMode ? Colors.redAccent[200] : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }
  }
}
