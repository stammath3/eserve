//Orders

import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersMap {
  late String user;
  late bool concluded;
  late dynamic order;
  late int order_id;
  late String store;

  OrdersMap({
    required this.user,
    required this.concluded,
    required this.order,
    required this.order_id,
    required this.store,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'concluded': concluded,
      'order': order,
      'order_id': order_id,
      'store': store,
    };
  }

  @override
  String toString() {
    return 'OrdersMap{user: $user, concluded: $concluded, order: $order, '
        'order_id: $order_id, store: $store}';
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'concluded': concluded,
      'order': order,
      'order_id': order_id,
      'store': store,
    };
  }

  OrdersMap.fromMap(Map<String, dynamic> ordersMap)
      : user = ordersMap["user"],
        concluded = ordersMap["concluded"],
        order = ordersMap["order"],
        order_id = ordersMap["order_id"],
        store = ordersMap["store"];

  OrdersMap.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : order_id = doc.data()!["order_id"],
        user = doc.data()!["user"],
        concluded = doc.data()!["concluded"],
        order = doc.data()!["order"],
        store = doc.data()!["store"];
}

//MenuItem
class MenuItems {
  final String cost;
  final String name;
  final int id;

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
