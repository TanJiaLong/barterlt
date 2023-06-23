import 'dart:convert';

import 'package:barterlt/models/user.dart';
import 'package:barterlt/myconfig.dart';
import 'package:barterlt/registerscreen.dart';
import 'package:barterlt/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenHeight, screenWidth;
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isRemember = false;
  bool passwordVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.3,
              width: screenWidth,
              child: Image.asset(
                "assets/images/login.webp",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Card(
                elevation: 10,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailEditingController,
                        validator: (val) => val!.isEmpty ||
                                !val.contains("@") ||
                                !val.contains(".")
                            ? "Please enter a valid email"
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          icon: Icon(Icons.email),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        controller: passwordEditingController,
                        validator: (val) => val!.isEmpty || (val.length < 5)
                            ? "password must be longer than 5"
                            : null,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          labelText: "Password",
                          icon: const Icon(Icons.lock),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 3),
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              }),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Checkbox(
                              value: isRemember,
                              onChanged: (bool? value) {
                                saveprefs(value!);
                                setState(() {
                                  isRemember = value;
                                });
                              }),
                          const Text("Remember me"),
                          ElevatedButton(
                              onPressed: toLogin, child: const Text("LOGIN")),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: toRegister,
              child: const Text("New Accounts?"),
            ),
            GestureDetector(
              onTap: toForgotPassword,
              child: const Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }

  void toLogin() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }

    String email = emailEditingController.text;
    String password = passwordEditingController.text;
    http.post(
        Uri.parse(
            '${MyConfig().server}/mobileprogramming/barterlt/php/login_user.php'),
        body: {
          'email': email,
          'password': password,
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          User user = User.fromJson(jsondata['data']);

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login success")));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MainScreen(user: user)));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login failed")));
        }
      }
    });
  }

  void toRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()));
  }

  void toForgotPassword() {}

  void saveprefs(bool value) async {
    String email = emailEditingController.text;
    String password = passwordEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value) {
      if (!_formKey.currentState!.validate()) {
        isRemember = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool('checkbox', value);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Stored")));
    } else {
      await prefs.setString('email', "");
      await prefs.setString('password', "");
      await prefs.setBool('checkbox', false);
      setState(() {
        emailEditingController.text = "";
        passwordEditingController.text = "";
        isRemember = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Removed")));
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    isRemember = (prefs.getBool('checkbox')) ?? false;
    if (isRemember) {
      setState(() {
        emailEditingController.text = email;
        passwordEditingController.text = password;
      });
    }
  }
}
