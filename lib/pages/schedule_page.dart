import 'schedule_days/friday.dart';
import 'schedule_days/monday.dart';
import 'schedule_days/thurdsay.dart';
import 'schedule_days/tuesday.dart';
import 'schedule_days/wednesday.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  static const String id = "scheduleid";

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    // int todaysIndex = DateTime.now().weekday.toInt();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text(
          " Schedule",
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        // color: Colors.blue,
        width: double.maxFinite,
        // height: 600,
        child: ContainedTabBarView(
          tabBarProperties: TabBarProperties(
            indicatorColor: Color(0XFF9e8cf2),
            labelColor: Color(0XFF9e8cf2),
          ),
          tabBarViewProperties:
              const TabBarViewProperties(physics: BouncingScrollPhysics()),
          // initialIndex: todaysIndex,
          tabs: const [
            Text('Monday', style: TextStyle(fontSize: 16)),
            Text('Tuesday', style: TextStyle(fontSize: 16)),
            Text('Wednesday', style: TextStyle(fontSize: 16)),
            Text('Thursday', style: TextStyle(fontSize: 16)),
            Text('Friday', style: TextStyle(fontSize: 16)),
          ],
          views: const [
            Monday(),
            Tuesday(),
            Wednesday(),
            Thursday(),
            Friday(),
          ],
        ),
      ),
    );
  }
}
