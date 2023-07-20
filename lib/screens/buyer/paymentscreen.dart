import 'dart:convert';
import 'dart:developer';

import 'package:barterlt/models/cart.dart';
import 'package:barterlt/models/item.dart';
import 'package:barterlt/models/order.dart';
import 'package:barterlt/models/user.dart';
import 'package:barterlt/myconfig.dart';
import 'package:barterlt/screens/buyer/receiptscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  final User user;
  final Item item;
  final Cart cart;
  const PaymentScreen(
      {super.key, required this.user, required this.item, required this.cart});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late double screenHeight;

  late bool status;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Emulated Payment Screen"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 0.2 * screenHeight,
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.storefront_sharp),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "JL Bank (286576)",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "+6012-6598324 | jialong999999999@gmail.com",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Text(
            "BARTER IT",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 1),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Payment for order by ${widget.user.name}"),
              const Divider(),
              Text("Name: ${widget.user.name.toString().toUpperCase()}"),
              Text("Email: ${widget.user.email.toString()}"),
              const Divider(),
              const Text(
                "Total:",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "RM ${widget.cart.cartPrice}",
                style: const TextStyle(fontSize: 27),
              ),
              const Divider(),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: () {
                status = true;
                toReceiptPage(status);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text("Successful Payment"),
            ),
          ),
          SizedBox(
            width: 250,
            child: ElevatedButton(
                onPressed: () {
                  status = false;
                  toReceiptPage(status);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text("Failure Payment")),
          ),
        ],
      ),
    );
  }

  void toReceiptPage(bool status) {
    String orderBill = "B${widget.cart.cartId}";
    http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/receipt.php"),
        body: {
          "status": status.toString(),
          "cartId": widget.cart.cartId,
          "orderBill": orderBill,
          "itemId": widget.cart.cartItemId,
          "itemQuantity": widget.item.itemQuantity,
          "itemValue": widget.item.itemValue,
          "orderQuantity": widget.cart.cartQuantity,
          "orderAmount": widget.cart.cartPrice,
          "orderUserId": widget.cart.cartUserId,
          "orderSellerId": widget.cart.cartSellerId,
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          //Failed Payment
          if (status == false) {
            Order currentOrder = Order(
                orderId: "na",
                orderBill: "na",
                orderItemId: widget.cart.cartItemId,
                orderQuantity: widget.cart.cartQuantity,
                orderAmount: widget.cart.cartPrice,
                orderUserId: widget.cart.cartUserId,
                orderSellerId: widget.cart.cartSellerId,
                orderDate: "na");

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ReceiptScreen(
                    status: status,
                    user: widget.user,
                    item: widget.item,
                    order: currentOrder),
              ),
            );
            return;
          }
          //Success Payment
          else {
            Order currentOrder = Order.fromJson(jsondata['data']);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ReceiptScreen(
                    status: status,
                    user: widget.user,
                    item: widget.item,
                    order: currentOrder),
              ),
            );
          }
        }
      }
    });
  }
}
