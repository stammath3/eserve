import 'dart:convert';
import 'dart:developer';

import 'package:e_serve/Models/user_model.dart';
import 'package:e_serve/View/order_review_basket.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/order_model.dart';
import '../Models/store_model.dart';

class StoreDetailScreen extends StatefulWidget {
  final StoresMap store;
  final UserMap user;
  final TableData reservedTable;
  const StoreDetailScreen(
      {Key? key,
      required this.store,
      required this.user,
      required this.reservedTable})
      : super(key: key);

  @override
  _StoreDetailScreenState createState() =>
      _StoreDetailScreenState(store, user, reservedTable);
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  Basket basket = Basket();
  List<MenuItems> menuItems = [];
  //List<TableData> tables = []; // New list to store tables
  final StoresMap store;
  final UserMap user;
  final TableData reservedTable;
  _StoreDetailScreenState(this.store, this.user, this.reservedTable);

  @override
  void initState() {
    super.initState();
    menuItems = (widget.store.menu as List)
        .expand((category) => (category['menuItems'] as List).map((item) {
              return MenuItems(
                cost: item['cost'],
                name: item['name'],
                id: item['id'],
              );
            }))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 215, 35, 35),
          title: Text(widget.store.name ?? 'Store Detail'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Container(
                child: const Text(
                  'Menu',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(
                color: Colors.black, // Color of the line
                thickness: 1.0, // Thickness of the line
                indent: 16.0, // Indent from the left
                endIndent: 16.0, // Indent from the right
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.store.menu.length,
                  itemBuilder: (context, categoryIndex) {
                    final category = widget.store.menu[categoryIndex];
                    final categoryName = category['categoryName'];
                    final menuItems = category['menuItems'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            categoryName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: menuItems.length,
                          itemBuilder: (context, index) {
                            final menuItem = menuItems[index];

                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(menuItem['name']),
                                subtitle: Text('Cost: ${menuItem['cost']} 	€'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          final menuItems = widget.store
                                              .menu[categoryIndex]['menuItems'];
                                          final menuItem = menuItems[index];
                                          final menuItemsObject = MenuItems(
                                            cost: menuItem['cost'],
                                            name: menuItem['name'],
                                            id: menuItem['id'],
                                          );
                                          basket.addItem(menuItemsObject);
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                      label: Text(''),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          final menuItems = widget.store
                                              .menu[categoryIndex]['menuItems'];
                                          final menuItem = menuItems[index];
                                          final menuItemsObject = MenuItems(
                                            cost: menuItem['cost'],
                                            name: menuItem['name'],
                                            id: menuItem['id'],
                                          );
                                          basket.removeItem(menuItemsObject);
                                        });
                                      },
                                      icon: Icon(Icons.remove),
                                      label: Text(''),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              //Text('Total Cost: ${basket.getTotalCost()}'),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   'Total Cost: ${basket.getTotalCost()}',
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 18,
            //   ),
            // ),
            SizedBox(width: MediaQuery.of(context).size.width / 10),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BasketPage(
                      table: reservedTable,
                      user: user,
                      basket: basket,
                      store: store,
                    ),
                  ),
                );
              },
              label: Text(
                  'Order review (${basket.getItems().length}) ${basket.getTotalCost()} €'),
              icon: Icon(Icons.shopping_basket),
              backgroundColor: Color.fromARGB(255, 215, 35, 35),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
