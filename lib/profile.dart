import 'dart:async';
import 'package:flutter/material.dart';
import 'fileManager.dart';
import 'sportsIcons.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int stepIndex = 0;
  int radioValue = 0;
  DateTime date = DateTime(2000);
  bool datePicked = false;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    readFile().then((contents) {
      if (contents != null) {
        if (contents['DOB'] != null) {
          setState(() {
            datePicked = true;
            date = DateTime(
              contents['DOB'][0],
              contents['DOB'][1],
              contents['DOB'][2],
            );
          });
        }
      }
    });
  }

  void changeRadioValue(int value) {
    setState(() {
      radioValue = value;
    });
  }

  Future<Map<String, dynamic>> readFile() async {
    return FileManager.readFile('profile.json');
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        datePicked = true;
        date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = darkMode ? Colors.white : Colors.black87;
    final Color outlineColor = darkMode ? Colors.grey[600] : Colors.grey[350];
    final Color highlightedBorderColor =
        darkMode ? Colors.lightBlue : Colors.blue;
    return Theme(
      data: ThemeData(
        brightness: Theme.of(context).brightness,
        primaryColor: Colors.blue,
        accentColor: darkMode ? Colors.limeAccent : Colors.deepOrangeAccent,
        toggleableActiveColor:
            darkMode ? Colors.limeAccent : Colors.deepOrangeAccent,
      ),
      child: Scaffold(
        backgroundColor: darkMode ? Colors.grey[900] : Colors.white,
        appBar: AppBar(
          backgroundColor: darkMode ? Colors.grey[850] : Colors.blue,
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
          child: Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                52.0 -
                56.0,
            child: Stepper(
              currentStep: stepIndex,
              onStepContinue: () {
                readFile();
                focusNode.unfocus();
                setState(() {
                  if (stepIndex < 3)
                    stepIndex++;
                  else
                    Navigator.pop(context);
                });
              },
              onStepCancel: () {
                focusNode.unfocus();
                setState(() {
                  if (stepIndex == 0) {
                    datePicked = false;
                  }
                  if (stepIndex < 3)
                    stepIndex++;
                  else
                    Navigator.pop(context);
                });
              },
              onStepTapped: (index) {
                focusNode.unfocus();
                setState(() {
                  stepIndex = index;
                });
              },
              steps: <Step>[
                Step(
                  isActive: stepIndex == 0 ? true : false,
                  title: const Text('Date of Birth'),
                  content: Row(
                    children: <Widget>[
                      Text('Date of Birth: '),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Builder(
                        builder: (context) => OutlineButton(
                              shape: const RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(4.0),
                                ),
                              ),
                              highlightElevation: 0.0,
                              borderSide: BorderSide(
                                color: outlineColor,
                                width: 2.0,
                              ),
                              highlightedBorderColor: highlightedBorderColor,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Container(
                                height: 36.0,
                                alignment: Alignment.center,
                                child: Text(
                                  datePicked
                                      ? date.toIso8601String().substring(0, 10)
                                      : 'YYYY-MM-DD',
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              onPressed: () => _selectDate(context),
                            ),
                      ),
                    ],
                  ),
                ),
                Step(
                  isActive: stepIndex == 1 ? true : false,
                  title: const Text('Gender'),
                  content: Column(
                    children: <Widget>[
                      RadioListTile<int>(
                        dense: true,
                        title: const Text(
                          'Male',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        value: 0,
                        groupValue: radioValue,
                        onChanged: changeRadioValue,
                      ),
                      RadioListTile<int>(
                        dense: true,
                        title: const Text(
                          'Female',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        value: 1,
                        groupValue: radioValue,
                        onChanged: changeRadioValue,
                      ),
                      RadioListTile<int>(
                        dense: true,
                        title: const Text(
                          'I prefer not to say',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        value: 2,
                        groupValue: radioValue,
                        onChanged: changeRadioValue,
                      ),
                    ],
                  ),
                ),
                Step(
                  //state: stepIndex == 2 ? StepState.editing : StepState.indexed,
                  isActive: stepIndex == 2 ? true : false,
                  title: const Text('Height'),
                  content: TextFormField(
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,
                      icon: const Icon(Icons.accessibility),
                      labelText: 'Height (cm)',
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                  ),
                ),
                Step(
                  //state: stepIndex == 3 ? StepState.values : StepState.indexed,
                  isActive: stepIndex == 3 ? true : false,
                  title: const Text('Weight'),
                  content: TextFormField(
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,
                      icon: const Icon(SportsIcons.scale),
                      labelText: 'Weight (kg)',
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                  ),
                ),
              ],
            ),
          ),
        ),
        persistentFooterButtons: <Widget>[
          FlatButton(
            child: Text('SKIP'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
