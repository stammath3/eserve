//Clients

import 'package:cloud_firestore/cloud_firestore.dart';

class ClientsMap {
  late String email;
  late String name;
  late List<dynamic> stores;
  late String id;
  late String username;

  ClientsMap({
    required this.email,
    required this.name,
    required this.stores,
    required this.id,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'stores': stores,
      'id': id,
      'username': username,
    };
  }

  @override
  String toString() {
    return 'ClientMap{email: $email, name: $name, stores: $stores, '
        'username: $username, id: $id}';
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'stores': stores,
      'username': username,
      'id': id,
    };
  }

  ClientsMap.fromMap(Map<String, dynamic> clientsMap)
      : email = clientsMap["email"],
        name = clientsMap["name"],
        stores = clientsMap["stores"],
        username = clientsMap["username"],
        id = clientsMap["id"];

  ClientsMap.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        email = doc.data()!["email"],
        name = doc.data()!["name"],
        stores = doc.data()!["stores"] ?? [],
        username = doc.data()!["username"];
}
