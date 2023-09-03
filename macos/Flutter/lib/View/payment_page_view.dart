// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_serve/Controlers/orders_controllers.dart';

import 'package:flutter/material.dart';

import '../Models/order_model.dart';
import '../Models/routes.dart';
import '../Models/store_model.dart';

class PaymentPage extends StatefulWidget {
  final OrdersMap? order;
  final double cost;
  final StoresMap store;
  final String tableName;
  final double totalCost;
  final List<MenuItems> basketItems;
  const PaymentPage({
    Key? key,
    required this.order,
    required this.cost,
    required this.store,
    required this.tableName,
    required this.totalCost,
    required this.basketItems,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() =>
      _PaymentPageState(order, cost, store, tableName, totalCost, basketItems);
}

class _PaymentPageState extends State<PaymentPage> {
  late final double cost;
  late final OrdersMap? order;
  final StoresMap store;
  final String tableName;
  final double totalCost;
  final List<MenuItems> basketItems;

  _PaymentPageState(this.order, this.cost, this.store, this.tableName,
      this.totalCost, this.basketItems);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
        backgroundColor: const Color.fromARGB(255, 215, 35, 35),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Order Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: basketItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(basketItems[index].name),
                  subtitle: Text('Cost: ${basketItems[index].cost}'),
                );
              },
            )),
            const SizedBox(height: 0),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 46),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16), // Set the border radius
              ),
              child: Padding(
                padding: const EdgeInsets.all(16), // Adjust
                child: Text(
                  'Cost : $totalCost 	€ \nStore : ${store.name} \nConcluded: ${order!.concluded.toString()} ',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // Update the reserved table information in Firestore
                await FirebaseFirestore.instance
                    .collection('stores')
                    .doc(order!.store)
                    .update({
                  'tables': FieldValue.arrayRemove([
                    {
                      'table_id': order!.table_id,
                      'order_id': order!.order_id, // Set the actual order ID
                      'is_reserved': true,
                      'name': tableName,
                      'user_id': order!.user,
                    }
                  ])
                });

                await FirebaseFirestore.instance
                    .collection('stores')
                    .doc(store.id)
                    .update({
                  'tables': FieldValue.arrayUnion([
                    {
                      'table_id': order!.table_id,
                      'order_id': -1,
                      'is_reserved': false,
                      'name': tableName,
                      'user_id': "",
                    }
                  ])
                });

                // Update the order's concluded status to true
                await updateOrderConcludedStatus(order!.order_id, true);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  homePageRoute,
                  (_) => false,
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Text('Pay Order'),
            ),
          ],
        ),
      ),
    );
  }
}
