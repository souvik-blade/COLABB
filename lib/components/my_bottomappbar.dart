import '../pages/assignments_page.dart';
import '../pages/home_page.dart';
import '../pages/mentor_grouppage.dart';
import '../pages/schedule_page.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  int currentIndex = 0;

  Widget childWidget = const Text("Hello");

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[500],
        currentIndex: currentIndex,
        onTap: (value) {
          currentIndex = value;
          _pageController.animateToPage(
            value,
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
          );

          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "First",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: "Second",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Third",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Third",
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            currentIndex = page;
          });
        },
        children: <Widget>[
          HomePage(),
          const AssignmentPage(),
          const AssignmentPage(),
          const SchedulePage(),
        ],
      ),
    );
  }
}

class MyBottomAppBar extends StatefulWidget {
  MyBottomAppBar({super.key});

  @override
  State<MyBottomAppBar> createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          label: "",
          icon: Icon(Icons.home_outlined),
        ),
        BottomNavigationBarItem(
          label: "",
          icon: Icon(Icons.view_timeline_outlined),
        ),
        BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.assignment_outlined),
            backgroundColor: Colors.amber),
        BottomNavigationBarItem(
          icon: Icon(Icons.star, color: Colors.green),
          label: ('Green'),
        )
      ],
      currentIndex: _currentIndex,

      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      //type: BottomNavigationBarType.fixed,
    );
  }

  void _navigateTo(BuildContext context, String routeName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    // Only navigate if the current route is different from the desired route
    if (currentRoute != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }
}
