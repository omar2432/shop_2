import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class DeliveryItem {
  final String id;
  final double price;
  final int quantity;
  final String address;
  final String phone;
  final String title;
  final DateTime dateTime;

  DeliveryItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.address,
    @required this.phone,
    @required this.title,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<DeliveryItem> _ordersToDeliver = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  List<DeliveryItem> get ordersToDeliver {
    return [..._ordersToDeliver];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://fireeats-434d3.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  creatorId: item['creatorId'],
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://fireeats-434d3.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'creatorId': cp.creatorId,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> addingOrderToDeliver(List<CartItem> cartProducts, double total,
      String address, String phone) async {
    final url =
        'https://fireeats-434d3.firebaseio.com/deliver/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'address': address,
        'phone': phone,
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'creatorId': cp.creatorId,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
  }

  // TRYYYYYYYYYYYYYYYY

  Future<void> addingOrderToDeliverByProduct(List<CartItem> cartProducts,
      double total, String address, String phone) async {
    cartProducts.forEach((element) async {
      var creatorId = element.creatorId;
      final url =
          'https://fireeats-434d3.firebaseio.com/deliver/$creatorId.json?auth=$authToken';
      final timestamp = DateTime.now();
      final response = await http.post(
        url,
        body: json.encode({
          'address': address,
          'phone': phone,
          'dateTime': timestamp.toIso8601String(),
          'id': element.id,
          'title': element.title,
          'quantity': element.quantity,
          'price': element.price,
        }),
      );
    });
  }

  Future<void> fetchAndSetOrdersToDeliver() async {
    final url =
        'https://fireeats-434d3.firebaseio.com/deliver/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<DeliveryItem> loadedOrdersToDeliver = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    print(extractedData);
    extractedData.forEach((orderId, orderData) {
      print(orderData['title']);
      loadedOrdersToDeliver.add(
        DeliveryItem(
          id: orderId,
          price: orderData['price'],
          dateTime: DateTime.parse(orderData['dateTime']),
          address: orderData['address'],
          phone: orderData['phone'],
          quantity: orderData['quantity'],
          title: orderData['title'],
        ),
      );
      print(orderData['title']);
    });
    print('here3');
    _ordersToDeliver =
        loadedOrdersToDeliver.reversed.toList(); // hereeeeeeeeeeeeeeeee
    print('here4');
    print(_ordersToDeliver);
    notifyListeners();
  }
}
