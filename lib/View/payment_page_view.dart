import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_serve/Controlers/orders_controllers.dart';
import 'package:e_serve/Models/order_model.dart';
import 'package:e_serve/Models/routes.dart';
import 'package:e_serve/Models/store_model.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final OrdersMap? order;
  final double cost;
  final StoresMap store;
  final String tableName;
  PaymentPage({
    Key? key,
    required this.order,
    required this.cost,
    required this.store,
    required this.tableName,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() =>
      _PaymentPageState(order, cost, store, tableName);
}

class _PaymentPageState extends State<PaymentPage> {
  late final double cost;
  late final OrdersMap? order;
  final StoresMap store;
  final String tableName;

  _PaymentPageState(this.order, this.cost, this.store, this.tableName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Order Details'),
            SizedBox(height: 16),
            Text('Order ID: ${order!.order_id}'),
            Text('Store: ${order!.store}'),
            Text('Concluded: ${order!.concluded.toString()}'),
            // Add more order details as needed
            SizedBox(height: 24),
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
              child: Text('Pay Order'),
            ),
          ],
        ),
      ),
    );
  }
}
