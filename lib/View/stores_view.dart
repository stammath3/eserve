// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:e_serve/Controlers/stores_controllers.dart';
import 'package:e_serve/Controlers/user_controllers.dart';
import 'package:e_serve/View/tables_view.dart';
import 'package:e_serve/View/user_profile_view.dart';
import 'package:e_serve/View/users_orders_view.dart';
import 'package:e_serve/View/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/routes.dart';
import '../Models/store_model.dart';
import '../Models/user_model.dart';

enum MenuAction {
  profile,
  orders,
  logout,
}

class StoresView extends StatefulWidget {
  const StoresView({super.key});

  @override
  State<StoresView> createState() => _StoresViewState();
}

class _StoresViewState extends State<StoresView> {
  late String firebaseUserID;
  late UserMap currentUser;

  @override
  void initState() {
    super.initState();
    // Initialize firebaseUserID
    firebaseUserID = FirebaseAuth.instance.currentUser!.uid;
    getUserData();
  }

  Future<void> getUserData() async {
    final x = await getUserByID(firebaseUserID);
    setState(() {
      currentUser = x!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores '),
        backgroundColor: const Color.fromARGB(255, 215, 35, 35),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  break;
                case MenuAction.profile:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserProfilePage(currentUser), // Pass the user details
                    ),
                  );
                  break;
                case MenuAction.orders:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UsersOrders(currentUser), // Pass the user details
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.profile, // Define this value in your enum
                  child: Text('Profile'),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.orders, // Define this value in your enum
                  child: Text('Orders'),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout, // Define this value in your enum
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder<List<StoresMap>>(
        future: getAllStores(), // Fetch the list of stores
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching stores'));
          } else if (snapshot.hasData) {
            List<StoresMap> stores = snapshot.data!;
            return StoresListView(
              stores: stores,
              user: currentUser,
            );
          } else {
            return const Center(child: Text('No stores found'));
          }
        },
      ),
    );
  }
}

class StoresListView extends StatelessWidget {
  final List<StoresMap> stores;
  final UserMap user;

  const StoresListView({super.key, required this.stores, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        final logoBytes =
            base64Decode(store.imageData); // Decode Base64 to bytes
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: Image.memory(logoBytes),
            title: Text(store.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TablesViewScreen(
                    store: store,
                    user: user,
                  ), // Pass store details
                ),
              );
            },
          ),
        );
      },
    );
  }
}
