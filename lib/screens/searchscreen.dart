import 'dart:convert';
import 'dart:developer';

import 'package:barterlt/models/item.dart';
import 'package:barterlt/models/user.dart';
import 'package:barterlt/myconfig.dart';
import 'package:barterlt/screens/itemdetailscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  final User user;
  const SearchScreen({super.key, required this.user});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchEditingController =
      TextEditingController();
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
      appBar: AppBar(
        title: const Text("Search Screen"),
        actions: [
          IconButton(
              onPressed: () {
                showSearchDialog();
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 20,
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
                  onTap: () async {
                    Item item = Item.fromJson(itemList[index].toJson());
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemDetailScreen(
                                user: widget.user, item: item)));
                    loadItem();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 5,
                        child: CachedNetworkImage(
                          height: 120,
                          imageUrl:
                              '${MyConfig().server}/mobileprogramming/barterlt/assets/items/${itemList[index].itemId}-1.png',
                          fit: BoxFit.contain,
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
    );
  }

  void loadItem() {
    http.post(
        Uri.parse(
            '${MyConfig().server}/mobileprogramming/barterlt/php/load_item.php'),
        body: {}).then((response) {
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

  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Search?",
            style: TextStyle(),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: _searchEditingController,
                decoration: const InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ))),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton(
                onPressed: () {
                  String search = _searchEditingController.text;
                  searchCatch(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search"))
          ]),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
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

  void searchCatch(String search) {
    http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/load_item.php"),
        body: {"search": search}).then((response) {
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }
}
