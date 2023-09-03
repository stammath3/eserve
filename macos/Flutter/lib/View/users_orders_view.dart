// ignore_for_file: library_private_types_in_public_api

import 'package:e_serve/Controlers/stores_controllers.dart';
import 'package:e_serve/Models/store_model.dart';

import '../Models/order_model.dart';
import '../Models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersOrders extends StatefulWidget {
  final UserMap user;
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
        title: const Text('User Orders'),
        backgroundColor: const Color.fromARGB(255, 215, 35, 35),
      ),
      body: StreamBuilder<List<OrdersMap>>(
        stream: _userOrdersStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<OrdersMap> userOrders = snapshot.data!;
            return ListView.builder(
              itemCount: userOrders.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3, // Add a slight elevation to the card
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: FutureBuilder<StoresMap?>(
                    future: getStoreDetails(userOrders[index].store),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Text('Store not found');
                      } else {
                        StoresMap store = snapshot.data!;
                        return ListTile(
                          title: Text('Store: ${store.name}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cost: ${userOrders[index].cost} 	€'),
                            ],
                          ),
                          trailing: Text(
                              'Concluded: ${userOrders[index].concluded.toString()}'),
                        );
                      }
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
