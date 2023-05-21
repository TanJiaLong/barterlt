import 'package:barterlt/models/user.dart';
import 'package:flutter/material.dart';

class ItemScreen extends StatefulWidget {
  final User user;
  const ItemScreen({super.key, required this.user});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text("Item Screen"),
    );
  }
}
