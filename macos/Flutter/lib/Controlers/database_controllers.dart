import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/models.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

//Users

Future<UserMap> createUser(User dbuser) async {
  final usermap = UserMap(
      //displayName: dbuser.displayName,
      email: dbuser.email,
      emailVerified: dbuser.emailVerified,
      isAnonymous: dbuser.isAnonymous,
      creationTime: dbuser.metadata.creationTime.toString(),
      uid: dbuser.uid);

  var userRef = addUser(usermap);

  log(userRef.toString());
  return usermap;
}

Future<DocumentReference<Object?>> addUser(UserMap userData) async {
  var documentReference = await _db.collection("users").add(userData.toMap());
  return documentReference;
}

//   updateEmployee(User userData) async {
//   await _db.collection("users").doc("edw_thelei to doc id tou user").update(userData.toMap());
// }

Future<void> deleteUser(String documentId) async {
  await _db.collection("users").doc(documentId).delete();
}

Future<List<UserMap>> retrieveUsers() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection("users").get();
  return snapshot.docs
      .map((docSnapshot) => UserMap.fromDocumentSnapshot(docSnapshot))
      .toList();
}

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

//   updateStore(StoresMap storesData) async {
//   await _db.collection("stores").doc("edw_thelei to doc id twn stores").update(storesData.toMap());
// }

Future<void> deleteStore(String documentId) async {
  await _db.collection("stores").doc(documentId).delete();
}

Future<List<StoresMap>> retrieveStores() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection("stores").get();

  var collectionRef = _db.collection('stores');
  var snapshot2 = await collectionRef.count().get();
  log(snapshot2.count.toString());
  log(snapshot2.query.get().toString());

  return snapshot.docs
      .map((docSnapshot) => StoresMap.fromDocumentSnapshot(docSnapshot))
      .toList();
}

Future<QuerySnapshot<Map<String, dynamic>>> retrieveStoresAsMap() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection("stores").get();
  //log(snapshot.toString());
  var x = snapshot.docs
      .map((docSnapshot) => StoresMap.fromDocumentSnapshot(docSnapshot))
      .toList()
      .toString();
  log(x);
  log('retrieveStoresAsMap');
  return snapshot;
}

// class FirebaseService {
//   final CollectionReference usersCollection =
//       FirebaseFirestore.instance.collection('users');

//   Future<List<UserMap>> getAllUsers() async {
//     try {
//       QuerySnapshot<Object?> querySnapshot = await usersCollection.get();

//       List<UserMap> users = querySnapshot.docs
//           .map((doc) => UserMap.fromDocumentSnapshot(
//               doc as DocumentSnapshot<Map<String, dynamic>>))
//           .toList();

//       return users;
//     } catch (e) {
//       print('Error fetching users: $e');
//       return [];
//     }
//   }
// }

Future<List<UserMap>> getAllUsers() async {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  try {
    QuerySnapshot<Object?> querySnapshot = await usersCollection.get();
    if (querySnapshot != null) {
      log('not null');
      // Rest of your code...
    } else {
      log('Query snapshot is null.');
      return [];
    }
//logging
    var x = querySnapshot.docs
        .map((doc) => StoresMap.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    String dd = jsonEncode(x);
    log(dd);
// logging

    List<UserMap> users = querySnapshot.docs
        .map((doc) => UserMap.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    return users;
  } catch (e) {
    print('Error fetching users: $e');
    return [];
  }
}

Future<List<StoresMap>> getAllStores() async {
  final CollectionReference storesCollection =
      FirebaseFirestore.instance.collection('stores');
  try {
    QuerySnapshot<Object?> querySnapshot = await storesCollection.get();

//logging
    var x = querySnapshot.docs
        .map((doc) => StoresMap.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    String dd = jsonEncode(x);
    log(dd);
// logging

    List<StoresMap> stores = querySnapshot.docs
        .map((doc) => StoresMap.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    return stores;
  } catch (e) {
    print('Error fetching stores: $e');
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
    print('Error fetching owner name: $e');
    return 'Unknown Owner';
  }
}

Future<List<ClientsMap>> getAllClients() async {
  final CollectionReference clientsCollection =
      FirebaseFirestore.instance.collection('clients');
  try {
    QuerySnapshot<Object?> querySnapshot = await clientsCollection.get();

//logging
    var x = querySnapshot.docs
        .map((doc) => StoresMap.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    String dd = jsonEncode(x);
    log(dd);
// logging

    List<ClientsMap> clients = querySnapshot.docs
        .map((doc) => ClientsMap.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    return clients;
  } catch (e) {
    print('Error fetching clients: $e');
    return [];
  }
}

Future<List<OrdersMap>> getAllOrders() async {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  try {
    QuerySnapshot<Object?> querySnapshot = await ordersCollection.get();

//logging
    var x = querySnapshot.docs
        .map((doc) => StoresMap.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    String dd = jsonEncode(x);
    log(dd);
// logging

    List<OrdersMap> orders = querySnapshot.docs
        .map((doc) => OrdersMap.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    return orders;
  } catch (e) {
    print('Error fetching  orders: $e');
    return [];
  }
}
