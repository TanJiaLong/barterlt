import 'dart:convert';
import 'dart:developer';

import 'package:barterlt/models/cart.dart';
import 'package:barterlt/models/item.dart';
import 'package:barterlt/models/user.dart';
import 'package:barterlt/myconfig.dart';
import 'package:barterlt/screens/buyer/paymentscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BuyerCartScreen extends StatefulWidget {
  final User user;
  const BuyerCartScreen({super.key, required this.user});

  @override
  State<BuyerCartScreen> createState() => _BuyerCartScreenState();
}

class _BuyerCartScreenState extends State<BuyerCartScreen> {
  late double screenHeight, screenWidth;

  List<Cart> cartList = <Cart>[];
  List<Item> itemList = <Item>[];

  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        actions: [
          IconButton(
              onPressed: () {
                clearCartDialog();
              },
              icon: const Icon(Icons.remove_shopping_cart))
        ],
      ),
      body: cartList.isEmpty
          // Impossible because empty cart cannot enter this page
          ? const Center(
              child: Text("No items in the cart"),
            )
          : Column(
              children: [
                Expanded(
                  child: Container(
                    color: const Color.fromARGB(255, 214, 234, 244),
                    padding: const EdgeInsets.all(4),
                    child: ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            //check out
                            checkOutDialog(index);
                          },
                          onLongPress: () {
                            //delete cart
                            deleteCartDialog(index);
                          },
                          child: Card(
                              child: Container(
                            height: screenHeight / 7.5,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  width: screenWidth / 3,
                                  fit: BoxFit.contain,
                                  imageUrl:
                                      "${MyConfig().server}/mobileprogramming/barterlt/assets/items/${cartList[index].cartItemId}-1.png",
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Text(
                                            itemList[index].itemName.toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Text(
                                            "RM ${(double.parse(itemList[index].itemValue.toString()) * int.parse(cartList[index].cartQuantity.toString())).toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  minusCartQuantity(index);
                                                },
                                                icon: const Icon(Icons.remove),
                                              ),
                                              Text(
                                                cartList[index]
                                                    .cartQuantity
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  addCartQuantity(index);
                                                },
                                                icon: const Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        );
                      },
                    ),
                  ),
                ),
                // Total Price
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: screenHeight / 15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Price: RM ${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),
              ],
            ),
    );
  }

  Future<void> loadCart() async {
    //need to add await because we need to wait for the data returned
    //to be loaded
    await http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/load_cart.php"),
        body: {
          "cart_userId": widget.user.id,
        }).then((response) {
      // log(response.body);
      itemList.clear();
      cartList.clear();

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          //For Item List
          var extractItemData = jsondata['itemData'];
          extractItemData['items'].forEach((element) {
            itemList.add(Item.fromJson(element));
          });
          //For Cart List
          var extractCartData = jsondata['cartData'];
          extractCartData['carts'].forEach((element) {
            cartList.add(Cart.fromJson(element));
          });
          totalPrice = 0;
          //Calculate the total price
          for (var element in cartList) {
            totalPrice =
                totalPrice + double.parse(element.cartPrice.toString());
          }

          // for (Cart cart in cartList) {
          //   //Item Single Price
          //   itemPriceList.add(double.parse(cart.cartPrice.toString()) /
          //       int.parse(cart.cartQuantity.toString()));
          //   //Item Quantity
          //   itemQuantityList.add(int.parse(cart.cartQuantity.toString()));
          // }
        } else {}
      } else {}
    });
    setState(() {});
  }

  void minusCartQuantity(int index) {
    int cartQuantity = int.parse(cartList[index].cartQuantity.toString());
    // int itemQuantity = int.parse(itemList[index].itemQuantity.toString());
    double itemPrice = double.parse(itemList[index].itemValue.toString());
    double totalPrice;

    if (cartQuantity <= 1) {
      cartQuantity = 1;
      totalPrice = cartQuantity * itemPrice;
    } else {
      cartQuantity = cartQuantity - 1;
      totalPrice = cartQuantity * itemPrice;
    }
    //Change in database
    updateCart(index, cartQuantity, totalPrice);
    setState(() {});
  }

  void addCartQuantity(int index) {
    int cartQuantity = int.parse(cartList[index].cartQuantity.toString());
    int itemQuantity = int.parse(itemList[index].itemQuantity.toString());

    //if item in cart more than or equal to item quantity
    if (cartQuantity >= itemQuantity) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Max quantity of item reached in cart")));
      return;
    }
    double itemPrice = double.parse(itemList[index].itemValue.toString());
    double totalPrice;

    if (cartQuantity >= itemQuantity) {
      cartQuantity = itemQuantity;
      totalPrice = cartQuantity * itemPrice;
    } else {
      cartQuantity = cartQuantity + 1;
      totalPrice = cartQuantity * itemPrice;
    }
    updateCart(index, cartQuantity, totalPrice);
    setState(() {});
  }

  void updateCart(int index, int newQuantity, double newPrice) {
    http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/update_cart.php"),
        body: {
          "cartId": cartList[index].cartId.toString(),
          "newQuantity": newQuantity.toString(),
          "newPrice": newPrice.toString()
        }).then((response) {
      // log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          loadCart();
        }
      }
    });
  }

  void deleteCartDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${itemList[index].itemName.toString()}?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteCart(index);
                //registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteCart(int index) {
    http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/delete_cart.php"),
        body: {"cartId": cartList[index].cartId}).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          loadCart();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Delete Failed")));
      }
    });
  }

  void clearCartDialog() {
    if (cartList.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No item in cart")));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Clear carts?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                clearCart();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearCart() {
    http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/delete_cart.php"),
        body: {
          "cart_userId": widget.user.id,
        }).then((response) {
      // log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Clear Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Clear Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Clear Failed")));
      }
    });
    setState(() {});
  }

  void checkOutDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Check out ${itemList[index].itemName.toString()}?"),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          user: widget.user,
                          item: itemList[index],
                          cart: cartList[index],
                        ),
                      ),
                    );
                    loadCart();
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
}
