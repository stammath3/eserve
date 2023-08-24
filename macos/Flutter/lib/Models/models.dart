import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';

//Users
class UserMap {
  //late dynamic? displayName;
  late String? email;
  late bool emailVerified;
  late bool isAnonymous;
  late String creationTime;
  late String uid;

  UserMap({
    //required this.displayName,
    required this.email,
    required this.emailVerified,
    required this.isAnonymous,
    required this.creationTime,
    required this.uid,
  });

  @override
  String toString() {
    return 'UserMap{email: $email, emailVerified: $emailVerified, '
        'isAnonymous: $isAnonymous, creationTime: $creationTime, uid: $uid}';
  }

  Map<String, dynamic> toJson() {
    return {
      //'displayName': displayName,
      'email': email,
      'emailVerified': emailVerified,
      'isAnonymous': isAnonymous,
      'creationTime': creationTime,
      'uid': uid,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      //'displayName': displayName,
      'email': email,
      'emailVerified': emailVerified,
      'isAnonymous': isAnonymous,
      'creationTime': creationTime,
      'uid': uid,
    };
  }

  UserMap.fromMap(Map<String, dynamic> userMap)
      : //displayName = userMap["displayName"],
        email = userMap["email"],
        emailVerified = userMap["emailVerified"],
        isAnonymous = userMap["isAnonymous"],
        creationTime = userMap["creationTime"],
        uid = userMap["uid"];

  UserMap.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        email = doc.data()!["email"],
        //displayName = doc.data()!["displayName"],
        emailVerified = doc.data()!["emailVerified"],
        isAnonymous = doc.data()!["isAnonymous"],
        creationTime = doc.data()!["creationTime"];
}

//Stores
class StoresMap {
  late List<dynamic> menu;
  late String name;
  late bool online;
  //late DocumentReference<Map<String, dynamic>> owner;
  late String owner;
  late List<dynamic> tables;
  late String id;
  late String imageData;

  StoresMap({
    required this.menu,
    required this.name,
    required this.online,
    required this.owner,
    required this.tables,
    required this.id,
    required this.imageData,
  });

  Map<String, dynamic> toMap() {
    return {
      'menu': menu,
      'name': name,
      'online': online,
      'owner': owner,
      'tables': tables,
      'id': id,
      'imageData': imageData,
    };
  }

  @override
  String toString() {
    return 'StoresMap{menu: $menu, name: $name, online: $online, '
        'owner: $owner, tables: $tables, id: $id, imageData: $imageData}';
  }

  Map<String, dynamic> toJson() {
    return {
      'menu': menu,
      'name': name,
      'online': online,
      'owner': owner,
      'tables': tables,
      'id': id,
    };
  }

  StoresMap.fromMap(Map<String, dynamic> storesMap)
      : menu = storesMap["menu"],
        name = storesMap["name"],
        online = storesMap["online"],
        owner = storesMap["owner"],
        tables = storesMap["tables"],
        id = storesMap["id"],
        imageData = storesMap["imageData"];

  StoresMap.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        menu = doc.data()!["menu"],
        name = doc.data()!["name"],
        online = doc.data()!["online"],
        owner = doc.data()!["owner"],
        tables = doc.data()!["tables"],
        imageData = doc.data()!["imageData"];
}

//Clients

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
        stores = doc.data()!["stores"],
        username = doc.data()!["username"];
}

//Clients

class OrdersMap {
  late String client;
  late Bool concluded;
  late List<dynamic> order;
  late String order_id;
  late String store;

  OrdersMap({
    required this.client,
    required this.concluded,
    required this.order,
    required this.order_id,
    required this.store,
  });

  Map<String, dynamic> toMap() {
    return {
      'client': client,
      'concluded': concluded,
      'order': order,
      'order_id': order_id,
      'store': store,
    };
  }

  @override
  String toString() {
    return 'OrdersMap{client: $client, concluded: $concluded, order: $order, '
        'order_id: $order_id, store: $store}';
  }

  Map<String, dynamic> toJson() {
    return {
      'client': client,
      'concluded': concluded,
      'order': order,
      'order_id': order_id,
      'store': store,
    };
  }

  OrdersMap.fromMap(Map<String, dynamic> clientsMap)
      : client = clientsMap["client"],
        concluded = clientsMap["concluded"],
        order = clientsMap["order"],
        order_id = clientsMap["order_id"],
        store = clientsMap["store"];

  OrdersMap.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : order_id = doc.data()!["order_id"],
        client = doc.data()!["client"],
        concluded = doc.data()!["concluded"],
        order = doc.data()!["order"],
        store = doc.data()!["store"];
}
