import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './exercise.dart';

List<Diet> dietList = [
  new Diet(
    image: 'assets/diet-icons/apple.webp',
    name: 'Low-Fat',
    onPressed: () {},
  ),
  new Diet(
    image: 'assets/diet-icons/carrot.webp',
    name: 'Low-Calorie',
    onPressed: () {},
  ),
  new Diet(
    image: 'assets/diet-icons/broccoli.webp',
    name: 'Vegetarian',
    onPressed: () {},
  ),
  new Diet(
    image: 'assets/diet-icons/detox.webp',
    name: 'Detox',
    onPressed: () {},
  ),
];

class DietScreen extends StatelessWidget {

  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    double minHeight = MediaQuery.of(context).size.height;
    double windowTopPadding = MediaQuery.of(context).padding.top;
    // double width = MediaQuery.of(context).size.width;
    return new Container(
      padding: new EdgeInsets.only(top: windowTopPadding),
      constraints: new BoxConstraints(
        minHeight: minHeight - 56.0,
      ),
      child: new Column(
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 36.0),
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
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            padding: new EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 32.0),
            child: new Grid(
              children: dietList,
              columnCount: orientation == Orientation.portrait ? 2 : 3,
            ),
          ),
        ],
      ),
    );
  }
}

class Diet extends StatelessWidget {
  const Diet({
    this.icon: const Icon(Icons.help),
    this.image,
    @required this.name,
    @required this.onPressed,
  });
  final Icon icon;
  final String image;
  final String name;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double width = MediaQuery.of(context).size.width / ((orientation == Orientation.portrait) ? 2 : 3) - 12.0;
    return new Container(
      height: width / ((orientation == Orientation.portrait) ? 1.3 : 1.6),
      width: width,
      margin: new EdgeInsets.all(4.0),
      child: new RaisedButton(
        color: Colors.white,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: new Container(
          padding: new EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              (image != null)
                ? new Image.asset(
                  image,
                  height: 64.0,
                )
                : new IconTheme(
                  data: new IconThemeData(
                    size: 64.0,
                    color: Colors.green,
                  ),
                  child: icon,
                ),
              new Text(
                name,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.black87,
                  fontSize: 18.0,
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
