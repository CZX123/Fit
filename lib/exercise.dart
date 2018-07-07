import 'dart:async';
import 'package:flutter/material.dart';
import 'customWidgets.dart';
import 'startActivity.dart';
import 'sportsIcons.dart';
import 'fileManager.dart';
import './data/newActivityList.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'main.dart';

class ExerciseScreen extends StatefulWidget {
  ExerciseScreen({Key key}) : super(key: key);
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final String fileName = 'exercise.json';

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);
  }

  List<Activity> getActivities(Map<String, dynamic> contents) {
    List<Activity> activities = [];
    contents.forEach((key, value) {
      IconData icon = getIconFromName(key);
      if (icon != null) {
        activities.add(
          new Activity(
            name: key,
            icon: icon,
            completionState: getCompletionState(value),
            showNotification: showNotification,
          ),
        );
      }
    });
    return activities;
  }

  String getCompletionState(dynamic value) {
    TimeOfDay now = TimeOfDay.now();
    List<dynamic> startTimes = value[0].map((list) {
      return new TimeOfDay(
        hour: list[0],
        minute: list[1],
      );
    }).toList();
    List<dynamic> endTimes = value[1].map((list) {
      return new TimeOfDay(
        hour: list[0],
        minute: list[1],
      );
    }).toList();
    if (compareTime(endTimes[endTimes.length - 1], now)) {
      return 'Completed';
    } else {
      for (int i = 0; i < startTimes.length; i++) {
        if (compareTime(startTimes[i], now) && compareTime(now, endTimes[i]))
          return 'In Progress';
        else if (i < startTimes.length - 1 &&
            compareTime(endTimes[i], now) &&
            compareTime(now, startTimes[i + 1])) return 'Pending';
      }
    }
    return 'Pending';
  }

  bool compareTime(TimeOfDay time1, TimeOfDay time2) {
    return time1.hour < time2.hour ||
        time1.hour == time2.hour && time1.minute <= time2.minute;
  }

  IconData getIconFromName(String name) {
    IconData iconData;
    packageList.forEach((package) {
      if (package.name == name) iconData = package.icon;
    });
    if (iconData != null) return iconData;
    allTasks.forEach((task) {
      if (task.name == name) iconData = task.icon;
    });
    return iconData;
  }

  int getId(String name) {
    int id;
    for (int i = 0; i < packageList.length; i++) {
      if (packageList[i].name == name) id = i;
    }
    if (id != null) return id;
    for (int j = 0; j < allTasks.length; j++) {
      if (allTasks[j].name == name) id = packageList.length + j;
    }
    return id;
  }

  Future onSelectNotification(String payload) async {
    await Navigator.push(
      context.ancestorStateOfType(TypeMatcher<MyHomePageState>()).context,
      new MaterialPageRoute(builder: (context) => new StartActivityScreen(
        name: payload,
        icon: getIconFromName(payload),
        color: Theme.of(context).brightness == Brightness.dark ? Colors.lightBlue : Colors.blue,
      )),
    );
  }

  Future showNotification(String name, bool late) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      name,
      name,
      'Notification for $name exercise',
      color: Colors.blue,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        getId(name), late ? 'Oh No!' : 'Heads Up!', late ? 'You missed your $name exercise. But better late than never!' : 'Your $name exercise will begin in 20 mins!', platformChannelSpecifics,
        payload: name);
  }

  Widget activities(Orientation orientation) {
    return new FutureBuilder<Map<String, dynamic>>(
      future: FileManager.readFile(fileName),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.length != 0) {
          return new Grid(
            children: getActivities(snapshot.data),
            columnCount: orientation == Orientation.portrait ? 2 : 3,
          );
        }
        return new Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.center,
          child: new Column(
            children: <Widget>[
              new Icon(
                Icons.directions_run,
                color: Colors.white,
                size: 64.0,
              ),
              new SizedBox(
                height: 16.0,
              ),
              new Text(
                'Add some new activities',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final int counter = 500;
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
            top: orientation == Orientation.landscape ? windowTopPadding + 128.0 : containerHeight - 1 + windowTopPadding,
            right: 0.0,
            left: 0.0,
            bottom: -64.0,
            child: new Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: <Color>[
                    darkMode ? Colors.grey[900] : Colors.blue,
                    darkMode ? Colors.grey[900] : Colors.blue[50],
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
                  constraints: new BoxConstraints(
                    minHeight: orientation == Orientation.landscape ? height / 4 : height / 2,
                  ),
                  padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 32.0),
                  child: activities(orientation),
                ),
                new Container(),
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
    @required this.name,
    @required this.completionState,
    this.showNotification,
  });
  final IconData icon;
  final String name;
  final String completionState;
  final Function showNotification;
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
        highlightElevation: darkMode ? 0.0 : 8.0,
        color: darkMode ? Colors.grey[850] : Colors.white,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        onPressed: () async {
          String value = await Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new StartActivityScreen(
                    icon: icon,
                    color: darkMode ? Colors.lightBlue : Colors.blue,
                    name: name,
                  ),
            ),
          );
          if (value != null) showNotification(value, false);
        },
        child: new Container(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 4.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new SizedBox(
                height: 64.0,
                width: 64.0,
                child: new Hero(
                  tag: name + 'a',
                  child: new FittedBox(
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
                  fontSize: 17.0,
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
    Color color;
    IconData iconData;
    if (completionState == 'Completed') {
      color = darkMode ? Colors.green[400] : Colors.green;
      iconData = Icons.check_circle;
    } else if (completionState == 'Pending') {
      color = darkMode ? Colors.purple[300] : Colors.purple;
      iconData = Icons.timer;
    } else if (completionState == 'In Progress') {
      color = darkMode ? Colors.lightBlue : Colors.blue;
      iconData = Icons.access_time;
    } else {
      color = darkMode ? Colors.redAccent[200] : Colors.red;
      iconData = Icons.warning;
    }
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new IconTheme(
          data: new IconThemeData(
            color: color,
          ),
          child: new Icon(iconData),
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: new Text(
            completionState,
            style: new TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
