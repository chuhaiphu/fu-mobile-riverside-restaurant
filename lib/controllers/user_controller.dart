import 'package:get/get.dart';
import 'package:mobile_food_delivery/data/repository/user_repo.dart';
import 'package:mobile_food_delivery/models/user.dart';

class UserController extends GetxController {
  final UserRepo userRepo;
  
  UserController({required this.userRepo});

  User? _user;
  bool _isLoaded = false;
  String _error = '';

  User? get user => _user;
  bool get isLoaded => _isLoaded;
  String get error => _error;

  Future<void> getUserDetails(String userId) async {
    _isLoaded = false;
    _error = '';
    update();

    try {
      Response response = await userRepo.getUserDetails(userId);
      if (response.statusCode == 200) {
        _user = User.fromJson(response.body['content']);

      } else {
        _error = "Failed to get user details. Status code: ${response.statusCode}";
      }
    } catch (e) {
      _error = "Error getting user details: $e";
    }

    _isLoaded = true;
    update();
  }
}
