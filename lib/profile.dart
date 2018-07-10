import 'package:flutter/material.dart';
import 'sportsIcons.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int stepIndex = 0;
  int radioValue = 0;
  void changeRadioValue(int value) {
    setState(() {
      radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        accentColor: Colors.deepOrangeAccent,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: const TextStyle(
              height: 1.2,
              fontFamily: 'Renner*',
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                52.0 -
                64.0,
            child: Stepper(
              currentStep: stepIndex,
              onStepContinue: () {
                setState(() {
                  if (stepIndex < 3)
                    stepIndex++;
                  else
                    Navigator.pop(context);
                });
              },
              onStepCancel: () {
                setState(() {
                  if (stepIndex < 3)
                    stepIndex++;
                  else
                    Navigator.pop(context);
                });
              },
              onStepTapped: (index) {
                setState(() {
                  stepIndex = index;
                });
              },
              steps: <Step>[
                Step(
                  title: const Text('Age'),
                  content: Container(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: const UnderlineInputBorder(),
                        filled: true,
                        icon: const Icon(Icons.person),
                        hintText: "What's your age?",
                        labelText: 'Age',
                      ),
                      keyboardType: TextInputType.numberWithOptions(),
                    ),
                  ),
                ),
                Step(
                  title: const Text('Gender'),
                  content: Column(
                    children: <Widget>[
                      RadioListTile<int>(
                        title: const Text('Male'),
                        value: 0,
                        groupValue: radioValue,
                        onChanged: changeRadioValue,
                      ),
                      RadioListTile<int>(
                        title: const Text('Female'),
                        value: 1,
                        groupValue: radioValue,
                        onChanged: changeRadioValue,
                      ),
                      RadioListTile<int>(
                        title: const Text('I prefer not to say'),
                        value: 2,
                        groupValue: radioValue,
                        onChanged: changeRadioValue,
                      ),
                    ],
                  ),
                ),
                Step(
                  title: const Text('Height'),
                  content: Container(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: const UnderlineInputBorder(),
                        filled: true,
                        icon: const Icon(Icons.accessibility),
                        hintText: "What's your height?",
                        labelText: 'Height',
                      ),
                      keyboardType: TextInputType.numberWithOptions(),
                    ),
                  ),
                ),
                Step(
                  title: const Text('Weight'),
                  content: Container(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: const UnderlineInputBorder(),
                        filled: true,
                        icon: const Icon(SportsIcons.scale),
                        hintText: "What's your weight?",
                        labelText: 'Weight',
                      ),
                      keyboardType: TextInputType.numberWithOptions(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        persistentFooterButtons: <Widget>[
          FlatButton(
            child: Text('NEXT'),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
