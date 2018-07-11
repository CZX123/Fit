import 'dart:async';
import 'package:flutter/material.dart';
import 'fileManager.dart' show FileManager;
import 'customWidgets.dart' show Grid;
import 'customExpansionPanel.dart';

class ExpansionPanelItem {
  ExpansionPanelItem({this.isExpanded, this.header, this.body, this.icon});
  bool isExpanded;
  final String header;
  final Widget body;
  final IconData icon;
}

class DietScreen extends StatefulWidget {
  DietScreen({Key key}) : super(key: key);
  static DietScreenState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<DietScreenState>());
  }

  DietScreenState createState() => DietScreenState();
}

class DietScreenState extends State<DietScreen> {
  final String fileName = 'diet.json';

  @override
  void initState() {
    super.initState();
  }

  Future<Map<Diet, List<ExpansionPanelItem>>> get getActiveDiet async {
    Map<String, dynamic> fileContent = await FileManager.readFile(fileName);
    if (fileContent != null && fileContent.length != 0) {
      List<ExpansionPanelItem> items = [];
      for (int i = 0; i < dietList.length; i++) {
        if (dietList[i].name == fileContent['activeDiet']) {
          IconData icon = Icons.local_pizza;
          for (int j = 0; j < dietList[i].data.keys.length; j++) {
            String meal = dietList[i].data.keys.toList()[j];
            if (meal == 'breakfast')
              icon = Icons.local_cafe;
            else if (meal == 'lunch')
              icon = Icons.restaurant_menu;
            else if (meal == 'dinner') icon = Icons.local_bar;
            ExpansionPanelItem item = ExpansionPanelItem(
              isExpanded: false,
              header: meal,
              icon: icon,
              body: Container(
                height: 100.0,
              ),
            );
            bool itemExists = false;
            for (int k = 0; k < items.length; k++) {
              if (items[k].header == item.header) itemExists = true;
            }
            if (!itemExists) items.add(item);
          }
          return {dietList[i]: items};
        }
      }
    }
    return null;
  }

  void updateScreen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double height = MediaQuery.of(context).size.height;
    final double windowTopPadding = MediaQuery.of(context).padding.top;
    final double containerHeight = 172.0;
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
            child: FutureBuilder<Map<Diet, List<ExpansionPanelItem>>>(
              future: getActiveDiet,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.length != 0) {
                  print('no');
                  Diet activeDiet = snapshot.data.keys.toList()[0];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(portrait ? 16.0 : 72.0,
                                24.0, portrait ? 16.0 : 72.0, 12.0),
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
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 8.4, 8.0, 0.0),
                            child: Material(
                              color: Colors.transparent,
                              type: MaterialType.circle,
                              child: PopupMenuButton<String>(
                                icon: Icon(
                                  Theme.of(context).platform ==
                                          TargetPlatform.iOS
                                      ? Icons.more_horiz
                                      : Icons.more_vert,
                                  color: Colors.white,
                                ),
                                onSelected: (value) {
                                  if (value == 'Remove') {
                                    FileManager
                                        .removeFromFile(
                                            'diet.json', 'activeDiet')
                                        .then((_) {
                                      DietScreen.of(context).updateScreen();
                                    });
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return <PopupMenuItem<String>>[
                                    PopupMenuItem<String>(
                                      value: 'Remove',
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.delete,
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                          const SizedBox(
                                            width: 16.0,
                                          ),
                                          const Text('Remove'),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              activeDiet.image,
                              width: 96.0,
                              height: 96.0,
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  activeDiet.name,
                                  style: const TextStyle(
                                    fontFamily: 'Renner*',
                                    color: Colors.white,
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  ' CURRENT DIET',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(portrait ? 16.0 : 72.0,
                            12.0, portrait ? 16.0 : 72.0, 12.0),
                        child: DietPanels(
                          items: snapshot.data[activeDiet],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(portrait ? 16.0 : 72.0,
                            24.0, portrait ? 16.0 : 72.0, 12.0),
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(portrait ? 16.0 : 72.0,
                                8.0, portrait ? 16.0 : 72.0, 0.0),
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(portrait ? 16.0 : 72.0,
                                8.0, portrait ? 16.0 : 72.0, 20.0),
                            child: const Text(
                              'Here are some recommended diets for you:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(portrait ? 4.0 : 68.0, 0.0,
                            portrait ? 4.0 : 68.0, 32.0),
                        child: Grid(
                          children: dietList,
                          columnCount: portrait ? 2 : 3,
                        ),
                      ),
                      const SizedBox(),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DietPanels extends StatefulWidget {
  DietPanels({@required this.items, Key key}) : super(key: key);
  final List<ExpansionPanelItem> items;
  _DietPanelsState createState() => _DietPanelsState();
}

class _DietPanelsState extends State<DietPanels> {
  List<ExpansionPanelItem> items;

  @override
  void initState() {
    super.initState();
    items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return CustomExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        setState(() {
          items[index].isExpanded = !items[index].isExpanded;
        });
      },
      children: items.map((ExpansionPanelItem item) {
        return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return FlatButton(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 72.0,
                ),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor:
                          darkMode ? Colors.blueGrey[700] : Colors.green,
                      child: Icon(
                        item.icon,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          '${item.header[0].toUpperCase()}${item.header.substring(1)}',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            height: 1.2,
                            fontFamily: 'Renner*',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    CustomExpandIcon(isExpanded),
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
    );
  }
}

class Diet extends StatelessWidget {
  const Diet({
    this.icon,
    this.image,
    @required this.name,
    this.description,
    this.data,
  });
  final IconData icon;
  final String image, name, description;
  final Map<String, Map<String, List<String>>> data;
  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double width =
        portrait ? (screenWidth - 24.0) / 2 : (screenWidth - 160.0) / 3;
    return Container(
      height: width / (portrait ? 1.3 : 1.2),
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
        onPressed: () {
          FileManager.writeToFile('diet.json', 'activeDiet', name).then((_) {
            DietScreen.of(context).updateScreen();
          });
        },
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

List<Diet> dietList = [
  Diet(
    image: 'assets/diet-icons/weight-loss.webp',
    name: 'Weight Loss',
    data: {
      'breakfast': {
        'recommend': [
          'Oats',
          'Whole-grain cereal',
          'Eggs',
          'Tea/Coffee without sugar'
        ],
        'avoid': [
          'Waffles',
          'French toast',
          'Pancakes',
          'Fruit juice',
          'Bread (unless wholemeal)'
        ],
      },
      'lunch': {
        'recommend': [
          'Protein (Meats, preferably non-red meat such as chicken)',
          'Dietary fibre sources (e.g. vegetables, salads without dressings)',
          'Whole-grains'
        ],
        'avoid': [
          'Refined carbohydrates (e.g. rice, pasta)',
          'Sugary food & drinks'
        ],
      },
    },
  ),
  Diet(
    image: 'assets/diet-icons/carrot.webp',
    name: 'Low-Calorie',
  ),
  Diet(
    image: 'assets/diet-icons/broccoli.webp',
    name: 'Vegetarian',
  ),
  Diet(
    image: 'assets/diet-icons/detox.webp',
    name: 'Detox',
  ),
];
