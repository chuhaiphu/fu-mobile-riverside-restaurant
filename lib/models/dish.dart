// class Product {
//   int? _totalSize;
//   int? _typeId;
//   int? _offset;
//   late List<Products> _products;
//   List<Products> get products => _products;

//   Product({required totalSize, required typeId, required offset, required products}){
//     _totalSize = totalSize;
//     _typeId = typeId;
//     _offset = offset;
//     _products = products;
//   }

//   Product.fromJson(Map<String, dynamic> json) {
//     _totalSize = json['total_size'];
//     _typeId = json['type_id'];
//     _offset = json['offset'];
//     if (json['products'] != null) {
//       _products = <Products>[];
//       json['products'].forEach((v) {
//         _products.add(Products.fromJson(v));
//       });
//     }
//   }
// }

class Dish {
  String? dishId;
  String? imageURL;
  String? name;
  String? ingredients;
  double? dishPrice;  // Change this from int? to double?
  bool? isAvailable;
  String? createdDate;
  String? createdBy;
  String? updatedDate;
  String? updatedBy;
  String? dishCategoryId;

  Dish({
    this.dishId,
    this.imageURL,
    this.name,
    this.ingredients,
    this.dishPrice,
    this.isAvailable,
    this.createdDate,
    this.createdBy,
    this.updatedDate,
    this.updatedBy,
    this.dishCategoryId,
  });

  Dish.fromJson(Map<String, dynamic> json) {
    dishId = json['dishId'];
    imageURL = json['imageURL'];
    name = json['name'];
    ingredients = json['ingredients'];
    dishPrice = json['dishPrice']?.toDouble();  // Convert to double
    isAvailable = json['isAvailable'];
    createdDate = json['createdDate'];
    createdBy = json['createdBy'];
    updatedDate = json['updatedDate'];
    updatedBy = json['updatedBy'];
    dishCategoryId = json['dishCategoryId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'dishId': dishId,
      'imageURL': imageURL,
      'name': name,
      'ingredients': ingredients,
      'dishPrice': dishPrice,
      'isAvailable': isAvailable,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'updatedDate': updatedDate,
      'updatedBy': updatedBy,
      'dishCategoryId': dishCategoryId,
    };
  }
}
