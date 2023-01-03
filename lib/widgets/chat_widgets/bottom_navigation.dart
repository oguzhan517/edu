import 'package:edu/screens/chat_screens/last_messages_screen.dart';
import 'package:edu/screens/chat_screens/persons_screen.dart';
import 'package:flutter/material.dart';
import '../app_drawer.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});
  static const routeName = "/bottomnav";

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final List<Widget> _pages = const [LastMessagesScreen(), PersonsScreen()];
  int index = 1;
  void _selectPage(givenIndex) {
    setState(() {
      index = givenIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(index == 1 ? "Kişiler" : "Son Mesajlar"),
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
                Icons.chat,
              ),
              label: "Son Mesajlar",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.question_answer_outlined,
                ),
                label: "Kişiler")
          ]),
      drawer: const AppDrawer(),
    );
  }
}
