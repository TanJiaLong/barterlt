// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:barterlt/models/item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:barterlt/myconfig.dart';
import 'package:barterlt/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:barterlt/models/user.dart';

class BuyerOrderDetailScreen extends StatefulWidget {
  final Item item;
  final Order order;
  const BuyerOrderDetailScreen(
      {super.key, required this.item, required this.order});

  @override
  State<BuyerOrderDetailScreen> createState() => _BuyerOrderDetailScreenState();
}

// ignore: duplicate_ignore
class _BuyerOrderDetailScreenState extends State<BuyerOrderDetailScreen> {
  List<Order> orderList = <Order>[];
  late double screenHeight, screenWidth;
  String selectStatus = "Ready";
  // Set<Marker> markers = {};
  List<String> statusList = [
    "New",
    "Processing",
    "Ready",
    "Completed",
  ];
  late User user = User(
    id: "na",
    name: "na",
    email: "na",
    phone: "na",
    datereg: "na",
    password: "na",
  );
  var _barterLatLong;
  String barterLoc = "Not selected";
  final MapController _mapController = MapController();
  late Marker marker;

  @override
  void initState() {
    super.initState();
    loadseller();
    print(widget.order.orderLatitude.toString());
    if (widget.order.orderLatitude == null ||
        widget.order.orderLatitude.toString() == "0.0000000" ||
        widget.order.orderLatitude.toString() == "") {
      barterLoc = "Not selected";
      _barterLatLong = LatLng(6.492331, 100.871706);
    } else {
      barterLoc = "Selected";
      _barterLatLong = LatLng(
          double.parse(widget.order.orderLatitude.toString()),
          double.parse(widget.order.orderLongitude.toString()));
      marker = Marker(
        point: _barterLatLong,
        builder: (context) => const Icon(Icons.location_on, color: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: Column(children: [
        Card(
            child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(4),
              width: screenWidth * 0.3,
              child: Image.asset(
                "assets/images/profile.png",
              ),
            ),
            Column(
              children: [
                user.id == "na"
                    ? const Center(
                        child: Text("Loading..."),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Seller name: ${user.name}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text("Phone: ${user.phone}",
                                style: const TextStyle(
                                  fontSize: 14,
                                )),
                            Text("Email: ${user.email}",
                                style: const TextStyle(
                                  fontSize: 14,
                                )),
                          ],
                        ),
                      )
              ],
            )
          ],
        )),
        Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (barterLoc == "Selected") {
                        loadMapDialog();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Location not available")));
                      }
                    },
                    child: const Text("See Barter Location")),
                Text(barterLoc)
              ],
            )),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              CachedNetworkImage(
                height: screenHeight * 0.2,
                width: screenWidth / 3,
                fit: BoxFit.contain,
                imageUrl:
                    "${MyConfig().server}/mobileprogramming/barterlt/assets/items/${widget.order.orderItemId}-1.png",
                placeholder: (context, url) => const LinearProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order ID: ${widget.order.orderId}",
                        style: const TextStyle(
                          fontSize: 14,
                        )),
                    Text(
                      widget.item.itemName.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Text(
                      "Quantity: ${widget.order.orderQuantity}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Paid: RM ${double.parse(widget.order.orderAmount.toString()).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Status: ${widget.order.orderStatus}",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
        SizedBox(
          // color: Colors.red,
          width: screenWidth,
          height: screenHeight * 0.1,
          child: Card(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("Set order status as completed"),
                  ElevatedButton(
                      onPressed: () {
                        if (barterLoc == "Not selected") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Wait for location first")));
                          return;
                        }

                        submitStatus("Completed");
                      },
                      child: const Text("Submit"))
                ]),
          ),
        )
      ]),
    );
  }

  void loadseller() {
    http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/load_user.php"),
        body: {
          "sellerid": widget.order.orderSellerId,
        }).then((response) {
      // log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          user = User.fromJson(jsondata['data']);
        }
      }
      setState(() {});
    });
  }

  void submitStatus(String st) {
    http.post(
        Uri.parse(
            "${MyConfig().server}/mobileprogramming/barterlt/php/set_order_status.php"),
        body: {"orderid": widget.order.orderId, "status": st}).then((response) {
      // log(response.body);
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
        } else {}
        widget.order.orderStatus = st;
        selectStatus = st;
        setState(() {});
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Success")));
      }
    });
  }

  loadMapDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Check barter location"),
              content: SizedBox(
                height: screenHeight * 0.4,
                width: screenWidth * 0.8,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: _barterLatLong,
                    zoom: 8,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: [marker],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    ).then((val) {
      setState(() {});
    });
  }

  // void _onMapTapped(TapPosition tapPosition, LatLng newLatLng) {
  //   Marker marker = Marker(
  //     point: newLatLng,
  //     builder: (context) => const Icon(Icons.location_on, color: Colors.red),
  //   );

  //   setState(() {
  //     _markers.clear();
  //     _markers.add(marker);
  //     _barterLatLong = newLatLng;
  //   });
  //   log(_barterLatLong.toString());
  // }
}
