import 'package:e_serve/Controlers/stores_controllers.dart';
import 'package:e_serve/Models/user_model.dart';
import 'package:e_serve/View/home_page_view.dart';
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
  List<TableData> tables = [];
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

  Future<void> _refreshPage() async {
    // Fetch updated table data or any other data refresh logic here
    final updatedTables = await getStoreTableDetails(store.id);
    setState(() {
      tables = updatedTables;
    });
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              }),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Tables',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshPage, // Pass a function reference
                  child: ListView.builder(
                    itemCount: tables.length,
                    itemBuilder: (context, index) {
                      final table = tables[index];
                      final isReserved = table.isReserved;

                      final buttonColor =
                          isReserved ? Colors.grey : Colors.green;
                      final lineColour =
                          isReserved ? Colors.grey : Colors.green;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
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
                            Icons.table_restaurant,
                            size: 48,
                            color: lineColour,
                          ),
                          title: Text(table.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: isReserved || table.userId.isNotEmpty
                                    ? null
                                    : () async {
                                        final userID = user.id;

                                        final hasReservedTable = tables.any(
                                            (t) =>
                                                t.userId.toString() == userID &&
                                                t.tableId != table.tableId);
                                        if (!isReserved &&
                                            table.userId.isEmpty &&
                                            !hasReservedTable) {
                                          if (!isReserved) {
                                            reserveTable(widget, table,
                                                isReserved, store, user);

                                            setState(() {
                                              table.isReserved = true;
                                              table.userId = userID;
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'You have already reserved a table')),
                                            );
                                          }
                                        } else {
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
                                  backgroundColor: buttonColor,
                                  animationDuration: Duration.zero,
                                ),
                                child: const Text('Reserve'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
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
                                Navigator.of(context).pop();
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
