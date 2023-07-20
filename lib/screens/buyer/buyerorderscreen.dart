import 'dart:convert';
import 'dart:developer';
import 'package:barterlt/models/item.dart';
import 'package:barterlt/screens/buyer/buyerorderdetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:barterlt/models/order.dart';
import 'package:barterlt/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterlt/myconfig.dart';

class BuyerOrderScreen extends StatefulWidget {
  final User user;
  const BuyerOrderScreen({super.key, required this.user});

  @override
  State<BuyerOrderScreen> createState() => _BuyerOrderScreenState();
}

class _BuyerOrderScreenState extends State<BuyerOrderScreen> {
  late double screenHeight, screenWidth, cardwitdh;

  String status = "Loading...";
  List<Order> orderList = <Order>[];
  List<Item> itemList = <Item>[];
  @override
  void initState() {
    super.initState();
    loadsellerorders();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Your Order")),
      body: Container(
        child: orderList.isEmpty
            ? const Center(
                child: Text("No Order Available"),
              )
            : Column(
                children: [
                  SizedBox(
                    width: screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 7,
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundImage: AssetImage(
                                    "assets/images/profile.png",
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Hello ${widget.user.name}!",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text("Your Current Order"),
                  Expanded(
                    child: ListView.builder(
                        itemCount: orderList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () async {
                              Order myorder = orderList[index];
                              Item currentItem = itemList[index];
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) =>
                                          BuyerOrderDetailScreen(
                                            item: currentItem,
                                            order: myorder,
                                          )));
                              loadsellerorders();
                            },
                            leading: CircleAvatar(
                                child: Text((index + 1).toString())),
                            title:
                                Text("Receipt: ${orderList[index].orderBill}"),
                            trailing: const Icon(Icons.arrow_forward),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Order ID: ${orderList[index].orderId}"),
                                      Text(
                                          "Status: ${orderList[index].orderStatus}")
                                    ]),
                                Column(
                                  children: [
                                    Text(
                                      "RM ${double.parse(orderList[index].orderAmount.toString()).toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text("")
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
      ),
    );
  }

  void loadsellerorders() {
    http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/load_buyer_order.php"),
        body: {"buyerid": widget.user.id}).then((response) {
      log(response.body);
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          orderList.clear();
          var extractOrder = jsondata['orders'];
          extractOrder['orders'].forEach((v) {
            orderList.add(Order.fromJson(v));
          });
          var extractItem = jsondata['items'];
          extractItem['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
        } else {
          status = "Please register an account first";
          setState(() {});
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("No order found")));
        }
        setState(() {});
      }
    });
  }
}
