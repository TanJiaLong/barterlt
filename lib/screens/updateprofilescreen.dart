import 'dart:convert';
import 'dart:developer';

import 'package:barterlt/models/user.dart';
import 'package:barterlt/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateProfileScreen extends StatefulWidget {
  final User user;
  const UpdateProfileScreen({super.key, required this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late double screenHeight, screenWidth;

  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController phoneEditingController = TextEditingController();
  final TextEditingController password1EditingController =
      TextEditingController();
  final TextEditingController password2EditingController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool passwordVisible1 = true, passwordVisible2 = true;

  @override
  void initState() {
    super.initState();
    nameEditingController.text = widget.user.name.toString();
    emailEditingController.text = widget.user.email.toString();
    phoneEditingController.text = widget.user.phone.toString();
    password1EditingController.text = widget.user.password.toString();
    password2EditingController.text = widget.user.password.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
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
                          validator: (val) => val!.isEmpty || (val.length < 10)
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: screenWidth * 0.8,
              child: ElevatedButton(
                  onPressed: onUpdateProfileDialog,
                  child: const Text("Update")),
            ),
          ],
        ),
      ),
    );
  }

  void onUpdateProfileDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (password1EditingController.text != password2EditingController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your password")));
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Update Profile?"),
            content: const Text("Are you sure?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    updateProfile();
                  },
                  child: const Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"))
            ],
          );
        });
  }

  void updateProfile() {
    String name = nameEditingController.text;
    String email = emailEditingController.text;
    String phone = phoneEditingController.text;
    String password = password1EditingController.text;

    http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/update_profile.php"),
        body: {
          'id': widget.user.id,
          'name': name,
          'email': email,
          'phone': phone,
          'password': password
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          //return updated user object to previous route(page)
          User updatedUser = User(
              id: widget.user.id,
              name: name,
              email: email,
              phone: phone,
              password: password,
              datereg: widget.user.datereg);
          Navigator.pop(context, updatedUser);

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
      }
    });
  }
}
