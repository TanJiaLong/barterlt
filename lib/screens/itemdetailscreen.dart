import 'package:barterlt/models/item.dart';
import 'package:barterlt/models/user.dart';
import 'package:barterlt/myconfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemDetailScreen extends StatefulWidget {
  final User user;
  final Item item;
  const ItemDetailScreen({super.key, required this.user, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final dateFormat = DateFormat('dd-MM-yyyy hh:mm a');

  late double screenHeight, screenWidth, cardwitdh;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: Column(children: [
        Flexible(
          flex: 4,
          child: Container(
            height: 340,
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Card(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildScrollableImage(1),
                  const SizedBox(
                    width: 12,
                  ),
                  buildScrollableImage(2),
                  const SizedBox(
                    width: 12,
                  ),
                  buildScrollableImage(3),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        )
      ]),
    );
  }

  Widget buildScrollableImage(int num) {
    return CachedNetworkImage(
      height: 340,
      fit: BoxFit.contain,
      imageUrl:
          "${MyConfig().server}/mobileprogramming/barterlt/assets/items/${widget.item.itemId}-$num.png",
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
