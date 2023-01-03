import 'package:edu/helpers/auth_helper.dart';
import 'package:edu/screens/authentication_screen.dart';
import 'package:edu/screens/edit_infos_screen.dart';
import 'package:edu/widgets/chat_widgets/bottom_navigation.dart';
import 'package:edu/widgets/social_platform_widgets/bottom_navigation_social.dart';
import 'package:flutter/material.dart';



class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppBar(
              title: const Text("Menu"),
            ),
            ListTile(
                leading: const Icon(Icons.offline_bolt),
                title: const Text("Çıkış yap"),
                onTap: (() {
                  AuthHelper().signout();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const AuthenticationScreen(),
                  ));
                })),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Sosyal platform"),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(BottomNavigationSocial.routeName);
              },
            ),
            ListTile(
                leading: const Icon(Icons.chat_bubble),
                title: const Text("Kişiler ve mesajlaşma"),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(BottomNavigation.routeName);
                }),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: const Text("Hesap ve Düzenleme"),
              onTap: () {
                Navigator.of(context).pushNamed(EditInfosScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
