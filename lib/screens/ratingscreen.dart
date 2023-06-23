import 'package:barterlt/models/user.dart';
import 'package:flutter/material.dart';

class RatingScreen extends StatefulWidget {
  final User user;
  const RatingScreen({super.key, required this.user});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Rating Screen"),
    );
  }
}
