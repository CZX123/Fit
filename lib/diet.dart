import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart' show App;
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

class DietScreenState extends State<DietScreen> with TickerProviderStateMixin {
  final String fileName = 'diet.json';
  Diet activeDiet;
  List<ExpansionPanelItem> dietPanels = [];
  bool loaded = false;
  String imageAsset = 'assets/diet-icons/weight-loss.webp',
      name = 'Weight Loss';
  AnimationController fadeController;
  Animation<double> fadeOut;
  Animation<double> fadeIn;
  double top = 0.0;
  bool removedDiet = false;

  @override
  void initState() {
    super.initState();
    fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    fadeOut = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: fadeController,
        curve: Interval(
          0.0,
          0.55,
          curve: Curves.easeIn,
        ),
      ),
    );
    fadeIn = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: fadeController,
        curve: Interval(
          0.45,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map<String, dynamic> contents = App.of(context).dietContents;
    Diet diet;
    if (contents != null && contents.length > 0) {
      for (int i = 0; i < dietList.length; i++) {
        if (dietList[i].name == contents['activeDiet']) {
          diet = dietList[i];
        }
      }
    } else {
      diet = null;
    }
    if (activeDiet != diet || !loaded) {
      activeDiet = diet;
      updateDietScreen(activeDiet);
    }
  }

  @override
  void dispose() {
    fadeController.dispose();
    super.dispose();
  }

  void updateDietScreen([Diet diet]) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    List<ExpansionPanelItem> items = [];
    if (diet != null && diet.data != null && diet.data.keys != null) {
      IconData icon;
      for (int j = 0; j < diet.data.keys.length; j++) {
        String meal = diet.data.keys.toList()[j];
        if (meal == 'breakfast')
          icon = Icons.local_cafe;
        else if (meal == 'lunch')
          icon = Icons.restaurant_menu;
        else if (meal == 'dinner')
          icon = Icons.local_bar;
        else
          icon = Icons.local_pizza;
        List<IconRow> recommended = diet.data[meal]['recommend'].map((string) {
          return IconRow(
            iconColor: darkMode ? Colors.grey[50] : Colors.grey[900],
            iconData: Icons.keyboard_arrow_right,
            iconSize: 20.0,
            padding: 6.0,
            string: string,
          );
        }).toList();
        List<IconRow> avoid = diet.data[meal]['avoid'].map((string) {
          return IconRow(
            iconColor: darkMode ? Colors.grey[50] : Colors.grey[800],
            iconData: Icons.keyboard_arrow_right,
            iconSize: 20.0,
            padding: 6.0,
            string: string,
          );
        }).toList();
        List<IconRow> rows = <IconRow>[
              IconRow(
                iconColor: darkMode ? Colors.green[400] : Colors.green,
                iconData: Icons.check_circle,
                padding: 4.0,
                paddingTop: 4.0,
                string: 'Recommended Food',
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] +
            recommended +
            <IconRow>[
              IconRow(
                iconColor: darkMode ? Colors.redAccent[200] : Colors.red,
                iconData: Icons.warning,
                padding: 4.0,
                paddingTop: 12.0,
                string: 'Food to Avoid',
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] +
            avoid;
        items.add(
          ExpansionPanelItem(
            isExpanded: determineMealTime == meal,
            header: meal,
            icon: icon,
            body: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: rows,
              ),
            ),
          ),
        );
      }
    }
    if (mounted) {
      setState(() {
        activeDiet = diet ?? null;
        if (activeDiet != null) {
          imageAsset = activeDiet.image;
          name = activeDiet.name;
          dietPanels = items;
          if (!loaded) {
            fadeController.value = 1.0;
            removedDiet = false;
          } else {
            fadeController.forward();
            removedDiet = false;
          }
        } else if (loaded) {
          fadeController.reverse();
          Timer(Duration(milliseconds: 100), () {
            setState(() {
              removedDiet = true;
            });
          });
        }
        loaded = true;
      });
    }
  }

  String get determineMealTime {
    TimeOfDay now = TimeOfDay.now();
    if (3 < now.hour && now.hour < 11)
      return 'breakfast';
    else if (11 < now.hour && now.hour < 14)
      return 'lunch';
    else if (17 < now.hour && now.hour < 23)
      return 'dinner';
    else
      return 'snacks';
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double height = MediaQuery.of(context).size.height;
    final double windowTopPadding = MediaQuery.of(context).padding.top;
    final double containerHeight = 172.0;
    return NotificationListener(
      onNotification: (v) {
        double oldTop = top;
        if (v is ScrollUpdateNotification) top += v.scrollDelta;
        if (top <= 0.0 && oldTop > 0.0 || oldTop <= 0.0 && top > 0.0)
          setState(() {});
      },
      child: Container(
        color: darkMode
            ? Colors.grey[900]
            : top <= 0.0 ? Colors.green : Colors.green[100],
        child: SingleChildScrollView(
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
                bottom: 0.0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        darkMode ? Colors.grey[900] : Colors.green,
                        darkMode ? Colors.grey[900] : Colors.green[100],
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(portrait ? 16.0 : 72.0,
                      24.0 + windowTopPadding, portrait ? 16.0 : 72.0, 12.0),
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
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.only(top: windowTopPadding),
                color: darkMode ? Colors.grey[900] : null,
                constraints: BoxConstraints(
                  minHeight: height - 48.0,
                ),
                child: Stack(
                  children: <Widget>[
                    FadeTransition(
                      opacity: fadeIn,
                      child: IgnorePointer(
                        ignoring: activeDiet == null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      portrait ? 16.0 : 72.0,
                                      24.0,
                                      portrait ? 16.0 : 72.0,
                                      12.0),
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
                                Builder(
                                  builder: (context) => Padding(
                                        padding: EdgeInsets.fromLTRB(0.0, 8.4,
                                            portrait ? 4.0 : 64.0, 0.0),
                                        child: Transform.scale(
                                          scale: 4 / 3,
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
                                                size: 3 / 4 * 24.0,
                                              ),
                                              onSelected: (value) {
                                                if (value == 'Remove') {
                                                  FileManager
                                                      .removeFromFile(
                                                          'diet.json',
                                                          'activeDiet')
                                                      .then((_) {
                                                    App
                                                        .of(context)
                                                        .changeDiet({});
                                                    DietScreen
                                                        .of(context)
                                                        .updateDietScreen();
                                                  });
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
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
                                                        const Text('End Diet'),
                                                      ],
                                                    ),
                                                  ),
                                                ];
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: portrait
                                  ? EdgeInsets.all(16.0)
                                  : EdgeInsets.symmetric(
                                      horizontal: 72.0, vertical: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                    imageAsset,
                                    width: 80.0,
                                    height: 80.0,
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        name,
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
                            Builder(
                              builder: (context) {
                                if (dietPanels != null &&
                                    dietPanels.length != 0 &&
                                    !removedDiet) {
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(
                                        portrait ? 8.0 : 72.0,
                                        12.0,
                                        portrait ? 8.0 : 72.0,
                                        20.0),
                                    child: DietPanels(
                                      items: dietPanels,
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minHeight: height - 48.0 - windowTopPadding,
                      ),
                      child: FadeTransition(
                        opacity: fadeOut,
                        child: IgnorePointer(
                          ignoring: activeDiet != null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    portrait ? 16.0 : 72.0,
                                    24.0,
                                    portrait ? 16.0 : 72.0,
                                    12.0),
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
                                    padding: EdgeInsets.fromLTRB(
                                        portrait ? 16.0 : 72.0,
                                        8.0,
                                        portrait ? 16.0 : 72.0,
                                        0.0),
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
                                    padding: EdgeInsets.fromLTRB(
                                        portrait ? 16.0 : 72.0,
                                        8.0,
                                        portrait ? 16.0 : 72.0,
                                        20.0),
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
                                padding: EdgeInsets.fromLTRB(
                                    portrait ? 4.0 : 68.0,
                                    0.0,
                                    portrait ? 4.0 : 68.0,
                                    32.0),
                                child: Grid(
                                  children: dietList,
                                  columnCount: portrait ? 2 : 3,
                                ),
                              ),
                              const SizedBox(),
                              const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconRow extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final double iconSize;
  final String string;
  final double padding, paddingTop;
  final TextStyle textStyle;
  IconRow({
    @required this.iconData,
    @required this.iconColor,
    this.iconSize,
    @required this.string,
    @required this.padding,
    this.paddingTop,
    this.textStyle,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, paddingTop ?? padding, 0.0, padding),
      child: Row(
        children: <Widget>[
          SizedBox(width: iconSize != null ? 36.0 - iconSize / 2 : 22.0),
          Icon(
            iconData,
            color: iconColor,
            size: iconSize ?? 28.0,
          ),
          SizedBox(width: iconSize != null ? 36.0 - iconSize / 2 : 22.0),
          Expanded(
            child: Text(
              string,
              style: textStyle ?? const TextStyle(),
            ),
          ),
          const SizedBox(width: 16.0),
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
      borderRadius: 8.0,
      expansionCallback: (index, isExpanded) {
        setState(() {
          items[index].isExpanded = !items[index].isExpanded;
        });
      },
      children: items.map((ExpansionPanelItem item) {
        int i = items.indexOf(item);
        return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: i == 0 ||
                          isExpanded ||
                          (i > 0 && items[i - 1].isExpanded == true)
                      ? Radius.circular(8.0)
                      : Radius.zero,
                  bottom: !isExpanded &&
                          (i == items.length - 1 ||
                              (i < items.length - 1 &&
                                  items[i + 1].isExpanded == true))
                      ? Radius.circular(8.0)
                      : Radius.zero,
                ),
              ),
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

  Diet getDiet(String name) {
    Diet data;
    dietList.forEach((diet) {
      if (diet.name == name) data = diet;
    });
    return data;
  }

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
            App.of(context).changeDiet({'activeDiet': name});
            DietScreen.of(context).updateDietScreen(getDiet(name));
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
          'Whole-grains',
        ],
        'avoid': [
          'Refined carbohydrates (e.g. rice, pasta)',
          'Sugary food & drinks',
          'Fatty foods',
        ],
      },
      'dinner': {
        'recommend': [
          'Lean proteins (Tofu, fish, pork, beans)',
          'Whole grains (Brown rice, quinoa, whole wheat bread)',
          'Salad greens',
        ],
        'avoid': [
          'Refined carbohydrates (e.g. rice, pasta)',
          'Sugary food & drinks',
          'Fatty foods',
        ],
      },
      'snacks': {
        'recommend': [
          'Fruits',
          'Nuts',
        ],
        'avoid': [
          'Sweet foods & drinks (e.g. ice cream, Coca-Cola)',
          'Even more carbs (biscuits, wafers)',
        ],
      },
    },
  ),
  Diet(
    image: 'assets/diet-icons/muscle.webp',
    name: 'Muscle Gain',
    data: {
      'breakfast': {
        'recommend': [
          'Eggs',
          'Cereals/Oats',
          'English Breakfast (once in a while)'
        ],
        'avoid': [
          'Complex carbohydrates (white bread, cornflakes)',
          'Fast food breakfasts (unless low in calories)',
        ],
      },
      'lunch': {
        'recommend': [
          'Lean protein (eggs, chicken, red meats occasionally)',
          'Any sort of carbohydrates (but minimal intake)',
          'Coffee, Tea or water (with little sugar)',
        ],
        'avoid': [
          'Deep-fried food',
          'Drinks with high sugar levels',
          'Nothing (eating nothing will worsen your condition!)',
        ],
      },
      'dinner': {
        'recommend': [
          'Poultry, fish, lean red meats',
          'Pasta/Spaghetti',
          'Salads',
        ],
        'avoid': [
          'Fatty salad dressings (Hollandaise, Thousand Island)',
          'Frozen "diet" meals (usually scams)',
          'High fructose corn syrup',
        ],
      },
      'snacks': {
        'recommend': [
          'Nuts',
          'Flax Seeds',
          'Salads with vinaigrette dressing',
        ],
        'avoid': [
          'High-sugar snacks (ice cream, sugary yogurts)',
          'Processed foods (cookies, potato chips)',
          'Oil-soaked food',
        ],
      },
    },
  ),
  Diet(
    image: 'assets/diet-icons/mediterranean.webp',
    name: 'Mediterranean',
    data: {
      'breakfast': {
        'recommend': [
          'Greek yogurt + fruits',
          'Oatmeal + dried fruits of choice',
          'Omelet with veggies of choice + fruit of choice',
          'Eggs and veggies, fried in olive oil'
        ],
        'avoid': [
          'Refined Grains (white bread, normal pasta, cereal)',
          'Added Sugars (chocolate, sodas)',
        ],
      },
      'lunch': {
        'recommend': [
          'Whole-grain sandwich with veggies',
          'Greek yogurt with strawberries, oats and nuts',
          'Mediterranean lasagne',
        ],
        'avoid': [
          'Refined Grains (white bread, normal pasta, cereal)',
          'Highly Processed Foods',
          'Refined Oils',
        ],
      },
      'dinner': {
        'recommend': [
          'Tuna salad dressed in olive oil + fruit',
          'Mediterranean lasagne',
          'Grilled lamb/chicken, with salad and baked potato',
        ],
        'avoid': [
          'Processed Meats (hot dogs, bacon)',
          'Trans/saturated fats (margarine, butter)',
          'Refined Oils',
        ],
      },
      'snacks': {
        'recommend': [
          'Corn',
          'Fruit juice',
          'Almonds',
          'Oranges',
        ],
        'avoid': [
          'Added Sugars (chocolate, sodas))',
          'Processed foods (cookies, potato chips, etc,)',
          'Oil-soaked foods ',
        ],
      }
    }
  ),
  Diet(
    image: 'assets/diet-icons/detox.webp',
    name: 'Detox',
    data: {
      'breakfast': {
        'recommend': [
          'Fruit smoothie',
          'Fresh fruits rich in Vitamins',
          'Hot water with lemon juice',
          'Boiled eggs'
        ],
        'avoid': [
          'Foods with high calorie content',
          'Processed Foods',
          'Coffee and caffeinated beverages',
        ],
      },
      'lunch': {
        'recommend': [
          'Cabbage salad',
          'Lean proteins',
          'Whole-grains (Brown rice)',
          'Carrot soup',
        ],
        'avoid': [
          'Fatty foods',
          'Foods with excessive carbohydrates',
          'Processed foods',
        ],
      },
      'dinner': {
        'recommend': [
          'Tomato soup',
          'Healthy greens (Kale, Asparagus)',
          'Whole wheat bread',
        ],
        'avoid': [
          'Processed foods',
          'Oily foods',
          'Fatty foods',
        ],
      },
      'snacks': {
        'recommend': [
          'Corn',
          'Fruit juice',
          'Almonds',
          'Oranges',
        ],
        'avoid': [
          'High-sugar snacks (Ice cream, sugary yogurts)',
          'Processed foods (cookies, potato chips, etc,)',
          'Oil-soaked foods ',
        ],
      }
    },
  ),
];
