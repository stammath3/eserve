import 'dart:developer';

import 'package:e_serve/Controlers/stores_controllers.dart';
import 'package:e_serve/Models/store_model.dart';

import '../Models/order_model.dart';
import '../Models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersOrders extends StatefulWidget {
  final UserMap user; // Pass the user details to the page

  const UsersOrders(this.user, {Key? key}) : super(key: key);

  @override
  _UsersOrdersState createState() => _UsersOrdersState();
}

class _UsersOrdersState extends State<UsersOrders> {
  late Stream<List<OrdersMap>> _userOrdersStream;

  @override
  void initState() {
    super.initState();
    _userOrdersStream = getUserOrders(widget.user.id);
    log('userrrr id : ');
    log(widget.user.id);
    log(widget.user.toString());
  }

  Stream<List<OrdersMap>> getUserOrders(String userId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('user', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => OrdersMap.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Orders'),
      ),
      body: StreamBuilder<List<OrdersMap>>(
        stream: _userOrdersStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<OrdersMap> userOrders = snapshot.data!;
            return ListView.builder(
              itemCount: userOrders.length,
              itemBuilder: (context, index) {
                return FutureBuilder<StoresMap?>(
                  future: getStoreDetails(userOrders[index].store),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Text('Store not found');
                    } else {
                      StoresMap store = snapshot.data!;
                      return ListTile(
                        title: Text('Order ID: ${userOrders[index].order_id}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Store: ${store.name}'),
                            Text('Table ID: ${userOrders[index].table_id}'),
                          ],
                        ),
                        trailing: Text(
                            'Concluded: ${userOrders[index].concluded.toString()}'),
                      );
                    }
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
