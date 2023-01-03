import 'package:edu/screens/chat_screens/persons_screen.dart';
import 'package:edu/screens/edit_infos_screen.dart';
import 'package:edu/screens/social_platform_screens/categories_screen.dart';
import 'package:edu/screens/social_platform_screens/category_posts_screen.dart';
import 'package:edu/widgets/social_platform_widgets/bottom_navigation_social.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'widgets/chat_widgets/bottom_navigation.dart';
import 'screens/chat_screens/message_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.orange,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (userSnapshot.hasData) {
                return const BottomNavigation();
              }
              return const AuthenticationScreen();
            }),
        routes: {
          MessageScreen.routeName: (context) => const MessageScreen(),
          CategoriesScreen.routeName: (context) => CategoriesScreen(),
          PersonsScreen.routeName: (context) => const PersonsScreen(),
          CategoryPostScreen.routeName: (context) => const CategoryPostScreen(),
          BottomNavigation.routeName: (context) => const BottomNavigation(),
          EditInfosScreen.routeName: (context) => const EditInfosScreen(),
          BottomNavigationSocial.routeName: (context) =>
              const BottomNavigationSocial()
        });
  }
}
