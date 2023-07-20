import 'dart:convert';
import 'dart:math';

import 'package:barterlt/loginscreen.dart';
import 'package:barterlt/models/user.dart';
import 'package:barterlt/myconfig.dart';
import 'package:barterlt/registerscreen.dart';
import 'package:barterlt/screens/updateprofilescreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late double screenHeight, screenWidth;
  User currentUser = User();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: screenHeight * 0.25,
              width: screenWidth,
              child: Card(
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(8),
                      width: screenWidth * 0.4,
                      child: Image.asset("assets/images/profile.png"),
                    ),
                    Expanded(
                        child: currentUser.id == "na"
                            ? const Text(
                                "Guest",
                                style: TextStyle(fontSize: 32),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // widget.user.name.toString(),
                                    currentUser.name.toString(),
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                  Text(
                                    // widget.user.email.toString(),
                                    currentUser.email.toString(),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    // widget.user.phone.toString(),
                                    currentUser.phone.toString(),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    // widget.user.datereg.toString(),
                                    currentUser.datereg.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ))
                  ],
                ),
              ),
            ),
            const Text(
              "PROFILE",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // widget.user.id == "na"
            currentUser.id == "na"
                ? Column(
                    children: [
                      SizedBox(
                        width: screenWidth,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const LoginScreen())));
                          },
                          child: const Text("LOGIN"),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        width: screenWidth,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const RegisterScreen())));
                          },
                          child: const Text("REGISTER ACCOUNT"),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                        width: screenWidth,
                        child: MaterialButton(
                          onPressed: () async {
                            final updatedUser = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateProfileScreen(
                                        user: currentUser)));

                            if (updatedUser != null) {
                              currentUser = updatedUser as User;
                              setState(() {});
                            } else {
                              //User click back button from update profile page
                              //Do not do anything
                            }
                          },
                          child: const Text("UPDATE PROFILE"),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        width: screenWidth,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => const LoginScreen()));
                          },
                          child: const Text("LOGOUT"),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
