import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu/widgets/social_platform_widgets/new_post.dart';
import 'package:edu/widgets/social_platform_widgets/post.dart';
import 'package:flutter/material.dart';

class CategoryPostScreen extends StatefulWidget {
  const CategoryPostScreen({super.key});
  static const routeName = "/categorypostscreen";

  @override
  State<CategoryPostScreen> createState() => _CategoryPostScreenState();
}

class _CategoryPostScreenState extends State<CategoryPostScreen> {
  final TextEditingController filterController = TextEditingController();
  bool filtered = false;
  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }

  void filter() {
    if (filterController.text.length > 2) {
      setState(() {
        filtered = true;
      });
    } else if (filtered == true) {
      setState(() {
        filtered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: const TextStyle(color: Colors.white),
          controller: filterController,
          decoration: const InputDecoration(
            hintText: 'Soruyu arayın',
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                filtered = false;
              });
            }
          },
        ),
        actions: [
          IconButton(
              onPressed: filter,
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            NewPost(categoryName: categoryName),
            const Divider(),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder(
              stream: filtered == true
                  ? FirebaseFirestore.instance
                      .collection('postCollection')
                      .doc(categoryName)
                      .collection("posts")
                      .where('postText',
                          isGreaterThanOrEqualTo: filterController.text)
                      .where('postText',
                          isLessThan: "${filterController.text}z")
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("postCollection")
                      .doc(categoryName)
                      .collection("posts")
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final categoryPosts = snapshot.data!.docs;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: categoryPosts.length,
                      physics: const ScrollPhysics(),
                      itemBuilder: ((context, index) {
                        return Post(
                            postItem: categoryPosts[index],
                            categoryName: categoryName);
                      }));
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
