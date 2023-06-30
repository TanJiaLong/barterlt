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

  List<String> itemCategory = <String>[
    'Electronics',
    'Books and Media',
    'Sports and Fitness',
    'Toys and Games',
    'Clothing and Fashion'
  ];
  List<String> selectedCategories = [];

  int numberOfPage = 1, currentPage = 1;
  int numberOfResults = 0;
  var color;
  bool httpStatus = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadItem(1);
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
        title: const Text("Barter Screen"),
        actions: [
          IconButton(
              onPressed: () {
                showSearchDialog();
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: httpStatus
          ? Column(
              children: [
                InkWell(
                  onTap: showCategoryFilter,
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    color: Colors.grey,
                    child: Row(
                      children: const [
                        Icon(Icons.category),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Select Categories',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  color: Theme.of(context).colorScheme.primary,
                  alignment: Alignment.center,
                  child: Text(
                    '$numberOfResults items found',
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
                          loadItem(1);
                          currentPage = 1;
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
                              "${itemList[index].itemQuantity} available",
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
                )),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numberOfPage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      //build the list for textbutton with scroll
                      if ((currentPage - 1) == index) {
                        //set current page number active
                        color = Colors.red;
                      } else {
                        color = Colors.black;
                      }
                      return TextButton(
                          onPressed: () {
                            currentPage = index + 1;
                            loadItem(index + 1);
                          },
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color, fontSize: 18),
                          ));
                    },
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "HTTP data is not yet available",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
    );
  }

  void showCategoryFilter() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 400,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: itemCategory.length,
                      itemBuilder: (BuildContext context, int index) {
                        final category = itemCategory[index];
                        final isSelected =
                            selectedCategories.contains(category);
                        return CheckboxListTile(
                          title: Text(category),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null && value) {
                                selectedCategories.add(category);
                              } else {
                                selectedCategories.remove(category);
                              }
                              loadItem(1);
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void loadItem(int pageNumber) {
    String selectedCategoriesText = selectedCategories.join("','");
    http.post(
        Uri.parse(
            '${MyConfig().server}/mobileprogramming/barterlt/php/load_item.php'),
        body: {
          "selectedCategory": selectedCategoriesText,
          'pageNo': pageNumber.toString()
        }).then((response) {
      log(response.body);

      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          numberOfPage = int.parse(jsondata['numberOfPage']);
          numberOfResults = int.parse(jsondata['numberOfResult']);
          httpStatus = true;
        } else {
          httpStatus = false;
        }
        setState(() {});
      } else {
        httpStatus = false;
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
    String selectedCategoriesText = selectedCategories.join("','");

    http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/load_item.php"),
        body: {
          "search": search,
          "selectedCategory": selectedCategoriesText
        }).then((response) {
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          numberOfPage = int.parse(jsondata['numberOfPage']);
          numberOfResults = int.parse(jsondata['numberOfResult']);
        }
        setState(() {});
      }
    });
  }
}
