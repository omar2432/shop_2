import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/products_toDeliver_item.dart';

import '../widgets/app_drawer.dart';

class ProductsToDeliver extends StatelessWidget {
  static const routeName = '/productsToDeliver';

  @override
  Widget build(BuildContext context) {
    print('building products to deliver');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('products To Deliver'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false)
            .fetchAndSetOrdersToDeliver(), // CHangeeee
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            print('here1');
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              print(dataSnapshot.error);
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              print('here3');
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.ordersToDeliver.length,
                  itemBuilder: (ctx, i) =>
                      DeliveryItem(orderData.ordersToDeliver[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
