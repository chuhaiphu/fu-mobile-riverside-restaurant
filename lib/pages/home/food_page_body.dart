import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_food_delivery/controllers/popular_dish_controller.dart';
import 'package:mobile_food_delivery/models/dish.dart';
import 'package:mobile_food_delivery/routes/route_helper.dart';
import 'package:mobile_food_delivery/utils/colors.dart';
import 'package:mobile_food_delivery/utils/dimensions.dart';
import 'package:mobile_food_delivery/widgets/app_column.dart';
import 'package:mobile_food_delivery/widgets/big_text.dart';
import 'package:mobile_food_delivery/widgets/small_text.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key});

  @override
  _FoodPageBodyState createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  double _currentPage = 0.0;
  final double _scaleFactor = 0.8;
  final double _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currentPage = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<PopularProductController>(
          builder: (products) {
            return products.isLoaded
                ? SizedBox(
                    height: Dimensions.pageView,
                    child: PageView.builder(
                        controller: pageController,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return _buildPageItem(
                              index, products.popularProductList[index]);
                        }),
                  )
                : const CircularProgressIndicator(color: AppColors.mainColor);
          },
        ),
        GetBuilder<PopularProductController>(
          builder: (products) {
            return DotsIndicator(
              dotsCount: products.popularProductList.isEmpty ? 1 : 6,
              position: _currentPage,
              decorator: DotsDecorator(
                size: const Size.square(9.0),
                activeColor: AppColors.mainColor,
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            );
          },
        ),

        SizedBox(height: Dimensions.value_30),

        Container(
          margin: EdgeInsets.only(left: Dimensions.value_30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(text: "Danh sách món ăn"),
              SizedBox(width: Dimensions.value_10),
              Container(
                margin: const EdgeInsets.only(bottom: 3),
                child: BigText(text: ".", color: AppColors.textColor),
              ),
              SizedBox(width: Dimensions.value_10),
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: SmallText(text: "Món ăn nổi bật"),
              ),
            ],
          ),
        ),

GetBuilder<PopularProductController>(
  builder: (products) {
    return products.isLoaded
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.value_20),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: Dimensions.value_15,
                mainAxisSpacing: Dimensions.value_15,
              ),
              itemCount: products.popularProductList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.getPopularFood(index));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.value_15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: Dimensions.listViewImgSize * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.value_15),
                              topRight: Radius.circular(Dimensions.value_15),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(products.popularProductList[index].imageURL),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Dimensions.value_10, top: Dimensions.value_10, right: Dimensions.value_10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BigText(
                                text: products.popularProductList[index].name,
                                size: Dimensions.value_16,
                              ),
                              SizedBox(height: Dimensions.value_10/2),
                              SmallText(
                                text: products.popularProductList[index].ingredients,
                                size: Dimensions.value_15 - 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : const CircularProgressIndicator(
            color: AppColors.mainColor,
          );
  },
)


      ],
    );
  }

  Widget _buildPageItem(int index, Dish productModel) {
    Matrix4 matrix = Matrix4.identity();
    if (index == _currentPage.floor()) {
      double currentScale = 1 - (_currentPage - index) * (1 - _scaleFactor);
      double currentTransformY = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransformY, 0);
    } else if (index == _currentPage.floor() + 1) {
      double currentScale =
          _scaleFactor + (_currentPage - index + 1) * (1 - _scaleFactor);
      double currentTransformY = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransformY, 0);
    } else if (index == _currentPage.floor() - 1) {
      double currentScale = 1 - (_currentPage - index) * (1 - _scaleFactor);
      double currentTransformY = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransformY, 0);
    } else {
      double currentScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }

    return Transform(
      transform: matrix,
      child: GestureDetector(
        onTap: () {
          Get.toNamed(RouteHelper.getPopularFood(index));
        },
        child: Stack(
          children: [
            Container(
              height: Dimensions.pageViewContainer,
              margin: EdgeInsets.only(
                  left: Dimensions.value_10, right: Dimensions.value_10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.value_30),
                  color: index.isEven
                      ? const Color(0xFF69c5df)
                      : const Color(0xFF9294cc),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(productModel.imageURL ?? ''),
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Dimensions.pageViewTextContainer,
                margin: EdgeInsets.only(
                    left: Dimensions.value_30,
                    right: Dimensions.value_30,
                    bottom: Dimensions.value_20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.value_20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFe8e8e8),
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                      BoxShadow(color: Colors.white, offset: Offset(-5, 0)),
                      BoxShadow(color: Colors.white, offset: Offset(-5, 0)),
                    ]),
                child: Container(
                    padding: EdgeInsets.only(
                        top: Dimensions.value_15,
                        left: Dimensions.value_15,
                        right: Dimensions.value_15),
                    child: AppColumn(
                      text: productModel.name!, ingredients: productModel.ingredients!,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
