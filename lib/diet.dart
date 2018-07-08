import 'package:flutter/material.dart';
import 'customWidgets.dart';
import 'data/dietList.dart';

class DietScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final Orientation orientation = MediaQuery.of(context).orientation;
    double height = MediaQuery.of(context).size.height;
    double windowTopPadding = MediaQuery.of(context).padding.top;
    double containerHeight = 172.0;
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            right: 0.0,
            left: 0.0,
            height: containerHeight + windowTopPadding,
            child: Container(
              color: darkMode ? Colors.grey[900] : Colors.green,
            ),
          ),
          Positioned(
            top: containerHeight - 1 + windowTopPadding,
            right: 0.0,
            left: 0.0,
            bottom: -64.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: <Color>[
                    darkMode ? Colors.grey[900] : Colors.green,
                    darkMode ? Colors.grey[900] : Colors.green[50],
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
                  child: const Text(
                    'Diet',
                    style: const TextStyle(
                      height: 1.2,
                      color: Colors.white,
                      fontFamily: 'Renner*',
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                      child: const Text(
                        'Hello',
                        style: const TextStyle(
                          height: 1.2,
                          color: Colors.white,
                          fontFamily: 'Renner*',
                          fontSize: 48.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 20.0),
                      child: const Text(
                        'Here are some recommended diets for you:',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 32.0),
                  child: Grid(
                    children: dietList,
                    columnCount: orientation == Orientation.portrait ? 2 : 3,
                  ),
                ),
                const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Diet extends StatelessWidget {
  const Diet({
    this.icon: Icons.help,
    this.image,
    @required this.name,
    @required this.onPressed,
  });
  final IconData icon;
  final String image;
  final String name;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    Orientation orientation = MediaQuery.of(context).orientation;
    double width = MediaQuery.of(context).size.width /
            ((orientation == Orientation.portrait) ? 2 : 3) -
        12.0;
    return Container(
      height: width / ((orientation == Orientation.portrait) ? 1.3 : 1.6),
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
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              (image != null)
                  ? Image.asset(
                      image,
                      height: 64.0,
                    )
                  : Icon(
                      icon,
                      size: 64.0,
                      color: Colors.green,
                    ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.2,
                  fontFamily: 'Renner*',
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
