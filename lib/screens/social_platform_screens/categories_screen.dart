import 'package:edu/models/category_model.dart';
import 'package:flutter/material.dart';
import '../../widgets/social_platform_widgets/category.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});
  static const routeName = "/CategoriesScreen";

  final List<CategoryModel> categories = [
    CategoryModel(
        id: "1",
        categoryName: "Matematik",
        assetName: "assets/images/math.jpg"),
    CategoryModel(
        id: "2",
        categoryName: "Veri tabanı",
        assetName: "assets/images/database.png"),
    CategoryModel(
        id: "3",
        categoryName: "İşletim Sistemleri",
        assetName: "assets/images/operating_systems.png"),
    CategoryModel(
        id: "4",
        categoryName: "Algoritma",
        assetName: "assets/images/algorithms.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          mainAxisExtent: 200,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 30),
      children: categories
          .map((e) => Category(
                assetName: e.assetName,
                categoryName: e.categoryName,
              ))
          .toList(),
    );
  }
}
