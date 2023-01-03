import 'package:edu/screens/social_platform_screens/category_posts_screen.dart';
import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  const Category(
      {super.key, required this.categoryName, required this.assetName});
  final String categoryName;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed(CategoryPostScreen.routeName, arguments: categoryName);
      },
      child: Stack(
        children: [
          Image.asset(
            assetName,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 20,
            child: Container(
              color: Theme.of(context).primaryColorDark,
              child: Text(
                categoryName,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
