import 'dart:developer';

import 'package:e_serve/Controlers/stores_controllers.dart';
import 'package:e_serve/Controlers/user_controllers.dart';
import 'package:e_serve/View/store_details_screen.dart';
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
  // @override
  // initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     var stores = _asyncMethod();
  //   });

  //   super.initState();
  // }

  // _asyncMethod() async {
  //   //List<UserMap> users = await getAllUsers();
  //   //log(users.toString());

  //   List<UserMap> stores = await getAllStores();
  //   log(stores.toString());
  //   return stores;
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  late String firebaseUserID;
  late UserMap currentUser;

  @override
  void initState() {
    super.initState();
    // Initialize firebaseUserID
    firebaseUserID = FirebaseAuth.instance.currentUser!.uid;

    // Fetch user data using getUserByID
    getUserData();
  }

  Future<void> getUserData() async {
    final x = await getUserByID(firebaseUserID);
    setState(() {
      currentUser = x!;
      //log("edwwwwwwwwwwwwwwwww");
      //log(currentUser!.id.toString());
      //log(currentUser.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores '),
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
                  //log(shouldLogout.toString());
                  break;
                case MenuAction.profile:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfilePage(
                          currentUser!), // Pass the user details
                    ),
                  );
                  break;
                case MenuAction.orders:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UsersOrders(currentUser!), // Pass the user details
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.profile, // Define this value in your enum
                  child: Text('Profile'),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.orders, // Define this value in your enum
                  child: Text('Orders'),
                ),
                PopupMenuItem<MenuAction>(
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

  StoresListView({required this.stores, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        return ListTile(
          title: Text(store.name ?? 'No Name'),
          subtitle: Text(store.owner),
          trailing: Text(store.id ?? 'No ID'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoreDetailScreen(
                  store,
                  user: user,
                ), // Pass store details
              ),
            );
          },
        );
      },
    );
  }

// with doc reference ownwer

  // @override
  // Widget build(BuildContext context) {
  //   return ListView.builder(
  //     itemCount: stores.length,
  //     itemBuilder: (context, index) {
  //       final store = stores[index];
  //       return ListTile(
  //         title: Text(store.name ?? 'No Name'),
  //         subtitle: FutureBuilder<String>(
  //           future: getStoreOwnerName(
  //               store.owner), // Fetch owner's name from Firebase
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return Text('Loading...');
  //             } else if (snapshot.hasError) {
  //               return Text('Error fetching owner name');
  //             } else if (snapshot.hasData) {
  //               String ownerName = snapshot.data!;
  //               return Text(ownerName);
  //             } else {
  //               return Text('No Owner');
  //             }
  //           },
  //         ),
  //         trailing: Text(store.id ?? 'No ID'),
  //       );
  //     },
  //   );
  // }
}

// Future<bool> showLogOutDialog(BuildContext context) {
//   return showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Sign Out'),
//           content: const Text('Are you sure you want to sign out ?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//               child: const Text('Logout'),
//             ),
//           ],
//         );
//       }).then((value) => value ?? false);
// }

// Future<QuerySnapshot<Map<String, dynamic>>> _loadStoresAsList() async {
//   var stores = await retrieveStoresAsMap();
//   //log(stores.toString());
//   return stores;
// }
