import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/models.dart';

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
    //log('ordersssssssssssssssss');
    //log(orders.toString());
    return orders;
  } catch (e) {
    //log('Error fetching  orders: $e');
    return [];
  }
}
