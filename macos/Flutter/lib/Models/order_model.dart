//Orders

// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersMap {
  late String user;
  late bool concluded;
  late dynamic order;
  late int order_id;
  late String store;
  late int table_id;
  late double cost;

  OrdersMap({
    required this.user,
    required this.concluded,
    required this.order,
    required this.order_id,
    required this.store,
    required this.table_id,
    required this.cost,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'concluded': concluded,
      'order': order,
      'order_id': order_id,
      'store': store,
      'table_id': table_id,
      'cost': cost,
    };
  }

  @override
  String toString() {
    return 'OrdersMap{user: $user, concluded: $concluded, order: $order, '
        'order_id: $order_id, store: $store, table_id: $table_id, cost: $cost}';
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'concluded': concluded,
      'order': order,
      'order_id': order_id,
      'store': store,
      'table_id': table_id,
      'cost': cost,
    };
  }

  OrdersMap.fromMap(Map<String, dynamic> ordersMap)
      : user = ordersMap["user"],
        concluded = ordersMap["concluded"],
        order = ordersMap["order"],
        order_id = ordersMap["order_id"],
        store = ordersMap["store"],
        table_id = ordersMap["table_id"],
        cost = ordersMap["cost"];

  OrdersMap.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : order_id = doc.data()!["order_id"],
        user = doc.data()!["user"],
        concluded = doc.data()!["concluded"],
        order = doc.data()!["order"],
        store = doc.data()!["store"],
        table_id = doc.data()!["table_id"],
        cost = doc.data()!["cost"];
}

//MenuItem
class MenuItems {
  final String cost;
  final String name;
  final int id;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MenuItems) return false;

    return cost == other.cost && name == other.name && id == other.id;
  }

  @override
  // ignore: deprecated_member_use
  int get hashCode => hashValues(cost, name, id);

  MenuItems({required this.cost, required this.name, required this.id});
}

//Basket
class Basket {
  List<MenuItems> items = [];

  void addItem(MenuItems item) {
    items.add(item);
  }

  void removeItem(MenuItems item) {
    items.remove(item);
  }

  List<MenuItems> getItems() {
    return items;
  }

  double getTotalCost() {
    double totalCost = 0;
    for (var item in items) {
      totalCost += double.tryParse(item.cost) ?? 0;
    }
    return totalCost;
  }
}

class TableData {
  late int tableId;
  late int orderId;
  late bool isReserved;
  late String name;
  late String userId;

  TableData({
    required this.tableId,
    required this.orderId,
    required this.isReserved,
    required this.name,
    required this.userId,
  });
}
