import 'dart:convert';

import 'package:barterlt/models/user.dart';
import 'package:barterlt/models/item.dart';
import 'package:barterlt/myconfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditItemScreen extends StatefulWidget {
  final User user;
  final Item item;
  const EditItemScreen({super.key, required this.user, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final TextEditingController _itemNameEditingController =
      TextEditingController();
  final TextEditingController _itemDescEditingController =
      TextEditingController();
  final TextEditingController _itemValueEditingController =
      TextEditingController();
  final TextEditingController _stateEditingController = TextEditingController();
  final TextEditingController _localityEditingController =
      TextEditingController();
  final TextEditingController _latitudeEditingController =
      TextEditingController();
  final TextEditingController _longitudeEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var assetPath = 'assets/images/camera.png';

  late double screenHeight, screenWidth;
  String selectedCategory = 'Electronics';
  List<String> itemCategory = <String>[
    'Electronics',
    'Books and Media',
    'Sports and Fitness',
    'Toys and Games',
    'Clothing and Fashion'
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _itemNameEditingController.text = widget.item.itemName.toString();
    _itemDescEditingController.text = widget.item.itemDesc.toString();
    _itemValueEditingController.text =
        double.parse(widget.item.itemValue.toString()).toStringAsFixed(2);
    _stateEditingController.text = widget.item.state.toString();
    _localityEditingController.text = widget.item.locality.toString();
    _latitudeEditingController.text = widget.item.latitude.toString();
    _longitudeEditingController.text = widget.item.longitude.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Item'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                child: SizedBox(
                  width: screenWidth,
                  child: CachedNetworkImage(
                    width: screenWidth,
                    imageUrl:
                        '${MyConfig().server}/mobileprogramming/barterlt/assets/items/${widget.item.itemId}-1.png',
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.type_specimen),
                          DropdownButton(
                            value: selectedCategory,
                            items: itemCategory.map((selectedCategory) {
                              return DropdownMenuItem(
                                value: selectedCategory,
                                child: Text(selectedCategory),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedCategory = newValue!;
                              });
                            },
                          ),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _itemNameEditingController,
                              validator: (value) => value!.isEmpty ||
                                      value.length < 5
                                  ? 'Item name must be at least 5 characters'
                                  : null,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                hintText: 'Item Name',
                                icon: Icon(Icons.abc),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        maxLines: 4,
                        maxLength: 50,
                        textInputAction: TextInputAction.newline,
                        controller: _itemDescEditingController,
                        validator: (value) => value!.isEmpty || value.length < 5
                            ? 'Description of the item must be at least 5 characters'
                            : null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'Description of item',
                          icon: Icon(Icons.description),
                          alignLabelWithHint: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _itemValueEditingController,
                        validator: (value) =>
                            value!.isEmpty || double.parse(value) <= 0
                                ? 'Please enter a correct amount'
                                : null,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Item Value',
                          icon: Icon(Icons.money),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                              enabled: false,
                              textInputAction: TextInputAction.next,
                              controller: _stateEditingController,
                              validator: (value) =>
                                  value!.isEmpty ? 'Current State' : null,
                              decoration: const InputDecoration(
                                hintText: 'Current State',
                                icon: Icon(Icons.flag),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                              enabled: false,
                              textInputAction: TextInputAction.next,
                              controller: _localityEditingController,
                              validator: (value) =>
                                  value!.isEmpty ? 'Current Locality' : null,
                              decoration: const InputDecoration(
                                hintText: 'Current Locality',
                                icon: Icon(Icons.flag),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                              enabled: false,
                              textInputAction: TextInputAction.next,
                              controller: _latitudeEditingController,
                              validator: (value) =>
                                  value!.isEmpty ? 'Current Latitude' : null,
                              decoration: const InputDecoration(
                                hintText: 'Current Latitude',
                                icon: Icon(Icons.numbers),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                              enabled: false,
                              textInputAction: TextInputAction.next,
                              controller: _longitudeEditingController,
                              validator: (value) =>
                                  value!.isEmpty ? 'Current Longitude' : null,
                              decoration: const InputDecoration(
                                hintText: 'Current Longitude',
                                icon: Icon(Icons.numbers),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: screenWidth / 1.4,
                        child: ElevatedButton(
                          onPressed: () {
                            editDialog();
                          },
                          child: const Text('Edit Item'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void editDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Check your input')));
      return;
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Edit Item?'),
            content: const Text('Are you sure'),
            actions: [
              TextButton(
                  onPressed: () {
                    editItem();
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

  void editItem() {
    String name = _itemNameEditingController.text;
    String desc = _itemDescEditingController.text;
    String category = selectedCategory.toString();
    String value = _itemValueEditingController.text;
    String state = _stateEditingController.text;
    String locality = _localityEditingController.text;
    String latitude = _latitudeEditingController.text;
    String longitude = _longitudeEditingController.text;

    http.post(
        Uri.parse(
            '${MyConfig().server}/mobileprogramming/barterlt/php/edit_item.php'),
        body: {
          'itemId': widget.item.itemId,
          'itemName': name,
          'itemDesc': desc,
          'itemCategory': category,
          'itemValue': value,
          'state': state,
          'locality': locality,
          'latitude': latitude,
          'longitude': longitude,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item Edited Successfully')));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item Edited Failed ::Json')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item Edited Failed ::HTTP')));
      }
    });
  }
}
