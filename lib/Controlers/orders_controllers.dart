import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/order_model.dart';
import '../Models/routes.dart';
import '../View/payment_page_view.dart';

Future<List<OrdersMap>> getAllOrders() async {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  try {
    QuerySnapshot<Object?> querySnapshot = await ordersCollection.get();

    List<OrdersMap> orders = querySnapshot.docs
        .map((doc) => OrdersMap.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
    log(orders.toString());
    return orders;
  } catch (e) {
    log('Error fetching  orders: $e');
    return [];
  }
}

Future<void> createOrder(OrdersMap order) async {
  final ordersCollection = FirebaseFirestore.instance.collection('orders');
  await ordersCollection.add(order.toMap());

  log('orderrrrrrrrrrrrrrrrrr');
  log(order.toString());
}

Future<int> getNextAvailableOrderID() async {
  final ordersCollection = FirebaseFirestore.instance.collection('orders');

  QuerySnapshot<Map<String, dynamic>> querySnapshot = await ordersCollection
      .orderBy('order_id', descending: true)
      .limit(1)
      .get();

  if (querySnapshot.docs.isEmpty) {
    return 1; // Start from 1 if there are no existing orders
  }

  int highestOrderID = querySnapshot.docs.first['order_id'];
  int nextOrderID = highestOrderID + 1;

  return nextOrderID;
}

Future<OrdersMap?> getOrderById(int orderId) async {
  try {
    QuerySnapshot<Map<String, dynamic>> orderSnapshot = await FirebaseFirestore
        .instance
        .collection('orders')
        .where('order_id', isEqualTo: orderId)
        .limit(1)
        .get();

    if (orderSnapshot.docs.isNotEmpty) {
      log(orderSnapshot.toString());
      return OrdersMap.fromDocumentSnapshot(orderSnapshot.docs.first);
    } else {
      return null; // Order with the given ID doesn't exist
    }
  } catch (e) {
    return null;
  }
}

Future<void> updateOrderConcludedStatus(int orderID, bool concluded) async {
  try {
    final orderQuerySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('order_id', isEqualTo: orderID)
        .limit(1) // Limit to one result
        .get();

    if (orderQuerySnapshot.docs.isNotEmpty) {
      final orderId = orderQuerySnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
        'concluded': concluded,
      });
    } else {}
  } catch (e) {
    log('Error updating database: $e');
  }
}

Future<String?> getTableNameByTableId(String storeId, int tableId) async {
  try {
    final storeDoc = await FirebaseFirestore.instance
        .collection('stores')
        .doc(storeId)
        .get();
    final tables = storeDoc['tables'] as List<dynamic>;

    final tableInfo = tables.firstWhere((table) => table['table_id'] == tableId,
        orElse: () => null);

    if (tableInfo != null) {
      return tableInfo['name'] as String;
    } else {
      return null; // Table with the specified ID not found
    }
  } catch (error) {
    return null;
  }
}

Future<dynamic> createNewOrder(
    user, store, table, totalCost, context, basketItems, basket) async {
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
  //clear basket
  basketItems = [];
}

void pay(order, tableName, store, context) async {
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

  await FirebaseFirestore.instance.collection('stores').doc(store.id).update({
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
}
