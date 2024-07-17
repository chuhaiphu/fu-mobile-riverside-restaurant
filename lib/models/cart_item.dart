import 'package:mobile_food_delivery/models/dish.dart';

class CartItem {
  String? dishId;
  String? name;
  double? dishPrice;  // Change this from int? to double?
  String? imageURL;
  int? quantity;
  bool? isExist;
  String? time;
  Dish? dish;

  CartItem({
    this.dishId,
    this.name,
    this.dishPrice,
    this.imageURL,
    this.quantity,
    this.isExist,
    this.time,
    this.dish
  });

  CartItem.fromJson(Map<String, dynamic> json) {
    dishId = json['dishId'];
    name = json['name'];
    dishPrice = json['dishPrice']?.toDouble();  // Convert to double
    imageURL = json['imageURL'];
    quantity = json['quantity'];
    isExist = json['isExist'];
    time = json['time'];
    dish = json['product'] != null ? Dish.fromJson(json['dish']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'dishId': dishId,
      'name': name,
      'dishPrice': dishPrice,
      'imageURL': imageURL,
      'quantity': quantity,
      'isExist': isExist,
      'time': time,
      'product': dish?.toJson()
    };
  }
}
