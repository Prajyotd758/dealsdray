import 'dart:convert';
import 'dart:math';

import 'package:dealsdray_assignment/item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isFetched = false;
  Map? data;
  List<dynamic>? collection;

  void fetchData() async {
    Response res = await get(Uri.parse(
        "http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice"));
    data = jsonDecode(res.body);
    collection = data!['data']['products'];
    isFetched = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0, left: 10),
            child: Icon(Icons.notification_add),
          )
        ],
        title: SizedBox(
          height: 40,
          child: Center(
            child: TextField(
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[150],
                  contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Search here",
                  prefixIcon: Tab(
                    icon: Image.asset(
                      "assets/512x512bb.jpg",
                      width: 30,
                    ),
                  ),
                  suffixIcon: Icon(Icons.search)),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          isFetched
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                          '${data!['data']['banner_one'][0]['banner']}'),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Tab(
                              icon: Image.network(
                                data!['data']['category'][0]['icon'],
                                width: 50,
                              ),
                            ),
                            Tab(
                              icon: Image.network(
                                data!['data']['category'][1]['icon'],
                                width: 50,
                              ),
                            ),
                            Tab(
                              icon: Image.network(
                                data!['data']['category'][3]['icon'],
                                width: 50,
                              ),
                            ),
                            Tab(
                              icon: Image.network(
                                data!['data']['category'][3]['icon'],
                                width: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 400,
                        child: PageView(
                          children: collection!.asMap().entries.map((e) {
                            print(e);
                            return ProductDetails(
                              source: e.value['icon'],
                              details: e.value["label"],
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
