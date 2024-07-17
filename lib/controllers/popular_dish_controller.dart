import 'package:get/get.dart';
import 'package:mobile_food_delivery/data/repository/popular_product_repo.dart';
import 'package:mobile_food_delivery/models/dish.dart';

class PopularProductController extends GetxController {
  final PopularProductRepo popularProductRepo;
  PopularProductController({required this.popularProductRepo});

  List<dynamic> _popularProductList = [];
  List<dynamic> get popularProductList => _popularProductList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _quantity = 0;
  int get quantity => _quantity;

Future<void> getPopularProductList() async {
    Response response = await popularProductRepo.getPopularProductList();
    if (response.statusCode == 200) {
      _popularProductList = [];
      // The response.body['content'] is already a List, so we don't need to use Product.fromJson
      List<dynamic> productsList = response.body['content'];
      for (var dish in productsList) {
        _popularProductList.add(Dish.fromJson(dish));
      }
      _isLoaded = true;
      update();
    } else {
      print("Could not get products");
    }
  }

  Future<void> getAllDishes() async {
    Response response = await popularProductRepo.getAllDishes();
    if (response.statusCode == 200) {
      _popularProductList = [];
      List<dynamic> dishesList = response.body['content'];
      for (var dish in dishesList) {
        _popularProductList.add(Dish.fromJson(dish));
      }
      _isLoaded = true;
      update();
    } else {
      print("Could not get dishes");
    }
  }

  Future<void> updateDish(int id, Map<String, dynamic> data) async {
    Response response = await popularProductRepo.updateDish(id, data);
    if (response.statusCode == 200) {
      print("Dish updated successfully");
      getAllDishes(); // Refresh the list
    } else {
      print("Failed to update dish");
    }
  }

  Future<void> createDish(Map<String, dynamic> data) async {
    Response response = await popularProductRepo.createDish(data);
    if (response.statusCode == 201) {
      print("Dish created successfully");
      getAllDishes(); // Refresh the list
    } else {
      print("Failed to create dish");
    }
  }

  Future<Dish?> getDishById(int id) async {
    Response response = await popularProductRepo.getDishById(id);
    if (response.statusCode == 200) {
      return Dish.fromJson(response.body['content']);
    } else {
      print("Could not get dish");
      return null;
    }
  }

  Future<void> deleteDish(int id) async {
    Response response = await popularProductRepo.deleteDish(id);
    if (response.statusCode == 200) {
      print("Dish deleted successfully");
      getAllDishes(); // Refresh the list
    } else {
      print("Failed to delete dish");
    }
  }

  Future<void> getDishByCategory(int categoryId) async {
    Response response = await popularProductRepo.getDishByCategory(categoryId);
    if (response.statusCode == 200) {
      _popularProductList = [];
      List<dynamic> dishesList = response.body['content'];
      for (var dish in dishesList) {
        _popularProductList.add(Dish.fromJson(dish));
      }
      _isLoaded = true;
      update();
    } else {
      print("Could not get dishes for category");
    }
  }

  void updateQuantity(bool isIncrement) {
    if (isIncrement) {
      if (_quantity < 20) {
        _quantity++;
      } else {
        Get.snackbar("Maximum reached", "You can't add more of this item");
      }
    } else {
      if (_quantity > 0) {
        _quantity--;
      } else {
        Get.snackbar("Minimum reached", "You can't reduce the quantity further");
      }
    }
    update();
  }
  void resetQuantity() {
    _quantity = 0;
    update();
  }

  void searchDishes(String query) {
  if (query.isEmpty) {
    getAllDishes();
  } else {
    _popularProductList = _popularProductList.where((dish) =>
      dish.name!.toLowerCase().contains(query.toLowerCase()) ||
      dish.ingredients!.toLowerCase().contains(query.toLowerCase())
    ).toList();
    update();
  }
}
}
