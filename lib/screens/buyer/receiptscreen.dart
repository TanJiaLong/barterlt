import 'dart:async';

import 'package:barterlt/models/item.dart';
import 'package:barterlt/models/order.dart';
import 'package:barterlt/models/user.dart';
import 'package:flutter/material.dart';

class ReceiptScreen extends StatefulWidget {
  final bool status;
  final Item item;
  final User user;
  final Order order;
  const ReceiptScreen(
      {super.key,
      required this.status,
      required this.item,
      required this.user,
      required this.order});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  late double screenHeight, screenWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Text(
              "Order Details",
              style: TextStyle(fontSize: 24),
            ),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(color: Colors.black, width: 0.5),
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(6),
              },
              children: [
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.user.name.toString()),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Email",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.user.email.toString()),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Phone",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.user.phone.toString()),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Payment Amount",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "RM ${double.parse(widget.order.orderAmount.toString()).toStringAsFixed(2)}"),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Payment Status",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    TableCell(
                      child: widget.status == true
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Successful",
                                style: TextStyle(color: Colors.green),
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Failed",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
