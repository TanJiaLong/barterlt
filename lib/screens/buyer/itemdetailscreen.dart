import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:barterlt/models/cart.dart';
import 'package:barterlt/models/item.dart';
import 'package:barterlt/models/user.dart';
import 'package:barterlt/myconfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ItemDetailScreen extends StatefulWidget {
  final User user;
  final Item item;
  const ItemDetailScreen({super.key, required this.user, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final dateFormat = DateFormat('dd-MM-yyyy hh:mm a');
  final List<File?> _images = List.generate(3, (index) => null);

  late double screenHeight, screenWidth, cardwitdh;

  //actual quantity of items
  int itemQuantity = 0;
  //quantity of items added to cart
  int cartItemQuantity = 1;
  //quantity of items added to cart in database
  int itemQuantityInDB = 0;

  double totalPrice = 0;
  double singlePrice = 0;
  @override
  void initState() {
    super.initState();
    checkBuyerCart();
    itemQuantity = int.parse(widget.item.itemQuantity.toString());
    totalPrice = double.parse(widget.item.itemValue.toString());
    singlePrice = double.parse(widget.item.itemValue.toString());
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Column(
        children: [
          Text(
            "$itemQuantityInDB in cart",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Flexible(
            flex: 4,
            child: Container(
              height: 270,
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    _images.length,
                    (index) {
                      return Column(
                        children: [
                          SizedBox(
                            width: screenWidth / 1.1,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachedNetworkImage(
                                  height: 230,
                                  fit: BoxFit.contain,
                                  imageUrl:
                                      "${MyConfig().server}/mobileprogramming/barterlt/assets/items/${widget.item.itemId}-${index + 1}.png",
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Mid term (before modification)
                // [
                //   buildScrollableImage(1),
                //   const SizedBox(
                //     width: 12,
                //   ),
                //   buildScrollableImage(2),
                //   const SizedBox(
                //     width: 12,
                //   ),
                //   buildScrollableImage(3),
                //   const SizedBox(
                //     width: 12,
                //   ),
                // ],
                //),
                // SizedBox(
                //   width: screenWidth,
                //   child: CachedNetworkImage(
                //     height: 340,
                //     fit: BoxFit.contain,
                //     imageUrl:
                //         "${MyConfig().server}/mobileprogramming/barterlt/assets/items/${widget.item.itemId}-1.png",
                //     placeholder: (context, url) =>
                //         const LinearProgressIndicator(),
                //     errorWidget: (context, url, error) => const Icon(Icons.error),
                //   ),
                // ),
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.item.itemName.toString(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(6),
                },
                children: [
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "Description",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        widget.item.itemDesc.toString(),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "Item Category",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        widget.item.itemCategory.toString(),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "Item Quantity",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        '${widget.item.itemQuantity.toString()} available',
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "Item Value",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'RM ${widget.item.itemValue.toString()}',
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "Upload Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        dateFormat.format(
                            DateTime.parse(widget.item.regDate.toString())),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "Upload Location",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child:
                          Text('${widget.item.locality}, ${widget.item.state}'),
                    ),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    minusCartQuantity();
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  cartItemQuantity.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    addCartQuantity();
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Text(
            "RM ${totalPrice.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
              onPressed: () {
                if (itemQuantityInDB >= itemQuantity) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Max quantity of item reached in cart")));
                  return;
                }
                addToCartDialog();
              },
              child: const Text("Add to Cart"))
        ],
      ),
    );
  }

  void minusCartQuantity() {
    if (itemQuantityInDB >= itemQuantity) {
      return;
    }

    if (cartItemQuantity <= 1) {
      cartItemQuantity = 1;
      totalPrice = singlePrice * cartItemQuantity;
    } else {
      cartItemQuantity = cartItemQuantity - 1;
      totalPrice = singlePrice * cartItemQuantity;
    }
    setState(() {});
  }

  void addCartQuantity() {
    //cart in database equal to quantity of that item
    if (itemQuantityInDB >= itemQuantity) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Max quantity of item reached in cart")));
      return;
    }

    if (cartItemQuantity + itemQuantityInDB >= itemQuantity) {
      cartItemQuantity = itemQuantity - itemQuantityInDB;
      totalPrice = singlePrice * cartItemQuantity;
    } else {
      cartItemQuantity = cartItemQuantity + 1;
      totalPrice = singlePrice * cartItemQuantity;
    }
    setState(() {});
  }

  void addToCartDialog() {
    if (widget.user.id.toString() == "na") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please register to add item to cart")));
      return;
    }
    if (widget.user.id.toString() == widget.item.userId.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Owner cannot add his own items to cart")));
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add To Cart?"),
            content: const Text("Are you sure?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  addToCart();
                  Navigator.pop(context);
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),
            ],
          );
        });
  }

  void addToCart() {
    http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/add_to_cart.php"),
        body: {
          "cartItemId": widget.item.itemId.toString(),
          "cartQuantity": cartItemQuantity.toString(),
          "cartPrice": totalPrice.toString(),
          "cartUserId": widget.user.id.toString(),
          "cartSellerId": widget.item.userId.toString()
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Add to cart success")));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Json Status Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("HTTP ERROR")));
      }
    });
  }

  //To avoid the user can add exceed the quantity of the item
  //Just check the quantity of items in tbl_carts
  Future<void> checkBuyerCart() async {
    await http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/check_buyer_cart.php"),
        body: {
          "itemId": widget.item.itemId,
          "cartBuyerId": widget.user.id,
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          itemQuantityInDB = int.parse(jsondata['itemQuantityInCart']);
        }
      }
    });
    setState(() {});
  }
}
