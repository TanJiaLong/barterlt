import 'package:barterlt/models/user.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final User user;
  const MessageScreen({super.key, required this.user});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text("Message Screen"),
    );
  }
}
