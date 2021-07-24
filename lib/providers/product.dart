import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

//enum Catgory { sports, clothes, food, beverages, other }

class Product with ChangeNotifier {
  final String id;
  final String creatorId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  String isverified;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.creatorId,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.category,
    @required this.isverified,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://fireeats-434d3.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
