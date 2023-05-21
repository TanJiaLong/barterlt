import 'package:barterlt/models/user.dart';
import 'package:barterlt/screens/itemscreen.dart';
import 'package:barterlt/screens/messagescreen.dart';
import 'package:barterlt/screens/profilescreen.dart';
import 'package:barterlt/screens/ratingscreen.dart';
import 'package:barterlt/screens/searchscreen.dart';
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
  String maintitle = "Items";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabchildren = <Widget>[
      ItemScreen(user: widget.user),
      SearchScreen(user: widget.user),
      MessageScreen(user: widget.user),
      RatingScreen(user: widget.user),
      ProfileScreen(user: widget.user)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(maintitle)),
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: "Items",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Message",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Rating",
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
        maintitle = "Items";
      }
      if (_currentIndex == 1) {
        maintitle = "Searches";
      }
      if (_currentIndex == 2) {
        maintitle = "Messages";
      }
      if (_currentIndex == 3) {
        maintitle = "Rating";
      }
      if (_currentIndex == 3) {
        maintitle = "Profile";
      }
    });
  }
}
