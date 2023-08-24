import 'package:flutter/material.dart';

import '../Models/models.dart';

class StoreDetailScreen extends StatelessWidget {
  final StoresMap store; // Replace 'StoresMap' with your actual class name

  StoreDetailScreen(this.store);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(store.name ?? 'Store Detail')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Store Name: ${store.name ?? 'No Name'}'),
            Text('Store Owner: ${store.owner ?? 'No Owner'}'),
            Text('Store ID: ${store.id ?? 'No ID'}'),
            // Display other store details here
          ],
        ),
      ),
    );
  }
}
