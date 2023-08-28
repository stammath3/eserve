import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_serve/Models/user_model.dart';
import 'package:e_serve/View/basket_view.dart';
import 'package:e_serve/View/store_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/order_model.dart';
import '../Models/store_model.dart';

class TablesViewScreen extends StatefulWidget {
  final StoresMap store;
  final UserMap user;
  const TablesViewScreen({Key? key, required this.user, required this.store})
      : super(key: key);

  @override
  _TableViewScreenState createState() => _TableViewScreenState(store, user);
}

class _TableViewScreenState extends State<TablesViewScreen> {
  List<TableData> tables = []; // New list to store tables
  final StoresMap store;
  final UserMap user;
  _TableViewScreenState(this.store, this.user);

  @override
  void initState() {
    super.initState();
    tables = (widget.store.tables as List).map((tableData) {
      return TableData(
        tableId: tableData['table_id'],
        orderId: tableData['order_id'],
        isReserved: tableData['is_reserved'],
        name: tableData['name'],
        userId: tableData['user_id'],
      );
    }).toList();
  }

  void _navigateToStoreDetail() {
    final reservedTable = tables.firstWhere((table) => table.userId == user.id,
        orElse: () => TableData(
            tableId: -1,
            orderId: -1,
            isReserved: false,
            name: '',
            userId: '')); // Default if no reservation

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoreDetailScreen(
          store: store,
          user: user,
          reservedTable: reservedTable,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.store.name ?? 'Store Detail'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Tables'), // Header for tables
              Expanded(
                  child: ListView.builder(
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  final table = tables[index];
                  final isReserved = table.isReserved;

                  final buttonColor = isReserved ? Colors.red : Colors.green;
                  return ListTile(
                    title: Text('Table Name: ${table.name}'),
                    subtitle: Text('ID of Reservation: ${table.tableId}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Reserved: ${isReserved.toString()}'),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: isReserved || table.userId.isNotEmpty
                              ? null // Disable the button if the table is reserved
                              : () async {
                                  final userID = user.id;

                                  final hasReservedTable = tables.any((t) =>
                                      t.userId.toString() == userID &&
                                      t.tableId != table.tableId);
                                  log('hasReservedTableeeeeeeeeeeee');
                                  log(hasReservedTable.toString());

                                  if (!isReserved &&
                                      table.userId.isEmpty &&
                                      !hasReservedTable) {
                                    // Check if the user has already reserved a table

                                    if (!isReserved) {
                                      await FirebaseFirestore.instance
                                          .collection('stores')
                                          .doc(widget.store.id)
                                          .update({
                                        'tables': FieldValue.arrayRemove([
                                          {
                                            'table_id': table.tableId,
                                            'order_id': -1,
                                            'is_reserved': isReserved,
                                            'name': table.name,
                                            'user_id': table.userId,
                                          }
                                        ])
                                      });

                                      await FirebaseFirestore.instance
                                          .collection('stores')
                                          .doc(widget.store.id)
                                          .update({
                                        'tables': FieldValue.arrayUnion([
                                          {
                                            'table_id': table.tableId,
                                            'order_id': -1,
                                            'is_reserved': true,
                                            'name': table.name,
                                            'user_id': userID,
                                          }
                                        ])
                                      });

                                      setState(() {
                                        table.isReserved = true;
                                        table.userId = userID;
                                      });
                                    } else {
                                      // Notify the user that they have already reserved a table
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'You have already reserved a table')),
                                      );
                                    }
                                  } else {
                                    // Notify the user that they have already reserved a table
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'You have already reserved a table')),
                                    );
                                  }
                                },
                          child: Text('Reserve'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: buttonColor, // Text color
                            // Disable the button's click animation
                            animationDuration: Duration.zero,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final hasReservedTable =
                      tables.any((t) => t.userId == user.id);
                  if (hasReservedTable) {
                    _navigateToStoreDetail();
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Reservation Required'),
                          content: Text(
                              'You need to reserve a table to make an order.'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Make an order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
