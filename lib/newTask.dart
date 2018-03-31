import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// New Custom Grid Delegate for fixed height grids
class SliverGridDelegateWithFixedCrossAxisCountAndMainAxisLength extends SliverGridDelegate {

  const SliverGridDelegateWithFixedCrossAxisCountAndMainAxisLength({
    @required this.crossAxisCount,
    @required this.mainAxisLength,
    this.mainAxisSpacing: 0.0,
    this.crossAxisSpacing: 0.0,
  }) : assert(crossAxisCount != null && crossAxisCount > 0),
       assert(mainAxisSpacing != null && mainAxisSpacing >= 0),
       assert(crossAxisSpacing != null && crossAxisSpacing >= 0),
       assert(mainAxisLength != null && mainAxisLength > 0);

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  /// The ratio of the cross-axis to the main-axis extent of each child.
  final double mainAxisLength;

  bool _debugAssertIsValid() {
    assert(crossAxisCount > 0);
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
    assert(mainAxisLength > 0.0);
    return true;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    assert(_debugAssertIsValid());
    final double usableCrossAxisExtent = constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1);
    final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final double childMainAxisExtent = mainAxisLength;
    return new SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(SliverGridDelegateWithFixedCrossAxisCountAndMainAxisLength oldDelegate) {
    return oldDelegate.crossAxisCount != crossAxisCount
        || oldDelegate.mainAxisSpacing != mainAxisSpacing
        || oldDelegate.crossAxisSpacing != crossAxisSpacing
        || oldDelegate.mainAxisLength != mainAxisLength;
  }
}

class Package extends StatelessWidget {
  const Package({
    this.icon: const Icon(Icons.help),
    this.image,
    @required this.name,
    @required this.onPressed,
  });
  final Icon icon;
  final ImageProvider<dynamic> image;
  final String name;
  final VoidCallback onPressed;
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
                  color: Colors.blue,
                ),
                child: icon,
                ),
            new Text(
              name,
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
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
    this.icon: const Icon(Icons.help),
    this.image,
    @required this.name,
    @required this.onPressed,
  });

  final Icon icon;
  final ImageProvider<dynamic> image;
  final String name;
  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return new FlatButton(
      onPressed: onPressed,
      child: new Container(
        //padding: new EdgeInsets.symmetric(horizontal: 16.0),
        child: new Row(
          children: <Widget>[
            (image != null)
              ? new Image(
                  height: 28.0,
                  image: image,
                )
              : new IconTheme(
                data: new IconThemeData(
                  size: 28.0,
                  color: Colors.blue,
                ),
                child: icon,
              ),
            new Padding(
              padding: new EdgeInsets.only(left: 16.0),
              child: new Text(
                name,
                style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('New Task'),
      ),
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverPadding(
            padding: new EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 16.0),
            sliver: new SliverToBoxAdapter(
              child: new Text(
                'Packages',
                style: new TextStyle(
                  color: Colors.black54,
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
              childAspectRatio: 1.3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              children: <Widget>[
                new Package(
                  icon: new Icon(Icons.directions_run),
                  name: 'NAPFA',
                  onPressed: () {},
                ),
                new Package(
                  icon: new Icon(Icons.accessibility_new),
                  name: '6-Pack',
                  onPressed: () {},
                ),
              ],
            ),
          ),
          new SliverPadding(
            padding: new EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
            sliver: new SliverToBoxAdapter(
              child: new Text(
                'Tasks',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          new SliverGrid(
            delegate: new SliverChildListDelegate(
              <Widget>[
                new Task(
                  image: new AssetImage('assets/icons/crunches.webp'),
                  name: 'Crunches',
                  onPressed: () {},
                ),
                new Task(
                  image: new AssetImage('assets/icons/cycling.webp'),
                  name: 'Cycling',
                  onPressed: () {},
                ),
                new Task(
                  image: new AssetImage('assets/icons/planking.webp'),
                  name: 'Planking',
                  onPressed: () {},
                ),
                new Task(
                  image: new AssetImage('assets/icons/pushup.webp'),
                  name: 'Push Ups',
                  onPressed: () {},
                ),
                new Task(
                  image: new AssetImage('assets/icons/running.webp'),
                  name: 'Running',
                  onPressed: () {},
                ),
                new Task(
                  image: new AssetImage('assets/icons/situp.webp'),
                  name: 'Situps',
                  onPressed: () {},
                ),
                new Task(
                  image: new AssetImage('assets/icons/walking.webp'),
                  name: 'Walking',
                  onPressed: () {},
                ),
              ],
            ),
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCountAndMainAxisLength(
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
              mainAxisLength: 48.0
            ),
          ),
        ],
      ),
    );
  }
}
