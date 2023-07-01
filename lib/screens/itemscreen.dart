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
  int numberOfPage = 1, currentPage = 1;
  int numberOfResults = 0;
  List<String> itemCategory = <String>[
    'Electronics',
    'Books and Media',
    'Sports and Fitness',
    'Toys and Games',
    'Clothing and Fashion'
  ];
  List<String> selectedCategories = [];
  bool httpStatus = false;

  var color;
  List<Item> itemList = [];

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
      appBar: AppBar(title: const Text('Items')),
      body: widget.user.id == 'na'
          ? const Center(
              child: Text(
                "Login First in order to add items",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )
          : httpStatus
              ? RefreshIndicator(
                  onRefresh: _refreshItems,
                  child: Column(
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
                        height: 24,
                        color: Theme.of(context).colorScheme.primary,
                        alignment: Alignment.center,
                        child: Text(
                          '$numberOfResults items found',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
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
                                Item item =
                                    Item.fromJson(itemList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditItemScreen(
                                            user: widget.user, item: item)));
                                loadItem(1);
                                currentPage = 1;
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    itemList[index].itemCategory.toString(),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    "${itemList[index].itemQuantity} in stock",
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
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "HTTP data is not yet available",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
      floatingActionButton: widget.user.id == 'na'
          ? null
          : FloatingActionButton(
              onPressed: () async {
                if (widget.user.id != 'na') {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewItemScreen(user: widget.user)));
                  loadItem(1);
                }
              },
              child: const Text(
                '+',
                style: TextStyle(fontSize: 32),
              ),
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

  Future<void> _refreshItems() async {
    loadItem(1);
  }

  void loadItem(int pageNumber) async {
    String selectedCategoriesText = selectedCategories.join("','");
    http.post(
        Uri.parse(
            '${MyConfig().server}/mobileprogramming/barterlt/php/load_item.php'),
        body: {
          'userid': widget.user.id,
          "selectedCategory": selectedCategoriesText,
          'pageNo': pageNumber.toString()
        }).then((response) {
      log(response.body);

      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success' && jsondata['data'] != '') {
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
          loadItem(1);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Failed")));
        }
      }
    });
  }
}
