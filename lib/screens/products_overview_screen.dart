import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
  food,
  beverage,
  clothes,
  sports,
  pets,
  other,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // var _showOnlyFavorites = false;

  var filter = 'all';
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                switch (selectedValue) {
                  case FilterOptions.All:
                    filter = 'all';
                    break;

                  case FilterOptions.Favorites:
                    filter = 'favorites';
                    break;

                  case FilterOptions.food:
                    filter = 'food';
                    break;

                  case FilterOptions.beverage:
                    filter = 'beverage';
                    break;

                  case FilterOptions.clothes:
                    filter = 'clothes';
                    break;

                  case FilterOptions.pets:
                    filter = 'pets';
                    break;

                  case FilterOptions.sports:
                    filter = 'sports';
                    break;

                  case FilterOptions.other:
                    filter = 'other';
                    break;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: Text('Food'),
                value: FilterOptions.food,
              ),
              PopupMenuItem(
                child: Text('Beverage'),
                value: FilterOptions.beverage,
              ),
              PopupMenuItem(
                child: Text('Clothes'),
                value: FilterOptions.clothes,
              ),
              PopupMenuItem(
                child: Text('Sports'),
                value: FilterOptions.sports,
              ),
              PopupMenuItem(
                child: Text('Pets'),
                value: FilterOptions.pets,
              ),
              PopupMenuItem(
                child: Text('other'),
                value: FilterOptions.other,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(filter),
    );
  }
}
