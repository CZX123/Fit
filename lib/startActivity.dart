import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'fileManager.dart';
import 'addActivity.dart';
import 'customWidgets.dart';
import 'newActivity.dart';

class StartActivityScreen extends StatelessWidget {
  StartActivityScreen({
    this.icon: Icons.help,
    this.color,
    @required this.name,
    this.description,
    this.packageTasks,
  });

  final IconData icon;
  final Color color;
  final String name;
  final String description;
  final List<Package> packageTasks;

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final Color actualColor =
        color ?? (darkMode ? Colors.lightBlue : Colors.blue);
    return new Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.white,
      body: new SingleChildScrollView(
        padding: new EdgeInsets.fromLTRB(
            0.0, MediaQuery.of(context).padding.top + 4.0, 0.0, 16.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: new BackButton(),
                ),
                new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 16.0),
                  child: new SizedBox(
                    height: 96.0,
                    width: 96.0,
                    child: new Hero(
                      tag: name + 'a',
                      child: new FittedBox(
                        child: new Icon(
                          icon,
                          color: actualColor,
                        ),
                      ),
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: new PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Edit') {
                        Navigator.push(
                          context,
                          new FadingPageRoute(
                            builder: (context) => new AddActivityScreen(
                                  icon: icon,
                                  name: name,
                                  description: description ??
                                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                  packageTasks: packageTasks ?? [],
                                  updateActivity: true,
                                ),
                          ),
                        );
                      } else if (value == 'Remove') {
                        FileManager
                            .removeFromFile('exercise.json', name)
                            .then((file) {
                          DynamicTheme
                              .of(context)
                              .setBrightness(Theme.of(context).brightness);
                          Navigator.pop(context);
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuItem<String>>[
                        new PopupMenuItem<String>(
                          value: 'Edit',
                          child: new Row(
                            children: <Widget>[
                              new Icon(Icons.edit),
                              new SizedBox(
                                width: 16.0,
                              ),
                              const Text('Edit'),
                            ],
                          ),
                        ),
                        new PopupMenuItem<String>(
                          value: 'Remove',
                          child: new Row(
                            children: <Widget>[
                              new Icon(Icons.delete),
                              new SizedBox(
                                width: 16.0,
                              ),
                              const Text('Remove'),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              ],
            ),
            new Text(
              name,
              textAlign: TextAlign.center,
              style: new TextStyle(
                height: 1.2,
                fontFamily: 'Renner*',
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
