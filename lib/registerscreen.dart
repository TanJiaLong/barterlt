import 'dart:convert';

import 'package:barterlt/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController phoneEditingController = TextEditingController();
  final TextEditingController password1EditingController =
      TextEditingController();
  final TextEditingController password2EditingController =
      TextEditingController();
  String eula = "";
  late double screenHeight, screenWidth;
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible1 = true, passwordVisible2 = true;
  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.3,
              width: screenWidth,
              child: Image.asset(
                "assets/images/register.webp",
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameEditingController,
                            validator: (val) => val!.isEmpty || (val.length < 5)
                                ? "Name must be longer than 5 characters"
                                : null,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: "Name",
                              icon: Icon(Icons.people),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: emailEditingController,
                            validator: (val) => val!.isEmpty ||
                                    !val.contains("@") ||
                                    !val.contains(".")
                                ? "Please enter a valid email"
                                : null,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              icon: Icon(Icons.people),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: phoneEditingController,
                            validator: (val) => val!.isEmpty ||
                                    (val.length < 10)
                                ? "Phone Number must be longer or equal than 10 characters"
                                : null,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: "Phone Number",
                              icon: Icon(Icons.phone),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: password1EditingController,
                            validator: (val) => val!.isEmpty || (val.length < 5)
                                ? "Password must be longer than 5 characters"
                                : null,
                            keyboardType: TextInputType.name,
                            obscureText: passwordVisible1,
                            decoration: InputDecoration(
                              labelText: "Password",
                              icon: const Icon(Icons.lock),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                              ),
                              suffixIcon: IconButton(
                                  icon: Icon(passwordVisible1
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible1 = !passwordVisible1;
                                    });
                                  }),
                            ),
                          ),
                          TextFormField(
                            controller: password2EditingController,
                            validator: (val) => val!.isEmpty || (val.length < 5)
                                ? "Password must be longer than 5 characters"
                                : null,
                            keyboardType: TextInputType.name,
                            obscureText: passwordVisible2,
                            decoration: InputDecoration(
                              labelText: "Re-enter Password",
                              icon: const Icon(Icons.lock),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                              ),
                              suffixIcon: IconButton(
                                  icon: Icon(passwordVisible2
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible2 = !passwordVisible2;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Checkbox(value: isAgree, onChanged: agreeTerms),
                              GestureDetector(
                                onTap: showEula,
                                child: const Text('Agree with terms'),
                              ),
                              ElevatedButton(
                                  onPressed: onRegisterDialog,
                                  child: const Text("Register")),
                            ],
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void agreeTerms(bool? value) {
    if (!isAgree) {}
    setState(() {
      isAgree = value!;
    });
  }

  void onRegisterDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (!isAgree) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please agree with terms and conditions")));
      return;
    }
    String pass1 = password1EditingController.text;
    String pass2 = password2EditingController.text;
    if (pass1 != pass2) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your password")));
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Are you sure"),
            content: const Text("Register new account?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onRegister();
                  },
                  child: const Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
            ],
          );
        });
  }

  void onRegister() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Registration..."),
        );
      },
    );
    String name = nameEditingController.text;
    String email = emailEditingController.text;
    String phone = phoneEditingController.text;
    String password = password1EditingController.text;

    http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/register_user.php"),
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Success")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Failed")));
        }
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Registration Failed")));
        Navigator.pop(context);
      }
    });
  }

  void showEula() {}
}
