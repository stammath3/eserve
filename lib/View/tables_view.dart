// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state

import 'package:e_serve/Controlers/stores_controllers.dart';
import 'package:e_serve/Models/user_model.dart';
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
    tables = (widget.store.tables).map((tableData) {
      return TableData(
        tableId: tableData['table_id'],
        orderId: tableData['order_id'],
        isReserved: tableData['is_reserved'],
        name: tableData['name'],
        userId: tableData['user_id'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.store.name),
          backgroundColor: const Color.fromARGB(255, 215, 35, 35),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
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
              const Text(
                'Tables',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Make the text bold
                  fontSize: 18,
                  color: Colors.black,
                ),
              ), // Header for tables
              Expanded(
                  child: ListView.builder(
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  final table = tables[index];
                  final isReserved = table.isReserved;

                  final buttonColor = isReserved ? Colors.grey : Colors.green;
                  final lineColour = isReserved ? Colors.grey : Colors.green;

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: lineColour,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.table_restaurant, // Use the table icon
                        size: 48,
                        color: lineColour, // Customize the icon color
                      ),
                      title: Text(table.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: isReserved || table.userId.isNotEmpty
                                ? null // Disable the button if the table is reserved
                                : () async {
                                    //reserveTable(user, tables, isReserved, table, widget, context)
                                    final userID = user.id;

                                    final hasReservedTable = tables.any((t) =>
                                        t.userId.toString() == userID &&
                                        t.tableId != table.tableId);
                                    if (!isReserved &&
                                        table.userId.isEmpty &&
                                        !hasReservedTable) {
                                      // Check if the user has already reserved a table

                                      if (!isReserved) {
                                        reserveTable(widget, table, isReserved,
                                            store, user);

                                        setState(() {
                                          table.isReserved = true;
                                          table.userId = userID;
                                        });
                                      } else {
                                        // Notify the user that they have already reserved a table
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'You have already reserved a table')),
                                        );
                                      }
                                    } else {
                                      // Notify the user that they have already reserved a table
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'You have already reserved a table')),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: buttonColor, // Text color
                              // Disable the button's click animation
                              animationDuration: Duration.zero,
                            ),
                            child: const Text('Reserve'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () {
                  final hasReservedTable =
                      tables.any((t) => t.userId == user.id);
                  if (hasReservedTable) {
                    navigateToStoreDetail(tables, user, store, context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Reservation Required'),
                          content: const Text(
                              'You need to reserve a table to make an order.'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black)),
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Make an order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
