import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../Models/models.dart';

class StoreDetailScreen extends StatelessWidget {
  final StoresMap store; // Replace 'StoresMap' with your actual class name

  const StoreDetailScreen(this.store, {super.key});

  @override
  Widget build(BuildContext context) {
    // final json = jsonDecode(store.toMap().toString());
    // Map<String, dynamic> data = jsonDecode(json);
    // log(data.toString());

    List<MenuItem> menuItems = (store.menu as List)
        .expand((category) => (category['menuItems'] as List).map((item) {
              return MenuItem(
                cost: item['cost'],
                name: item['name'],
                id: item['id'],
              );
            }))
        .toList();

    log(menuItems.toString());

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(store.name ?? 'Store Detail')),
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(title: Text(store.name ?? 'Store Detail')),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Text('Store Name: ${store.name ?? 'No Name'}'),
    //         Text('Store Owner: ${store.owner ?? 'No Owner'}'),
    //         Text('Store ID: ${store.id ?? 'No ID'}'),
    //         Text('Menu: ${store.menu[1]['menuItems'] ?? 'No Menu'}'),
    //         // Display other store details here
    //       ],
    //     ),
    //   ),
    // );
  }
}

class MenuItem {
  final String cost;
  final String name;
  final int id;

  MenuItem({required this.cost, required this.name, required this.id});
}
