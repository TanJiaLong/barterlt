import 'package:barterlt/models/user.dart';
import 'package:barterlt/screens/seller/itemscreen.dart';
import 'package:barterlt/screens/messagescreen.dart';
import 'package:barterlt/screens/profilescreen.dart';
import 'package:barterlt/screens/ratingscreen.dart';
import 'package:barterlt/screens/buyer/searchscreen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Barter";

  @override
  void initState() {
    super.initState();
    tabchildren = <Widget>[
      SearchScreen(user: widget.user),
      ItemScreen(user: widget.user),
      ProfileScreen(user: widget.user)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Barter",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: "Item",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Barter";
      }
      if (_currentIndex == 1) {
        maintitle = "Item";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
    });
  }
}
