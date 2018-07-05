import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'data/newActivityList.dart';
import 'addActivity.dart';
import 'customWidgets.dart';
import 'sportsIcons.dart';
import 'customExpansionPanel.dart';

class ExpansionPanelItem {
  ExpansionPanelItem({this.isExpanded, this.header, this.body, this.icon});
  bool isExpanded;
  final String header;
  final Widget body;
  final IconData icon;
}

class NewActivityScreen extends StatefulWidget {
  @override
  _NewActivityScreenState createState() => new _NewActivityScreenState();
}

class _NewActivityScreenState extends State<NewActivityScreen> {
  List<ExpansionPanelItem> items = [
    new ExpansionPanelItem(
      isExpanded: false,
      header: 'Sports',
      icon: SportsIcons.tennis,
      body: new Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: new Column(
          children: sportsList,
        ),
      ),
    ),
    new ExpansionPanelItem(
      isExpanded: false,
      header: 'Others',
      icon: SportsIcons.stretching,
      body: new Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: new Column(
          children: taskList,
        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: new AppBar(
        /*
        leading: new IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () { Navigator.pop(context, ''); },
          tooltip: 'Back',
        ),
        */
        backgroundColor: darkMode ? Colors.grey[800] : Colors.blue,
        title: new Text(
          'New Activity',
          style: new TextStyle(
              height: 1.2,
              fontFamily: 'Renner*',
              fontSize: 20.0,
              fontWeight: FontWeight.w500),
        ),
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
            padding: const EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 16.0),
            sliver: new SliverToBoxAdapter(
              child: new Text(
                'Packages',
                style: new TextStyle(
                  color: darkMode ? Colors.white : Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          new SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: new SliverGrid.count(
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
              childAspectRatio:
                  (orientation == Orientation.portrait) ? 1.3 : 1.6,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              children: packageList,
            ),
          ),
          new SliverPadding(
            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
            sliver: new SliverToBoxAdapter(
              child: new Text(
                'Tasks',
                style: new TextStyle(
                  color: darkMode ? Colors.white : Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          new SliverPadding(
            padding: const EdgeInsets.only(bottom: 32.0),
            sliver: new SliverToBoxAdapter(
              child: new CustomExpansionPanelList(
                expansionCallback: (index, isExpanded) {
                  setState(() {
                    items[index].isExpanded = !items[index].isExpanded;
                  });
                },
                children: items.map((ExpansionPanelItem item) {
                  return new ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return new FlatButton(
                        child: new Container(
                          constraints: new BoxConstraints(
                            minHeight: 72.0,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: new Row(
                            children: <Widget>[
                              new CircleAvatar(
                                backgroundColor: darkMode
                                    ? Colors.blueGrey[700]
                                    : Colors.blue,
                                child: new Icon(
                                  item.icon,
                                  color: Colors.white,
                                ),
                              ),
                              new Expanded(
                                child: new Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: new Text(
                                    item.header,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                      height: 1.2,
                                      fontFamily: 'Renner*',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              new CustomExpandIcon(isExpanded),
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
          ),
        ],
      ),
    );
  }
}

class Package extends StatelessWidget {
  Package({
    this.icon: Icons.help,
    @required this.name,
    this.description,
    this.packageTasks,
  });
  final IconData icon;
  final String name;
  final String description;
  final List<Task> packageTasks;
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return new RaisedButton(
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
          new FadingPageRoute(
            builder: (context) => new AddActivityScreen(
                  icon: icon,
                  name: name,
                  description: description ??
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                  packageTasks: packageTasks ?? [],
                ),
          ),
        );
      },
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new SizedBox(
              height: 64.0,
              width: 64.0,
              child: new Hero(
                tag: name,
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
    @required this.name,
    this.description,
  });

  final IconData icon;
  final String name;
  final String description;

  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return new FlatButton(
      child: new Container(
        height: 56.0,
        child: new Row(
          children: <Widget>[
            new SizedBox(
              height: 32.0,
              width: 32.0,
              child: new Hero(
                tag: name,
                child: new FittedBox(
                  child: new Icon(
                    icon,
                    color: darkMode ? Colors.lightBlue : Colors.blue,
                  ),
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: new Text(name),
            ),
          ],
        ),
      ),
      onPressed: () {
        Navigator.push(
            context,
            new FadingPageRoute(
              builder: (context) => new AddActivityScreen(
                    icon: icon,
                    name: name,
                    description: description ??
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                  ),
            ));
      },
    );
  }
}
