// ... Your Basket class and other classes ...

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Controlers/orders_controllers.dart';
import '../Models/order_model.dart';
import '../Models/store_model.dart';
import '../Models/user_model.dart';
import '../View/payment_page_view.dart';

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
        title: const Text('Order Review'),
        backgroundColor: const Color.fromARGB(255, 215, 35, 35),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
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
                style: const TextStyle(
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
                OrdersMap? newOrder = await getOrderById(nextOrderID);

                if (newOrder == null) {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Order failed'),
                        content: const Text('You need to order again.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('OK'),
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

                  // ignore: await_only_futures
                  List<MenuItems> listt = await basket.getItems();
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        order: newOrder,
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
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Text('Order'),
            ),
          ],
        ),
      ),
    );
  }
}
