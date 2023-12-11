import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_serve/Models/order_model.dart';
import 'package:e_serve/View/store_order_screen.dart';
import 'package:flutter/material.dart';
import '../Models/store_model.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

//Stores
Future<StoresMap> createStore(StoresMap store) async {
  var storeRef = addStore(store);

  log(storeRef.toString());
  return store;
}

Future<DocumentReference<Object?>> addStore(StoresMap storeData) async {
  var documentReference = await _db.collection("stores").add(storeData.toMap());
  return documentReference;
}

Future<void> deleteStore(String documentId) async {
  await _db.collection("stores").doc(documentId).delete();
}

Future<List<StoresMap>> retrieveStores() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection("stores").get();
  return snapshot.docs
      .map((docSnapshot) => StoresMap.fromDocumentSnapshot(docSnapshot))
      .toList();
}

Future<QuerySnapshot<Map<String, dynamic>>> retrieveStoresAsMap() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection("stores").get();
  return snapshot;
}

Future<List<StoresMap>> getAllStores() async {
  final CollectionReference storesCollection =
      FirebaseFirestore.instance.collection('stores');
  try {
    QuerySnapshot<Object?> querySnapshot = await storesCollection.get();

    List<StoresMap> stores = querySnapshot.docs
        .map((doc) => StoresMap.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    return stores;
  } catch (e) {
    log('Error fetching stores: $e');
    return [];
  }
}

Future<String> getStoreOwnerName(
    DocumentReference<Map<String, dynamic>> ownerRef) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await ownerRef.get();
    Map<String, dynamic>? ownerData = snapshot.data();
    return ownerData?['name'] ?? 'Unknown Owner';
  } catch (e) {
    log('Error fetching owner name: $e');
    return 'Unknown Owner';
  }
}

Future<StoresMap?> getStoreDetails(String storeId) async {
  DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('stores').doc(storeId).get();

  if (snapshot.exists) {
    return StoresMap.fromDocumentSnapshot(snapshot);
  } else {
    return null;
  }
}

Future<List<TableData>> getStoreTableDetails(String storeId) async {
  DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('stores').doc(storeId).get();

  if (snapshot.exists) {
    final StoresMap storeMap = StoresMap.fromDocumentSnapshot(snapshot);

    // Extract and return the tables data
    final List<TableData> tables = storeMap.tables.map((tableData) {
      return TableData(
        tableId: tableData['table_id'],
        orderId: tableData['order_id'],
        isReserved: tableData['is_reserved'] as bool,
        name: tableData['name'] as String,
        userId: tableData['user_id'] as String,
      );
    }).toList();

    return tables;
  } else {
    // Handle the case when the store does not exist or other error handling
    return []; // Return an empty list or handle it differently as needed
  }
}

Future<List<dynamic>> getStoreMenuDetails(String storeId) async {
  DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('stores').doc(storeId).get();

  if (snapshot.exists) {
    final StoresMap storeMap = StoresMap.fromDocumentSnapshot(snapshot);

    // Return the entire menu data
    return storeMap.menu;
  } else {
    // Handle the case when the store does not exist or other error handling
    return []; // Return an empty list or handle it differently as needed
  }
}

void navigateToStoreDetail(tables, user, store, context) {
  final reservedTable = tables.firstWhere((table) => table.userId == user.id,
      orElse: () => TableData(
          tableId: -1,
          orderId: -1,
          isReserved: false,
          name: '',
          userId: '')); // Default if no reservation

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => StoreDetailScreen(
        store: store,
        user: user,
        reservedTable: reservedTable,
      ),
    ),
  );
}

Future<void> reserveTable(widget, table, isReserved, store, user) async {
  await FirebaseFirestore.instance.collection('stores').doc(store.id).update({
    'tables': FieldValue.arrayRemove([
      {
        'table_id': table.tableId,
        'order_id': -1,
        'is_reserved': isReserved,
        'name': table.name,
        'user_id': table.userId,
      }
    ])
  });

  await FirebaseFirestore.instance.collection('stores').doc(store.id).update({
    'tables': FieldValue.arrayUnion([
      {
        'table_id': table.tableId,
        'order_id': -1,
        'is_reserved': true,
        'name': table.name,
        'user_id': user.id,
      }
    ])
  });
}
