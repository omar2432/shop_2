import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final String filter;

  ProductsGrid(this.filter);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    var products = productsData.items;
    var featuredproducts = productsData.featuredItems;
    //final products = showFavs ? productsData.favoriteItems : productsData.items;

    switch (filter) {
      case 'All Products':
        products = productsData.items;
        break;

      case 'favorites':
        products = productsData.favoriteItems;
        break;

      case 'featured':
        products = featuredproducts; // heree
        //  print('featuredproducts   heree');
        break;

      default:
        products = productsData.getcategoryItems(filter);
        break;
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // builder: (c) => products[i],
        value: products[i],
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
