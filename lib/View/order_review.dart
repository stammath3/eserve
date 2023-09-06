import 'package:flutter/material.dart';
import '../Controlers/orders_controllers.dart';
import '../Models/order_model.dart';
import '../Models/store_model.dart';
import '../Models/user_model.dart';

class OrderPage extends StatelessWidget {
  final Basket basket;
  final StoresMap store;
  final UserMap user;
  final TableData table;

  const OrderPage(
      {Key? key,
      required this.basket,
      required this.store,
      required this.user,
      required this.table})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MenuItems> orderItems = basket.getItems();

    double totalCost =
        orderItems.fold(0.0, (sum, item) => sum + double.parse(item.cost));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Review'),
        backgroundColor: const Color.fromARGB(255, 215, 35, 35),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: orderItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(orderItems[index].name),
                      subtitle: Text('Cost: ${orderItems[index].cost}  	€'),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total Cost: $totalCost 	€',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                createNewOrder(
                    user, store, table, totalCost, context, orderItems, basket);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Text('Order'),
            ),
          ],
        ),
      ),
    );
  }
}
