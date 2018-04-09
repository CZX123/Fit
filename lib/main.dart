import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './exercise.dart';
import './diet.dart';
import './newActivity.dart';
import './settings.dart';

void main() {
  MaterialPageRoute.debugEnableFadingRoutes = true;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fit',
      theme: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        accentColor: Colors.deepOrangeAccent,
      ),
      home: new MyHomePage(title: 'Fit'),
    );
  }
}

class NavigationView {
  NavigationView({
    Color color,
    Widget child,
    TickerProvider vsync,
  }) : _color = color,
       _child = child,
       controller = new AnimationController(
         duration: kThemeAnimationDuration,
         vsync: vsync,
       ) {
         _animation = new CurvedAnimation(
           parent: controller,
           curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
         );
       }

  final Color _color;
  final Widget _child;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(BuildContext context) {
    return new FadeTransition(
      opacity: _animation,
      child: new SingleChildScrollView(
        child: new Stack(
          children: <Widget>[
             new Positioned.fill(
              // bottom: width / 2.8,
              child: new DecoratedBox(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: <Color>[
                      _color,
                      Colors.grey[100],
                    ],
                  ),
                ),
              ),
            ),
            // TODO: Find a better bottom banner image. Something more subtle.
            /* new Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              height: width / 2.8,
              child: new Container(
                alignment: Alignment.bottomCenter,
                color: Colors.grey[100],
                child: new Image.asset(
                  'assets/banners/exercise.webp',
                ),
              ),
            ), */
            new SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(0.0, 0.02), // Slightly down.
                end: Offset.zero,
              ).animate(_animation),
              child: _child,
            ),
            new Positioned(
              top: 28.0,
              right: 4.0,
              child: new Material(
                type: MaterialType.circle,
                color: Colors.transparent,
                child: new IconButton(
                  color: Colors.white,
                  icon: new Icon(Icons.settings),
                  tooltip: 'Settings',
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new SettingsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 500;
  int _currentIndex = 0;
  List<NavigationView> _navigationViews;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationView>[
      new NavigationView(
        color: Colors.blue,
        child: new ExerciseScreen(
          counter: _counter,
        ),
        vsync: this,
      ),
      new NavigationView(
        color: Colors.green,
        child: new DietScreen(),
        vsync: this,
      ),
    ];
    for (NavigationView view in _navigationViews)
      view.controller.addListener(_rebuild);
    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationView view in _navigationViews)
      view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState((){});
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationView view in _navigationViews)
      transitions.add(view.transition(context));

    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body: new DecoratedBox(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: <Color>[
              _currentIndex == 0 ? Colors.blue : Colors.green,
              Colors.grey[100],
            ],
          ),
        ),
        child: _buildTransitionsStack(),
      ),

      floatingActionButton: _currentIndex == 0 ? new FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new NewActivityScreen()
            )
          );
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ) : null,

      bottomNavigationBar: new BottomNavigationBar(
        fixedColor: _currentIndex == 0 ? Colors.blue : Colors.green,
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: new Icon(Icons.directions_run),
            title: new Text('Exercise')
          ),
          new BottomNavigationBarItem(
            backgroundColor: Colors.green,
            icon: new Icon(Icons.fastfood),
            title: new Text('Diet'),
          ),
        ],
        onTap: (int index) {
          setState(() {
            _navigationViews[_currentIndex].controller.reverse();
            _currentIndex = index;
            _navigationViews[_currentIndex].controller.forward();
          });
        },
      )
    );
  }
}
