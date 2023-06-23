import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:barterlt/models/user.dart';
import 'package:barterlt/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class NewItemScreen extends StatefulWidget {
  final User user;
  const NewItemScreen({super.key, required this.user});

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
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

  late double screenWidth;
  final _formKey = GlobalKey<FormState>();

  List<File?> _images = List.generate(3, (_) => null);

  var assetPath = 'assets/images/camera.png';
  String selectedCategory = 'Electronics';
  List<String> itemCategory = <String>[
    'Electronics',
    'Books and Media',
    'Sports and Fitness',
    'Toys and Games',
    'Clothing and Fashion'
  ];

  late Position _currentPosition;
  String curaddress = "Changlun";
  String curstate = "Kedah";
  String prlat = "6.460329";
  String prlong = "100.5010041";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insert Items'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          IconButton(
            onPressed: () {
              _determinePosition();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(_images.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      _selectFromGallery(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(8),
                          width: screenWidth * 0.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _images[index] == null
                                  ? AssetImage(assetPath)
                                  : FileImage(_images[index]!) as ImageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // ListView(
            //   scrollDirection: Axis.horizontal,
            //   children: [
            //     selectImagesWidget(1),
            //     const SizedBox(
            //       width: 4,
            //     ),
            //     selectImagesWidget(1),
            //     const SizedBox(
            //       width: 4,
            //     ),
            //     selectImagesWidget(1),
            //   ],
            // ),

            // GestureDetector(
            //   onTap: () {
            //     _selectFromGallery();
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(8),
            //     child: Card(
            //       child: Container(
            //         width: screenWidth,
            //         decoration: BoxDecoration(
            //           image: DecorationImage(
            //             image: _images.isEmpty
            //                 ? AssetImage(assetPath)
            //                 : FileImage(_images[0]) as ImageProvider,
            //             fit: BoxFit.contain,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
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
                            insertDialog();
                          },
                          child: const Text('Insert Item'),
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

  void _selectFromGallery(int index) async {
    final ImagePicker picker = ImagePicker();
    final selectedImage = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 1200, maxWidth: 800);

    if (selectedImage != null) {
      _images[index] = File(selectedImage.path);
    }
    setState(() {});

    // mid-term before modification
    // final selectedImages = await picker.pickMultiImage(
    //     imageQuality: 100, maxHeight: 1200, maxWidth: 800);
    // if (selectedImages.isNotEmpty) {
    //   _imagesX.clear();
    //   _images.clear();
    //   for (int i = 0; i < 3; ++i) {
    //     //Add image in XFile type
    //     _imagesX.add(selectedImages[i]);
    //     //Convert XFile to File type
    //     File file = File(selectedImages[i].path);
    //     _images.add(file);
    //   }
    // }
  }

  void insertDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Check your input')));
      return;
    }

    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please insert 3 required pictures')));
      return;
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Insert Item?'),
            content: const Text('Are you sure'),
            actions: [
              TextButton(
                  onPressed: () {
                    insertNewItem();
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

  void insertNewItem() {
    String name = _itemNameEditingController.text;
    String desc = _itemDescEditingController.text;
    String category = selectedCategory.toString();
    String value = _itemValueEditingController.text;
    String state = _stateEditingController.text;
    String locality = _localityEditingController.text;
    String latitude = _latitudeEditingController.text;
    String longitude = _longitudeEditingController.text;
    String base64image1 = base64Encode(_images[0]!.readAsBytesSync());
    String base64image2 = base64Encode(_images[1]!.readAsBytesSync());
    String base64image3 = base64Encode(_images[2]!.readAsBytesSync());

    http.post(
        Uri.parse(
            '${MyConfig().server}/mobileprogramming/barterlt/php/insert_item.php'),
        body: {
          'userId': widget.user.id,
          'itemName': name,
          'itemDesc': desc,
          'itemCategory': category,
          'itemValue': value,
          'state': state,
          'locality': locality,
          'latitude': latitude,
          'longitude': longitude,
          'image1': base64image1,
          'image2': base64image2,
          'image3': base64image3
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item Inserted Successfully')));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item Inserted Failed ::Json')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item Inserted Failed ::HTTP')));
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
    // return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    setState(() {
      _localityEditingController.text = placemarks[0].locality.toString();
      _stateEditingController.text =
          placemarks[0].administrativeArea.toString();
      _latitudeEditingController.text = _currentPosition.latitude.toString();
      _longitudeEditingController.text = _currentPosition.longitude.toString();
    });
  }
}
