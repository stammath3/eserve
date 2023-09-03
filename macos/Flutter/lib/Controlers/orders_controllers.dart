import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/order_model.dart';

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
