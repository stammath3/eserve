import 'dart:convert';
import 'dart:developer';

import 'package:e_serve/Models/user_model.dart';
import 'package:e_serve/View/basket_view.dart';
import 'package:flutter/material.dart';

import '../Models/order_model.dart';
import '../Models/store_model.dart';

class StoreDetailScreen extends StatefulWidget {
  final StoresMap store;
  final UserMap user;
  const StoreDetailScreen(this.store, {Key? key, required this.user})
      : super(key: key);

  @override
  _StoreDetailScreenState createState() => _StoreDetailScreenState(store, user);
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  Basket basket = Basket();
  List<MenuItems> menuItems = [];
  final StoresMap store;
  final UserMap user;
  _StoreDetailScreenState(this.store, this.user);

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
              const Text('Menu'),
              Expanded(
                child: ListView.builder(
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(menuItems[index].name),
                      subtitle: Text('Cost: ${menuItems[index].cost}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                basket.addItem(menuItems[index]);
                              });
                            },
                            icon: Icon(Icons.add),
                            label: Text(''),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                basket.removeItem(menuItems[index]);
                              });
                            },
                            icon: Icon(Icons.remove),
                            label: Text(''),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Text('Total Cost: ${basket.getTotalCost()}'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BasketPage(
                  user: user,
                  basket: basket,
                  store: store,
                ),
              ),
            );
          },
          label: Text('Basket (${basket.getItems().length})'),
          icon: Icon(Icons.shopping_basket),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
