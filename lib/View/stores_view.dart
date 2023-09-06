// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController _searchController = TextEditingController();
  late UserMap currentUser;
  late List<StoresMap> _allStores;
  late List<StoresMap> _filteredStores; // Add this line

  @override
  void initState() {
    super.initState();
    firebaseUserID = FirebaseAuth.instance.currentUser!.uid;
    getUserData();
    _allStores = []; // Initialize _allStores as an empty list
    _filteredStores = []; // Initialize _filteredStores as an empty list
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
        title: const Text('Stores'),
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
                      builder: (context) => UserProfilePage(currentUser),
                    ),
                  );
                  break;
                case MenuAction.orders:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsersOrders(currentUser),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.profile,
                  child: Text('Profile'),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.orders,
                  child: Text('Orders'),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search stores by name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchStores(""); // Clear the search and show all stores
                  },
                ),
              ),
              onChanged: (query) {
                setState(() {
                  if (query.isEmpty) {
                    // If the query is empty, show all stores
                    _filteredStores = _allStores;
                  } else {
                    // If there's a query, filter the stores based on the query
                    _filteredStores = _allStores.where((store) {
                      return store.name
                          .toLowerCase()
                          .contains(query.toLowerCase());
                    }).toList();
                  }
                });
              },
              onSubmitted: (query) {
                // Handle search when the user presses enter
                // You will implement the search functionality here
                _searchStores(query); // Perform the search
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StoresMap>>(
              future: getAllStores(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching stores'));
                } else if (snapshot.hasData) {
                  _allStores = snapshot.data!; // Update _allStores
                  // final storesToDisplay =
                  //     _filteredStores.isNotEmpty ? _filteredStores : _allStores;
                  final storesToDisplay = _searchController.text.isEmpty
                      ? _allStores
                      : _filteredStores;

                  if (storesToDisplay.isEmpty) {
                    // If there are no stores to display, show a message
                    return const Center(child: Text('No stores found'));
                  } else {
                    return StoresListView(
                      stores: storesToDisplay,
                      user: currentUser,
                    );
                  }
                } else {
                  return const Center(child: Text('No stores found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _searchStores(String query) {
    if (query.isEmpty || query == "") {
      setState(() {
        _filteredStores.clear(); // Clear the filtered stores list
        //_filteredStores = _allStores;
      });
    } else {
      final filteredStores = _allStores
          .where(
              (store) => store.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        _filteredStores = filteredStores; // Update filtered stores
      });
    }

    if (_filteredStores.isEmpty) {
      // If no stores match the search query, clear the list
      setState(() {
        _allStores.clear();
      });
    }
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
        final logoBytes = base64Decode(store.imageData);
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
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
