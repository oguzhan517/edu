import 'package:edu/screens/social_platform_screens/your_questions_screen.dart';
import 'package:flutter/material.dart';
import '../app_drawer.dart';
import '../../screens/social_platform_screens/categories_screen.dart';

class BottomNavigationSocial extends StatefulWidget {
  const BottomNavigationSocial({super.key});
  static const routeName = "/navsocial";

  @override
  State<BottomNavigationSocial> createState() => _BottomNavigationSocialState();
}

class _BottomNavigationSocialState extends State<BottomNavigationSocial> {
  final List<Widget> _pages = [CategoriesScreen(), const YourQuestionsScreen()];
  int index = 0;
  void _selectPage(givenIndex) {
    setState(() {
      index = givenIndex;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Başlangıç sayfası"),
      ),
      body: _pages[index],
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: index,
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.category,
              ),
              label: "Kategoriler",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.question_mark,
                ),
                label: "Sorduğun sorular")
          ]),
      drawer: const AppDrawer(),
    );
  }
}
