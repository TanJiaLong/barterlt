import 'dart:convert';
import 'dart:developer';
import 'package:barterlt/models/item.dart';
import 'package:barterlt/screens/seller/sellerorderdetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:barterlt/models/order.dart';
import 'package:barterlt/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterlt/myconfig.dart';

class SellerOrderScreen extends StatefulWidget {
  final User user;
  const SellerOrderScreen({super.key, required this.user});

  @override
  State<SellerOrderScreen> createState() => _SellerOrderScreenState();
}

class _SellerOrderScreenState extends State<SellerOrderScreen> {
  String status = "Loading...";
  List<Order> orderList = <Order>[];
  List<Item> itemList = <Item>[];
  late double screenHeight, screenWidth, cardwitdh;

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
                child: Text("No order yet"),
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
                              )),
                          // Expanded(
                          //   flex: 3,
                          //   child: Row(children: [
                          //     IconButton(
                          //       icon: const Icon(Icons.notifications),
                          //       onPressed: () {},
                          //     ),
                          //     IconButton(
                          //       icon: const Icon(Icons.search),
                          //       onPressed: () {},
                          //     ),
                          //   ]),
                          // )
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your Current Order/s (${orderList.length})",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: orderList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () async {
                                Order myorder =
                                    Order.fromJson(orderList[index].toJson());
                                Item currentItem = itemList[index];
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            SellerOrderDetailScreen(
                                              item: currentItem,
                                              order: myorder,
                                            )));
                                loadsellerorders();
                              },
                              leading: CircleAvatar(
                                  child: Text((index + 1).toString())),
                              title: Text(
                                  "Receipt: ${orderList[index].orderBill}"),
                              trailing: const Icon(Icons.arrow_forward),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                          })),
                ],
              ),
      ),
    );
  }

  void loadsellerorders() {
    http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/load_seller_order.php"),
        body: {"sellerid": widget.user.id}).then((response) {
      log(response.body);
      // orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success" && jsondata['orders'] != null) {
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
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("No order yet")));
        }
        setState(() {});
      }
    });
  }
}
