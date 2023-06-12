import 'dart:convert';
import 'dart:developer';

import 'package:barterlt/models/item.dart';
import 'package:barterlt/models/user.dart';
import 'package:barterlt/myconfig.dart';
import 'package:barterlt/screens/edititemscreen.dart';
import 'package:barterlt/screens/newitemscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItemScreen extends StatefulWidget {
  final User user;
  const ItemScreen({super.key, required this.user});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  late double screenHeight, screenWidth;
  late int axiscount;
  List<Item> itemList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadItem();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: Column(
        children: [
          Container(
            height: 24,
            color: Theme.of(context).colorScheme.primary,
            alignment: Alignment.center,
            child: Text(
              '${itemList.length} items found',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Expanded(
              child: GridView.count(
            crossAxisCount: axiscount,
            children: List.generate(itemList.length, (index) {
              return Card(
                elevation: 10,
                child: InkWell(
                  onLongPress: () {
                    deleteDialog(index);
                  },
                  onTap: () async {
                    Item item = Item.fromJson(itemList[index].toJson());
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditItemScreen(user: widget.user, item: item)));
                    loadItem();
                  },
                  child: Column(
                    children: [
                      Flexible(
                        flex: 5,
                        child: CachedNetworkImage(
                          height: 120,
                          imageUrl:
                              '${MyConfig().server}/mobileprogramming/barterlt/assets/items/${itemList[index].itemId}-1.png',
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Text(
                        itemList[index].itemName.toString(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${itemList[index].itemCategory}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        "RM ${double.parse(itemList[index].itemValue.toString()).toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.user.id != 'na') {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewItemScreen(user: widget.user)));
            loadItem();
          }
        },
        child: const Text(
          '+',
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }

  void loadItem() {
    http.post(
        Uri.parse(
            '${MyConfig().server}/mobileprogramming/barterlt/php/load_item.php'),
        body: {'userid': widget.user.id}).then((response) {
      // log(response.body);

      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }

  void deleteDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('Delete ${itemList[index].itemName}?'),
            content: const Text('Are you sure'),
            actions: [
              TextButton(
                  onPressed: () {
                    deleteItem(index);
                    Navigator.pop(context);
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
            ],
          );
        });
  }

  void deleteItem(int index) {
    http.post(
        Uri.parse(
            '${MyConfig().server}/mobileprogramming/barterlt/php/delete_item.php'),
        body: {
          'userId': widget.user.id,
          'itemId': itemList[index].itemId,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loadItem();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Failed")));
        }
      }
    });
  }
}
