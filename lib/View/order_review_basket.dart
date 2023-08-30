// ... Your Basket class and other classes ...

import 'dart:developer';

import 'package:e_serve/View/payment_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Controlers/orders_controllers.dart';
import '../Models/order_model.dart';
import '../Models/routes.dart';
import '../Models/store_model.dart';
import '../Models/user_model.dart';

class BasketPage extends StatelessWidget {
  final Basket basket;
  final StoresMap store;
  final UserMap user;
  final TableData table;

  const BasketPage(
      {Key? key,
      required this.basket,
      required this.store,
      required this.user,
      required this.table})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MenuItems> basketItems = basket.getItems();

    double totalCost =
        basketItems.fold(0.0, (sum, item) => sum + double.parse(item.cost));

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Review'),
        backgroundColor: Color.fromARGB(255, 215, 35, 35),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                child: ListView.builder(
                  itemCount: basketItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(basketItems[index].name),
                      subtitle: Text('Cost: ${basketItems[index].cost}  	€'),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total Cost: $totalCost 	€',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
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
                  table_id: table.tableId,
                  cost: totalCost,
                );

                // Create the order document in Firebase
                await createOrder(order);
                //late final OrdersMap? NewOrder;
                OrdersMap? NewOrder = await getOrderById(nextOrderID);

                if (NewOrder == null) {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Order failed'),
                        content: Text('You need to order again.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Update the order_id field of the reserved table
                  if (table.tableId > 0 && user.id.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection('stores')
                        .doc(store.id)
                        .update({
                      'tables': FieldValue.arrayRemove([
                        {
                          'table_id': table.tableId,
                          'order_id': -1,
                          'is_reserved': table.isReserved,
                          'name': table.name,
                          'user_id': user.id,
                        }
                      ])
                    });

                    await FirebaseFirestore.instance
                        .collection('stores')
                        .doc(store.id)
                        .update({
                      'tables': FieldValue.arrayUnion([
                        {
                          'table_id': table.tableId,
                          'order_id': nextOrderID, // Set the actual order ID
                          'is_reserved': true,
                          'name': table.name,
                          'user_id': user.id,
                        }
                      ])
                    });
                  }

                  List<MenuItems> listt = await basket.getItems();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        order: NewOrder,
                        cost: totalCost,
                        store: store,
                        tableName: table.name,
                        totalCost: totalCost,
                        basketItems: listt,
                      ),
                    ),
                  );
                }

                // Clear the basket after creating the order
                basketItems = [];

                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   storesRoute,
                //   (_) => false,
                // );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Text('Order'),
            ),
          ],
        ),
      ),
    );
  }
}
