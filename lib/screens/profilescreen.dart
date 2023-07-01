import 'package:barterlt/loginscreen.dart';
import 'package:barterlt/models/user.dart';
import 'package:barterlt/registerscreen.dart';
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
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.name.toString(),
                          style: const TextStyle(fontSize: 32),
                        ),
                        Text(
                          widget.user.email.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          widget.user.phone.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          widget.user.datereg.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
            const Text(
              "Profile",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            widget.user.id == "na"
                ? Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const LoginScreen())));
                        },
                        child: Container(
                          height: screenHeight * 0.05,
                          width: screenWidth,
                          color: const Color.fromARGB(255, 165, 218, 243),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      const RegisterScreen())));
                        },
                        child: Container(
                          height: screenHeight * 0.05,
                          width: screenWidth,
                          color: const Color.fromARGB(255, 165, 218, 243),
                          child: const Center(
                            child: Text(
                              "Register Account",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const LoginScreen())));
                    },
                    child: Container(
                      height: screenHeight * 0.05,
                      width: screenWidth,
                      color: const Color.fromARGB(255, 165, 218, 243),
                      child: const Center(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
