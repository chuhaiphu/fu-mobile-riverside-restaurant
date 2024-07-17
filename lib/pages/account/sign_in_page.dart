import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/base/show_custom_loader.dart';
import 'package:mobile_food_delivery/base/show_custom_snackbar.dart';
import 'package:mobile_food_delivery/controllers/auth_controller.dart';
import 'package:mobile_food_delivery/routes/route_helper.dart';
import 'package:mobile_food_delivery/utils/colors.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';
import 'package:mobile_food_delivery/widgets/big_text.dart';
import 'package:mobile_food_delivery/widgets/input_text_field.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    void signIn(AuthController authController) async {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      if (email.isEmpty) {
        showCustomSnackbar("Vui lòng nhập email", title: "Email trống");
      } else if (password.isEmpty) {
        showCustomSnackbar("Vui lòng nhập password", title: "Password trống");
      } else {
        authController.login(email, password).then((status) {
          if (status.isSuccess) {
            Get.offNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackbar(status.message);
          }
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (authController) {
        return !authController.isLoading ?
            SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: Dimensions.screenHeight * 0.05,
              ),
              SizedBox(
                height: Dimensions.screenHeight * 0.25,
                child: const Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80,
                    backgroundImage: AssetImage("assets/image/logo_part_1.png"),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: Dimensions.value_20, bottom: Dimensions.value_30),
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello",
                      style: TextStyle(
                        fontSize: Dimensions.value_24 * 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Riverside Restaurant xin chào",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: Dimensions.value_20,
                          )),
                    ),
                  ],
                ),
              ),
              InputTextField(
                  textEditingController: emailController, hintText: "Email", icon: Icons.email),
              SizedBox(
                height: Dimensions.value_20,
              ),
              InputTextField(
                textEditingController: passwordController,
                hintText: "Password",
                icon: Icons.circle,
                isObsecured: true,
              ),
              SizedBox(
                height: Dimensions.value_20,
              ),
              GestureDetector(
                onTap: () {
                  signIn(authController);
                },
                child: Container(
                  width: Dimensions.screenWidth / 2,
                  height: Dimensions.screenHeight / 13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.value_30),
                    color: AppColors.mainColor,
                  ),
                  child: Center(
                    child: BigText(
                      text: "Đăng nhập",
                      size: Dimensions.value_20 + Dimensions.value_10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        : const ShowCustomLoader();
      }),
    );
  }
}
