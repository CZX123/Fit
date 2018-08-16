import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:haversine/haversine.dart';
import 'package:sensors/sensors.dart';

class StepScreen extends StatefulWidget {
  @override
  _StepScreenState createState() => new _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {
  Map<String, double> _currentLocation;
  Map<String, double> result;
  Map<String, double> _xLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;

  Location _location = new Location();
  String error; 

  bool currentWidget = true;
  double _meter = 0.0;
  double _totalDistance = 0.0;
  double _strideLength = 0.7221;
  // stride length = height * 0.415(M) / height * 0.413(F)
  int _steps = 0;
  List<double> _userAccelerometerValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  @override
  void initState() {
    super.initState();

    initPlatformState(); 

     _streamSubscriptions.add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    })); 

    _locationSubscription =
        _location.onLocationChanged.listen((result) {
          if (result != _currentLocation) {
            if ((_userAccelerometerValues[0] > 0.5 || _userAccelerometerValues[0] < -0.5  ) || (_userAccelerometerValues[1] > 0.5 || _userAccelerometerValues[1] < -0.5 ) || (_userAccelerometerValues[2] > 0.5 || _userAccelerometerValues[2] < -0.5  )) {
              setState(() {
                _xLocation = _currentLocation;
                _currentLocation = result;

                _meter = (new Haversine.fromDegrees(latitude1: _xLocation["latitude"],
                                                longitude1: _xLocation["longitude"],
                                                latitude2: _currentLocation["latitude"],
                                                longitude2: _currentLocation["longitude"])).distance();
                _totalDistance += _meter;
                _steps = (_totalDistance / _strideLength).round();
            });
          }}      
        });
  }

  initPlatformState() async {
    Map<String, double> location;

    try {
      location = await _location.getLocation;

      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }

    setState(() { 
        _currentLocation = location;
        _xLocation = location; 
    });

  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Stats'),
            ),
        body: new Text(
              'Steps : $_steps Total Distance : $_totalDistance Distance from previous : $_meter  , Longitude : ${_currentLocation["longitude"]} , xLongitude : ${_xLocation["longitude"]}, Latitude : ${_currentLocation["latitude"]} , xLatitude : ${_xLocation["latitude"]} , Acceleration : $_userAccelerometerValues'),
              
            ));
  }
}

