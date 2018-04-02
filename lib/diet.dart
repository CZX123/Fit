import 'dart:math';
import 'package:flutter/material.dart';
import './newTask.dart';

var rng = new Random();

class DietScreen extends StatelessWidget {
  const DietScreen({
    this.orientation,
  });
  final Orientation orientation;
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: const Alignment(0.0, -1.0),
          end: const Alignment(0.0, 0.6),
          colors: <Color>[
            const Color(0xFF2196F3),
            const Color(0x112196F3)
          ],
        ),
      ),
      child: new CustomScrollView(
        slivers: <Widget>[
          new SliverPadding(
            padding: new EdgeInsets.all(16.0),
            sliver: new SliverToBoxAdapter(
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(bottom: 8.0),
                    child: new IconTheme(
                      data: new IconThemeData(
                        size: 48.0,
                        color: Colors.white,
                      ),
                      child: new Icon(Icons.warning),
                    ),
                  ),
                  new Text(
                    'Your BMI is',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  new Text(
                    '28',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 48.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 8.0),
                    child: new Text(
                      'Here are some recommended diets for you:',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new SliverPadding(
            padding: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
            sliver: new SliverGrid.count(
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: (orientation == Orientation.portrait) ? 1.33 : 1.6,
              children: <Widget>[
                new Package(
                  image: new AssetImage('assets/diet-icons/apple.webp'),
                  name: 'Low-Fat',
                  onPressed: () {},
                ),
                new Package(
                  image: new AssetImage('assets/diet-icons/carrot.webp'),
                  name: 'Low-Calorie',
                  onPressed: () {},
                ),
                new Package(
                  image: new AssetImage('assets/diet-icons/broccoli.webp'),
                  name: 'Vegetarian',
                  onPressed: () {},
                ),
                new Package(
                  image: new AssetImage('assets/diet-icons/detox.webp'),
                  name: 'Detox',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
