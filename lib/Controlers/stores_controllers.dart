import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/models.dart';

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
  return snapshot.docs
      .map((docSnapshot) => StoresMap.fromDocumentSnapshot(docSnapshot))
      .toList();
}

Future<QuerySnapshot<Map<String, dynamic>>> retrieveStoresAsMap() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection("stores").get();
  var x = snapshot.docs
      .map((docSnapshot) => StoresMap.fromDocumentSnapshot(docSnapshot))
      .toList()
      .toString();
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

Future<List<StoresMap>> getAllStores() async {
  final CollectionReference storesCollection =
      FirebaseFirestore.instance.collection('stores');
  try {
    QuerySnapshot<Object?> querySnapshot = await storesCollection.get();

    List<StoresMap> stores = querySnapshot.docs
        .map((doc) => StoresMap.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    // log('storesssssssssssssssss');
    //log(stores.toString());
    return stores;
  } catch (e) {
    //log('Error fetching stores: $e');
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
