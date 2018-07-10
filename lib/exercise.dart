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
    var initializationSettingsAndroid = AndroidInitializationSettings('icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);
  }

  List<Activity> getActivities(Map<String, dynamic> contents) {
    List<Activity> activities = [];
    contents.forEach((key, value) {
      IconData icon = getIconFromName(key);
      String description = getDescriptionFromName(key);
      if (icon != null) {
        activities.add(
          Activity(
            name: key,
            icon: icon,
            description: description,
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
      return TimeOfDay(
        hour: list[0],
        minute: list[1],
      );
    }).toList();
    List<dynamic> endTimes = value[1].map((list) {
      return TimeOfDay(
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

  String getDescriptionFromName(String name) {
    String description;
    packageList.forEach((package) {
      if (package.name == name) description = package.description;
    });
    if (description != null) return description;
    allTasks.forEach((task) {
      if (task.name == name) description = task.description;
    });
    return description;
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
      MaterialPageRoute(
        builder: (context) => StartActivityScreen(
              name: payload,
              icon: getIconFromName(payload),
              description: getDescriptionFromName(payload),
            ),
      ),
    );
  }

  Future showNotification(String name, bool late) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      name,
      name,
      'Notification for $name exercise',
      color: Colors.blue,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        getId(name),
        late ? 'Oh No!' : 'Heads Up!',
        late
            ? 'You missed your $name exercise. But better late than never!'
            : 'Your $name exercise will begin in 20 mins!',
        platformChannelSpecifics,
        payload: name);
  }

  Widget activities(bool portrait) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return FutureBuilder<Map<String, dynamic>>(
      future: FileManager.readFile(fileName),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.length != 0) {
          return Grid(
            children: getActivities(snapshot.data),
            columnCount: portrait ? 2 : 3,
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Icon(
                Icons.directions_run,
                color: darkMode ? Colors.white70 : Colors.white,
                size: 64.0,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                'Add some new activities',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkMode ? Colors.white70 : Colors.white,
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
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double height = MediaQuery.of(context).size.height;
    double windowTopPadding = MediaQuery.of(context).padding.top;
    double containerHeight = 175.0;
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            right: 0.0,
            left: 0.0,
            height: containerHeight + windowTopPadding,
            child: Container(
              color: darkMode ? Colors.grey[900] : Colors.blue,
            ),
          ),
          Positioned(
            top: portrait
                ? containerHeight - 1 + windowTopPadding
                : windowTopPadding + 128.0,
            right: 0.0,
            left: 0.0,
            bottom: -64.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
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
          Container(
            color: darkMode ? Colors.grey[900] : null,
            constraints: BoxConstraints(
              minHeight: height - 48.0,
            ),
            padding: EdgeInsets.only(top: windowTopPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(portrait ? 16.0 : 72.0, 24.0, portrait ? 16.0 : 72.0, 12.0),
                  child: const Text(
                    'Exercise',
                    style: TextStyle(
                      height: 1.2,
                      color: Colors.white,
                      fontFamily: 'Renner*',
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(portrait ? 16.0 : 72.0, 16.0, portrait ? 16.0 : 72.0, 24.0),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        SportsIcons.footsteps,
                        size: 64.0,
                        color: Colors.white,
                        semanticLabel: 'Footstep',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '$counter',
                              style: const TextStyle(
                                fontFamily: 'Renner*',
                                color: Colors.white,
                                fontSize: 56.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              counter == 1 ? ' STEP' : ' STEPS',
                              style: const TextStyle(
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
                Container(
                  constraints: BoxConstraints(
                    minHeight: portrait
                        ? height / 2
                        : height / 4,
                  ),
                  padding: EdgeInsets.fromLTRB(portrait ? 4.0 : 68.0, 4.0, portrait ? 4.0 : 68.0, 32.0),
                  child: activities(portrait),
                ),
                const SizedBox(),
                const SizedBox(),
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
    @required this.icon,
    @required this.name,
    @required this.completionState,
    @required this.description,
    this.showNotification,
  });
  final IconData icon;
  final String name, completionState, description;
  final Function showNotification;
  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double width =
        portrait ? (screenWidth - 24.0) / 2 : (screenWidth - 160.0) / 3;
    return Container(
      height: width / (portrait ? 1.1 : 1.05),
      width: width,
      margin: const EdgeInsets.all(4.0),
      child: RaisedButton(
        elevation: darkMode ? 0.0 : 2.0,
        highlightElevation: darkMode ? 0.0 : 8.0,
        color: darkMode ? Colors.grey[850] : Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        onPressed: () async {
          String value = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StartActivityScreen(
                    icon: icon,
                    name: name,
                    description: description,
                  ),
            ),
          );
          if (value != null) showNotification(value, false);
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 64.0,
                width: 64.0,
                child: Hero(
                  tag: name + 'a',
                  child: FittedBox(
                    child: Icon(
                      icon,
                      color: darkMode ? Colors.lightBlue : Colors.blue,
                    ),
                  ),
                ),
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.2,
                  fontFamily: 'Renner*',
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Transform.translate(
                offset: const Offset(0.0, -6.0),
                child: CompletionState(completionState),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          iconData,
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            completionState,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
