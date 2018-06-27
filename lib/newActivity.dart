import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'data/newActivityList.dart';
import 'newPackageTask.dart';
import 'customWidgets.dart';

class NewActivityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: new AppBar(
        backgroundColor: darkMode ? Colors.grey[800] : Colors.blue,
        title: new Text(
          'New Activity',
          style: new TextStyle(
            height: 1.2,
            fontFamily: 'Renner*',
            fontSize: 20.0,
            fontWeight: FontWeight.w500
          ),
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
            padding: new EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 16.0),
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
            padding: new EdgeInsets.all(8.0),
            sliver: new SliverGrid.count(
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
              childAspectRatio: (orientation == Orientation.portrait) ? 1.3 : 1.6,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              children: packageList,
            ),
          ),
          new SliverPadding(
            padding: new EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
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
            padding: new EdgeInsets.only(bottom: 32.0),
            sliver: new SliverList(
              delegate: new SliverChildBuilderDelegate(
                (context, i) {
                  if (i < taskList.length) return taskList[i];
                }
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
    this.image,
    this.color,
    @required this.name,
    this.description,
  });
  final IconData icon;
  final String image;
  final Color color;
  final String name;
  final String description;
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final Color actualColor = color ?? (darkMode ? Colors.lightBlue : Colors.blue);
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
            builder: (context) => new NewPackageScreen(
              icon: icon,
              image: image,
              color: actualColor,
              name: name,
              description: description ?? "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
            ),
          )
        );
      },
      child: new Container(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new SizedBox(
              height: 64.0,
              width: 64.0,
              child: new Hero(
                tag: name,
                child: (image != null)
                  ? new Image.asset(
                      image,
                      fit: BoxFit.contain,
                    )
                  : new FittedBox(
                      child: new Icon(
                        icon,
                        color: actualColor,
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
    this.image,
    @required this.name,
    this.description,
  });

  final IconData icon;
  final String image;
  final String name;
  final String description;

  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return new ListTile(
      leading: new SizedBox(
        height: 32.0,
        width: 32.0,
        child: new Hero(
          tag: name,
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
      onTap: () {
        Navigator.push(
          context,
          new FadingPageRoute(
            builder: (context) => new NewTaskScreen(
              icon: icon,
              image: image,
              name: name,
              description: description ?? "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
            ),
          )
        );
      },
      title: new Text(name),
    );
  }
}
