import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/auth_controller.dart';
import 'package:mobile_food_delivery/controllers/user_controller.dart';
import 'package:mobile_food_delivery/routes/route_helper.dart';
import 'package:mobile_food_delivery/utils/colors.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';
import 'package:mobile_food_delivery/widgets/account_prop.dart';
import 'package:mobile_food_delivery/widgets/app_icon.dart';
import 'package:mobile_food_delivery/widgets/big_text.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  void _loadUserDetails() {
    String accountId = Get.find<AuthController>().accountId;
    if (accountId.isNotEmpty) {
      Get.find<UserController>().getUserDetails(accountId);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed(RouteHelper.getLogin());
      });
    }
  }

  void _logout() async {
    await Get.find<AuthController>().logout();
    Get.offNamed(RouteHelper.getLogin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: BigText(
          text: "Thông tin cá nhân",
          size: Dimensions.value_24,
          color: Colors.white,
        ),
      ),
      body: GetBuilder<UserController>(
        builder: (userController) {
          return userController.isLoaded
              ? Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(top: Dimensions.value_20),
                  child: Column(
                    children: [
                      AppIcon(
                        icon: Icons.person,
                        iconSize: Dimensions.value_24 * 3,
                        backgroundColor: AppColors.mainColor,
                        size: Dimensions.value_24 * 6,
                        iconColor: Colors.white,
                      ),
                      SizedBox(height: Dimensions.value_30),
                      Column(
                        children: [
                          AccountProp(
                            appIcon: AppIcon(
                              icon: Icons.person,
                              iconColor: Colors.white,
                              iconSize: Dimensions.value_24,
                              backgroundColor: AppColors.mainColor,
                              size: Dimensions.value_24 * 2,
                            ),
                            bigText: BigText(
                              text: userController.user!.fullName,
                            ),
                          ),
                          SizedBox(height: Dimensions.value_15),
                          AccountProp(
                            appIcon: AppIcon(
                              icon: Icons.phone,
                              iconColor: Colors.white,
                              iconSize: Dimensions.value_24,
                              backgroundColor: AppColors.yellowColor,
                              size: Dimensions.value_24 * 2,
                            ),
                            bigText: BigText(
                              text: userController.user!.phoneNumber,
                            ),
                          ),
                          SizedBox(height: Dimensions.value_15),
                          AccountProp(
                            appIcon: AppIcon(
                              icon: Icons.email,
                              iconColor: Colors.white,
                              iconSize: Dimensions.value_24,
                              backgroundColor: AppColors.yellowColor,
                              size: Dimensions.value_24 * 2,
                            ),
                            bigText: BigText(
                              text: userController.user!.email,
                            ),
                          ),
                          SizedBox(height: Dimensions.value_15),
                          AccountProp(
                            appIcon: AppIcon(
                              icon: Icons.calendar_month,
                              iconColor: Colors.white,
                              iconSize: Dimensions.value_24,
                              backgroundColor: AppColors.yellowColor,
                              size: Dimensions.value_24 * 2,
                            ),
                            bigText: BigText(
                              text: userController.user!.birthday.toString().split(' ')[0],
                            ),
                          ),
                          SizedBox(height: Dimensions.value_15),
                          AccountProp(
                            appIcon: AppIcon(
                              icon: Icons.house,
                              iconColor: Colors.white,
                              iconSize: Dimensions.value_24,
                              backgroundColor: AppColors.yellowColor,
                              size: Dimensions.value_24 * 2,
                            ),
                            bigText: BigText(
                              text: userController.user!.address,
                              gestureDetector: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Địa chỉ'),
                                        content: Text(userController.user!.address),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Đóng'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: Dimensions.value_30),
                          ElevatedButton(
                            onPressed: _logout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainColor,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            ),
                            child: const Text('Đăng xuất'),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
