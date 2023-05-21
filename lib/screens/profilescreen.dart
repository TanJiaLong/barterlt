import 'package:barterlt/loginscreen.dart';
import 'package:barterlt/models/user.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late double screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            height: screenHeight * 0.4,
            width: screenWidth,
            child: Card(
              elevation: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    width: screenWidth * 0.4,
                    child: Image.asset("assets/images/profile.png"),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        widget.user.name.toString(),
                        style: const TextStyle(fontSize: 32),
                      ),
                      Text(widget.user.email.toString()),
                      Text(widget.user.phone.toString()),
                      Text(widget.user.datereg.toString()),
                    ],
                  ))
                ],
              ),
            ),
          ),
          const Text(
            "Profile",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const LoginScreen())));
            },
            child: const Text("Logout"),
          )
        ],
      ),
    );
  }
}