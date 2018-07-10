import 'dart:async';
import 'package:flutter/material.dart';
import 'data/newActivityList.dart';
import 'addActivity.dart';
import 'customWidgets.dart';
import 'sportsIcons.dart';
import 'customExpansionPanel.dart';
import 'fileManager.dart';

class ExpansionPanelItem {
  ExpansionPanelItem({this.isExpanded, this.header, this.body, this.icon});
  bool isExpanded;
  final String header;
  final Widget body;
  final IconData icon;
}

class NewActivityScreen extends StatefulWidget {
  @override
  _NewActivityScreenState createState() => _NewActivityScreenState();
}

class _NewActivityScreenState extends State<NewActivityScreen> {
  Future<bool> isActive(String name) async {
    Map<String, dynamic> contents = await FileManager.readFile('exercise.json');
    List<String> keys = contents.keys;
    bool matches = false;
    keys.forEach((key) {
      if (key == name) matches = true;
    });
    return matches;
  }

  List<ExpansionPanelItem> items = [
    ExpansionPanelItem(
      isExpanded: false,
      header: 'Common Exercises',
      icon: SportsIcons.jumping_jacks,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: commonList,
        ),
      ),
    ),
    ExpansionPanelItem(
      isExpanded: false,
      header: 'Sports',
      icon: SportsIcons.tennis,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: sportsList,
        ),
      ),
    ),
    ExpansionPanelItem(
      isExpanded: false,
      header: 'Gym Exercises',
      icon: SportsIcons.exercise_bike,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: gymList,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: darkMode ? Colors.grey[800] : Colors.blue,
        title: const Text(
          'New Exercise',
          style: const TextStyle(
              height: 1.2,
              fontFamily: 'Renner*',
              fontSize: 20.0,
              fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 8.0),
              child: Text(
                'Packages',
                style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 180.0,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(4.0, 16.0, 4.0, 24.0),
                scrollDirection: Axis.horizontal,
                children: packageList,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
              child: Text(
                'Tasks',
                style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: CustomExpansionPanelList(
                expansionCallback: (index, isExpanded) {
                  setState(() {
                    items[index].isExpanded = !items[index].isExpanded;
                  });
                },
                children: items.map((ExpansionPanelItem item) {
                  return ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return FlatButton(
                        child: Container(
                          constraints: const BoxConstraints(
                            minHeight: 72.0,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: darkMode
                                    ? Colors.blueGrey[700]
                                    : Colors.blue,
                                child: Icon(
                                  item.icon,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    item.header,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      height: 1.2,
                                      fontFamily: 'Renner*',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              CustomExpandIcon(isExpanded),
                            ],
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            item.isExpanded = !item.isExpanded;
                          });
                        },
                      );
                    },
                    body: item.body,
                    isExpanded: item.isExpanded,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Package extends StatelessWidget {
  Package({
    @required this.icon,
    @required this.name,
    @required this.description,
    this.packageTasks,
  });
  final IconData icon;
  final String name;
  final String description;
  final List<Task> packageTasks;
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final double width = MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      constraints: BoxConstraints(
        minWidth: width / 5 + 96.0,
      ),
      child: RaisedButton(
        elevation: darkMode ? 0.0 : 2.0,
        highlightElevation: darkMode ? 0.0 : 8.0,
        color: darkMode ? Colors.grey[850] : Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            FadingPageRoute(
              builder: (context) => AddActivityScreen(
                    icon: icon,
                    name: name,
                    description: description,
                    packageTasks: packageTasks ?? [],
                  ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 64.0,
                width: 64.0,
                child: Hero(
                  tag: name,
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
            ],
          ),
        ),
      ),
    );
  }
}

class Task extends StatelessWidget {
  const Task({
    @required this.icon,
    @required this.name,
    @required this.description,
  });

  final IconData icon;
  final String name;
  final String description;

  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return FlatButton(
      child: Container(
        height: 56.0,
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 32.0,
              width: 32.0,
              child: Hero(
                tag: name,
                child: FittedBox(
                  child: Icon(
                    icon,
                    color: darkMode ? Colors.lightBlue : Colors.blue,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(name),
            ),
          ],
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          FadingPageRoute(
            builder: (context) => AddActivityScreen(
                  icon: icon,
                  name: name,
                  description: description,
                ),
          ),
        );
      },
    );
  }
}
