import 'dart:async';
import 'package:flutter/material.dart';
import 'addActivity.dart';
import 'customWidgets.dart';
import 'sportsIcons.dart';
import 'customExpansionPanel.dart';
import 'fileManager.dart';

class ExpansionPanelItem {
  ExpansionPanelItem({this.isExpanded, this.header, this.body, this.icon});
  bool isExpanded;
  final String header;
  final Widget body;
  final IconData icon;
}

class NewActivityScreen extends StatefulWidget {
  @override
  _NewActivityScreenState createState() => _NewActivityScreenState();
}

class _NewActivityScreenState extends State<NewActivityScreen> {
  Future<bool> isActive(String name) async {
    Map<String, dynamic> contents = await FileManager.readFile('exercise.json');
    List<String> keys = contents.keys;
    bool matches = false;
    keys.forEach((key) {
      if (key == name) matches = true;
    });
    return matches;
  }

  List<ExpansionPanelItem> items = [
    ExpansionPanelItem(
      isExpanded: false,
      header: 'Common Exercises',
      icon: SportsIcons.jumping_jacks,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: commonList,
        ),
      ),
    ),
    ExpansionPanelItem(
      isExpanded: false,
      header: 'Sports',
      icon: SportsIcons.tennis,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: sportsList,
        ),
      ),
    ),
    ExpansionPanelItem(
      isExpanded: false,
      header: 'Gym Exercises',
      icon: SportsIcons.exercise_bike,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: gymList,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: darkMode ? Colors.grey[800] : Colors.blue,
        title: const Text(
          'New Exercise',
          style: const TextStyle(
            height: 1.2,
            fontFamily: 'Renner*',
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 8.0),
              child: Text(
                'Packages',
                style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 180.0,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(4.0, 16.0, 4.0, 24.0),
                scrollDirection: Axis.horizontal,
                children: packageList,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
              child: Text(
                'Tasks',
                style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: CustomExpansionPanelList(
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
                                backgroundColor: darkMode
                                    ? Colors.blueGrey[700]
                                    : Colors.blue,
                                child: Icon(
                                  item.icon,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    item.header,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Package extends StatelessWidget {
  Package({
    @required this.icon,
    @required this.name,
    @required this.description,
    this.packageTasks,
    this.timings,
  });
  final IconData icon;
  final String name, description;
  final List<Task> packageTasks;
  final List<int> timings;

  Package getPackage(String name) {
    Package data;
    packageList.forEach((package) {
      if (package.name == name) data = package;
    });
    return data;
  }

  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final double width =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      constraints: BoxConstraints(
        minWidth: width / 5 + 96.0,
      ),
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
          Navigator.push(
            context,
            FadingPageRoute(
              builder: (context) => AddActivityScreen(
                    package: getPackage(name),
                  ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 64.0,
                width: 64.0,
                child: Hero(
                  tag: name,
                  child: FittedBox(
                    child: Icon(
                      icon,
                      color: darkMode ? Colors.lightBlue : Colors.blue,
                    ),
                  ),
                ),
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.2,
                  fontFamily: 'Renner*',
                  fontSize: 17.0,
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

class Task extends StatelessWidget {
  const Task({
    @required this.icon,
    @required this.name,
    @required this.description,
  });

  final IconData icon;
  final String name;
  final String description;

  Task getTask(String name) {
    Task data;
    allTasks.forEach((task) {
      if (task.name == name) data = task;
    });
    return data;
  }

  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return FlatButton(
      child: Container(
        height: 56.0,
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 32.0,
              width: 32.0,
              child: Hero(
                tag: name,
                child: FittedBox(
                  child: Icon(
                    icon,
                    color: darkMode ? Colors.lightBlue : Colors.blue,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(name),
            ),
          ],
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          FadingPageRoute(
            builder: (context) => AddActivityScreen(
                  task: getTask(name),
                ),
          ),
        );
      },
    );
  }
}

List<Package> packageList = [
  Package(
    icon: SportsIcons.running,
    name: 'NAPFA',
    description:
        'NAPFA is a test of physical fitness for Singaporean students. This package is aimed at helping you get better for NAPFA. Training areas help with the tasks tested for NAPFA.',
    packageTasks: <Task>[
      hiddenList[1], // Runner's Stretch
      commonList[8], // Sit-Ups
      commonList[6], // Planking
      hiddenList[6], // Shuttle Run
      hiddenList[7], // Standing Broad Jump
      hiddenList[8], // 2.4km Run
    ],
    timings: [120, 60, 90, 10, 10, 600], // all in seconds
  ),
  Package(
    icon: SportsIcons.others_workout,
    name: 'Abs Workout',
    description:
        'Abs Workout is a package for you to develop your abdominal muscles, so as to attain and sustain healthy abdominals.',
    packageTasks: <Task>[
        commonList[2], // Crunches
        commonList[8], // Sit-Ups
        commonList[6], // Planks
    ],
    timings: [180, 180, 180], 
  ),
  Package(
    icon: SportsIcons.jumping_jacks,
    name: 'Weight Loss',
    description: 'Exercises in this package helps burn fat and lose weight.',
    packageTasks: <Task>[
      commonList[5], // Lunges
      commonList[2], // Burpees
      commonList[10], // Squats
      hiddenList[0], // Stationary Jogging
      commonList[3], // Jumping Jacks
    ],
    timings: [60, 60, 30, 60, 60],
  ),
  Package(
    icon: SportsIcons.circuit_training,
    name: 'Circuit Training',
    description:
        'Circuit training is a type of endurance or resistance training utilising high intensity, targeting strength building or muscular endurance. Exercises are performed with no rest in between, and is done in a cycle. Once one cycle is complete, the individual starts again after a short break.',
    packageTasks: <Task>[
      commonList[8], // Sit-Ups
      commonList[9], // Squats
      commonList[2], // Crunches
      commonList[7], // Push-Ups
      commonList[10], // Skipping Rope
      commonList[1], // Burpees
    ],
    timings: [60, 60, 60, 60, 60, 60],
  ),
  Package(
    icon: SportsIcons.pilates,
    name: 'Pilates',
    description:
        'Pilates is a fitness system that is designed to improve physical strength, flexibility, posture, and enhance mental awareness.',
  ),
  Package(
    icon: SportsIcons.stretching,
    name: 'Stretching',
    description:
        'Stretching is primarily a warm-up activity used to increase flexibility and reduce the risk of injuries during exercise.',
    packageTasks: <Task>[
      hiddenList[1], // Runner's Stretch
      hiddenList[2], // The Bound Angle
      hiddenList[3], // Seated Back Twist
      hiddenList[4], // Standing Side Stretch
      hiddenList[5], // Forward Hang
    ],  
    timings: [40, 40, 40, 40, 40],    
  ),
  Package(
    icon: SportsIcons.aerobics,
    name: 'Aerobics',
    description:
        'Aerobics is a form of physical exercise that improves flexibility, muscular strength and cardio-vascular fitness, which is done by combining rhythmic aerobic exercise with stretching and strength training routines.',
 
  ),
];

List<Task> commonList = [
  Task(
    icon: SportsIcons.back_extension,
    name: 'Back Extensions',
    description:
        'A hyperextension or back extension is an exercise that works the lower back as well as the mid and upper back, specifically the erector spinae. To do this, you’ll need a hyperextension bench which is readily available at your nearby gym, but there is a way to do so without equipment at all!',
  ),
  Task(
    icon: SportsIcons.burpee_test,
    name: 'Burpees',
    description:
        'The burpee is a full body strength training exercise that works the arms, chest, quads, glutes, hamstrings and abs.',
  ),
  Task(
    icon: SportsIcons.crunch,
    name: 'Crunches',
    description:
        'The crunch is an abdominal exercise, working on the abdominal muscles and the oblique muscle.',
  ),
  Task(
    icon: SportsIcons.jumping_jacks,
    name: 'Jumping Jacks',
    description:
        'The rigorous calisthenic moves in this exercise helps improve your stamina, are great for the cardiovascular system, and they help to relieve stress as well!',
  ),
  Task(
    icon: SportsIcons.leg_raise,
    name: 'Leg Raises',
    description:
        'Leg raises are extremely beneficial for your entire abdominal area, helping build strength and definition in your core muscle.',
  ),
  Task(
    icon: SportsIcons.lunge,
    name: 'Lunges',
    description:
        'A lunge is a single-leg bodyweight exercise that helps work the hips, glutes, quads, hamstrings, core and inner thigh, aiding in lower body strength and endurance.',
  ),
  Task(
    icon: SportsIcons.plank,
    name: 'Planking',
    description:
        'Planking is an isometric exercise that helps train core strength, strengthening the abdominals, back and shoulders.',
  ),
  Task(
    icon: SportsIcons.push_up,
    name: 'Push-Ups',
    description:
        'Push-ups are a calisthenics exercise, exercising the pectoral muscles, triceps, and anterior deltoids, with ancillary benefits to the rest of the deltoids, serratus anterior, coracobrachialis and the midsection as a whole.',
  ),
  Task(
    icon: SportsIcons.sit_up,
    name: 'Sit-Ups',
    description:
        'The sit-up is an abdominal endurance training exercise, strengthening the abdominal muscles. It is similar to a crunch, but conditions additional muscles.',
  ),
  Task(
    icon: SportsIcons.skipping_rope,
    name: 'Skipping Rope',
    description:
        'Skipping develops foot speed, increases coordination and endurance, helping to burn calories and lose fat.',
  ),
  Task(
    icon: SportsIcons.squat,
    name: 'Squats',
    description:
        'Squats are a superb exercise to help strengthen and tone the hip and thigh muscles, like the hamstrings, quads and gluteus maximus.',
  ),
];

List<Task> sportsList = [
  Task(
    icon: SportsIcons.badminton,
    name: 'Badminton',
    description:
        'Playing badminton burns body fat, as well as 450 calories per hour. It is also fantastic for leg, core, arm and back muscles, as well as social and psychological health as a byproduct.',
  ),
  Task(
    icon: SportsIcons.basketball,
    name: 'Basketball',
    description:
        'While burning a great deal of calories, it is great for cardiovascular health, bone strength, spatial awareness and optimizes motor skills and coordination among all.',
  ),
  Task(
    icon: SportsIcons.cycling,
    name: 'Cycling',
    description:
        'Being one of the easiest to fit into daily routines, cycling is also one of the best protections from serious diseases such as stroke, heart attack and obesity.',
  ),
  Task(
    icon: SportsIcons.frisbee,
    name: 'Frisbee',
    description:
        'Frisbee provides players with definite elements of “High Intensity Interval Training” and a full body workout, hence burning more calories, increases resting metabolic rate and agility.',
  ),
  Task(
    icon: SportsIcons.handball,
    name: 'Handball',
    description:
        'Handball is a fun way to optimise cardiovascular fitness while burning calories and fat. It also teaches you to be balanced and agile, and keeps you fit as you age.',
  ),
  Task(
    icon: SportsIcons.running,
    name: 'Running',
    description:
        'Running helps build bones, strengthens muscles, improves cardiovascular fitness and burns plenty of calories in the process.',
  ),
  Task(
    icon: SportsIcons.soccer_football,
    name: 'Soccer',
    description:
        'While being a convenient sport, soccer/football raises aerobic capacity, bone strength and cardiovascular health, all while building muscle strength and self-esteem as well',
  ),
  Task(
    icon: SportsIcons.swimming,
    name: 'Swimming',
    description:
        'Swimming does not strain your skeletal system, hence being an ideal sport to work on stiff muscles and sore joints, effectively increasing muscular strength and tone.',
  ),
  Task(
    icon: SportsIcons.table_tennis,
    name: 'Table Tennis',
    description:
        'As addictive as it is, an hour of table tennis burns more than 200 calories easily. It also improves hand-eye coordination and is easy on the joints, making it an enjoyable sport.',
  ),
  Task(
    icon: SportsIcons.tennis,
    name: 'Tennis',
    description:
        'As it provides a full body workout, it improves health both aerobically and anaerobically. It also enhances flexibility, balance and coordination.',
  ),
  Task(
    icon: SportsIcons.volleyball,
    name: 'Volleyball',
    description:
        'Volleyball builds agility, coordination, speed and balance, increasing metabolic rate and aerobic ability simultaneously. Needless to say, it burns calories and fats too.',
  ),
  Task(
    icon: SportsIcons.walking,
    name: 'Walking',
    description:
        "While walking seems simple, but by walking 30 minutes everyday, your pants may begin to fit more loosely (a.k.a you've become slimmer), while slashing your risk of chronic diseases.",
  ),
];

List<Task> gymList = [
  Task(
    icon: SportsIcons.armcurl,
    name: 'Arm Curls',
    description:
        'While obviously building arm size, arm curls develop body stability and build bone and grip strength simultaneously, hence being an effective way to promote fat loss.',
  ),
  Task(
    icon: SportsIcons.arm_extension,
    name: 'Arm Extensions',
    description:
        'It is a no-no to solely work on the biceps without working on triceps, which can make up half the size of your arm. Arm extensions do exactly that.',
  ),
  Task(
    icon: SportsIcons.deadlift,
    name: 'Deadlifts',
    description:
        'Undeniably, deadlifts targets the butt and hence strengthens the gluteus maximus, translating to better endurance, power and pain prevention.',
  ),
  Task(
    icon: SportsIcons.elliptical_trainer,
    name: 'Elliptical Trainer',
    description:
        'While being easy to your joints, elliptical trainers incorporate moving poles, thus providing a full body workout. The incline and resistance can be varied, and hence is able to suit everyone easily.',
  ),
  Task(
    icon: SportsIcons.exercise_bike,
    name: 'Exercise Bike',
    // TODO: update description
    description:
        'Offering similar benefits as cycling while in your comfortable gym.',
  ),
  Task(
    icon: SportsIcons.front_raise,
    name: 'Front Raises',
    description:
        'Usually done with dumbbells, front raises tone your anterior deltoid muscles while allowing you to improve your functional ability and stabilising muscle strength.',
  ),
  Task(
    icon: SportsIcons.lat_pull_down,
    name: 'Lat Pull-Downs',
    description:
        'Lat pull-downs can be extremely beneficial in building upper body strength and keeping the shoulder healthy, targeting muscles that stabilize the spine for maximum effectiveness.',
  ),
  Task(
    icon: SportsIcons.lateral_raise,
    name: 'Lateral Raises',
    description:
        'Lateral raises offer us more than just bigger, broader, and more defined slabs of muscle onto our frames, but also offers muscle hypertrophy, greater control of full range of motion, and corrects muscle imbalances and asymmetries.',
  ),
  Task(
    icon: SportsIcons.leg_curl,
    name: 'Leg Curls',
    description:
        'Weighted reverse leg curls build knee stability and muscle balance, lowering the chance of injury. It also strengthens your smaller thigh muscles and your calf muscle, increasing your lower body strength.',
  ),
  Task(
    icon: SportsIcons.leg_extension,
    name: 'Leg Extensions',
    description:
        'While only targeting your quadriceps, leg extensions strengthens key attachments for the knee joints at the same time. Simple, yet effective.',
  ),
  Task(
    icon: SportsIcons.leg_press,
    name: 'Leg Presses',
    description:
        'Leg presses are great for adding pure size to your legs, and takes a load off the back as it does not require direct pressure on the back.',
  ),
  Task(
    icon: SportsIcons.pull_up,
    name: 'Pull-Ups',
    description:
        'This exercise in a fundamental compound upper-body exercise, targeting the back and biceps, and also increases grip strength, undeniably losing fat in the process.',
  ),
  Task(
    icon: SportsIcons.rowing_machine,
    name: 'Rowing Machine',
    description:
        'This is an effective aerobic exercise, requiring the use of many major muscle groups, making it effective in raising heart rates and hence oxygen intake for an effective cardio workout.',
  ),
  Task(
    icon: SportsIcons.shoulder,
    name: 'Shoulder Presses',
    description:
        'Shoulder presses allow us to build bigger deltoids (a major muscle group in the shoulder), get wider shoulders, work the stabilizer muscles and achieve symmetry.',
  ),
  Task(
    icon: SportsIcons.step_machine,
    name: 'Step Machine',
    description:
        'This exercise is a low-impact workout, hence there will be no strains on your knees. Even so, it is very effective in building lower body strength and burning calories simultaneously.',
  ),
  Task(
    icon: SportsIcons.treadmill,
    name: 'Treadmill',
    description:
        'Treadmill walking helps you to maintain a healthy musculoskeletal system, keeps the joints flexible, and keeps your metabolic rate up. It is also more convenient as you do not need to worry about external disruptions (weather, outdoor air quality).',
  ),
  Task(
    icon: SportsIcons.weight_machine,
    name: 'Weight Machine',
    description:
        'Using weightlifting machines focuses not only on the health benefits, but also on developing definition in specific muscles. It is also efficient as it places resistance specifically on the contractile element of muscle.',
  ),
];

List<Task> allTasks = commonList + sportsList + gymList;

List<Task> hiddenList = [
  Task(
    icon: SportsIcons.running,
    name: 'Stationary Jogging',
    description: '',
  ),
  Task(
    icon: SportsIcons.lunge,
    name: "Runner's Stretch",
    description: '',
  ),
  Task(
    icon: SportsIcons.lunge,
    name: "The Bound Angle",
    description: '',
  ),
  Task(
    icon: SportsIcons.lunge,
    name: "Seated Back Twist",
    description: '',
  ),
  Task(
    icon: SportsIcons.lunge,
    name: "Standing Side Stretch",
    description: '',
  ),
  Task(
    icon: SportsIcons.lunge,
    name: "Forward Hang",
    description: '',
  ),
  Task(
    icon: SportsIcons.running,
    name: 'Shuttle Run',
    description: '',
  ),
  Task(
    icon: SportsIcons.squat,
    name: 'Standing Broad Jump',
    description: '',
  ),
  Task(
    icon: SportsIcons.running,
    name: '2.4km Run',
    description: '',
  ),
];
