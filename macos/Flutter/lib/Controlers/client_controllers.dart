import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/client_model.dart';

//final FirebaseFirestore _db = FirebaseFirestore.instance;

Future<List<ClientsMap>> getAllClients() async {
  final CollectionReference clientsCollection =
      FirebaseFirestore.instance.collection('clients');
  try {
    QuerySnapshot<Object?> querySnapshot = await clientsCollection.get();
    log(querySnapshot.docs.toString());

    List<ClientsMap> clients = querySnapshot.docs
        .map((doc) => ClientsMap.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    return clients;
  } catch (e) {
    log('Error fetching clients: $e');
    return [];
  }
}
