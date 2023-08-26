import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/order_model.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

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

//class FirestoreUtils {
Future<void> createOrder(OrdersMap order) async {
  final ordersCollection = FirebaseFirestore.instance.collection('orders');
  await ordersCollection.add(order.toMap());
  log('orderrrrrrrrrrrrrrrrrr');
  log(order.toString());
}
//}

//class FirestoreUtils {
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
//}