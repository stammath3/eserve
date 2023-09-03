import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  // var x = snapshot.docs
  //     .map((docSnapshot) => StoresMap.fromDocumentSnapshot(docSnapshot))
  //     .toList()
  //     .toString();
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
