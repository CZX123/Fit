import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'fileManager.dart';

class StartActivityScreen extends StatelessWidget {
  StartActivityScreen({
    this.icon: Icons.help,
    this.color,
    @required this.name,
  });

  final IconData icon;
  final Color color;
  final String name;

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
                new IconButton(
                  tooltip: 'Back',
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                new PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  onSelected: (value) {
                    if (value == 'Edit') {
                    } else if (value == 'Remove') {
                      FileManager
                          .removeFromFile('exercise.json', name)
                          .then((file) {
                        DynamicTheme
                            .of(context)
                            .setBrightness(Theme.of(context).brightness);
                        Navigator.pop(context, false);
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuItem<String>>[
                      new PopupMenuItem<String>(
                        value: 'Edit',
                        child: const Text('Edit'),
                      ),
                      new PopupMenuItem<String>(
                        value: 'Remove',
                        child: const Text('Remove'),
                      ),
                    ];
                  },
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
