// ... Your Basket class and other classes ...

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Controlers/orders_controllers.dart';
import '../Models/order_model.dart';
import '../Models/routes.dart';
import '../Models/store_model.dart';
import '../Models/user_model.dart';

class BasketPage extends StatelessWidget {
  final Basket basket;
  final StoresMap store;
  final UserMap user;

  const BasketPage(
      {Key? key, required this.basket, required this.store, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MenuItems> basketItems = basket.getItems();

    double totalCost =
        basketItems.fold(0.0, (sum, item) => sum + double.parse(item.cost));

    return Scaffold(
      appBar: AppBar(title: Text('Basket')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: basketItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(basketItems[index].name),
                  subtitle: Text('Cost: ${basketItems[index].cost}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total Cost: $totalCost'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Get the next available order ID
              int nextOrderID = await getNextAvailableOrderID();
              // Create an OrdersMap object with necessary data
              OrdersMap order = OrdersMap(
                // user: FirebaseAuth
                //     .instance.currentUser!.uid, // Your current user's ID,
                user: user.id,
                concluded: false,
                order: basketItems
                    .map((item) => {
                          'cost': item.cost,
                          'name': item.name,
                          'id': item.id,
                        })
                    .toList(),
                order_id: nextOrderID, // Get the next available order ID,
                store: store.id,
              );

              // Create the order document in Firebase
              await createOrder(order);

              // Clear the basket after creating the order
              basketItems = [];

              // Navigate back to the previous screen
              //Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                storesRoute,
                (_) => false,
              );
            },
            child: Text('Create Order'),
          ),
        ],
      ),
    );
  }
}
