import 'package:flutter/material.dart';
import '../../widgets/social_platform_widgets/question_filterby_Id.dart';

class YourQuestionsScreen extends StatefulWidget {
  const YourQuestionsScreen({super.key});

  @override
  State<YourQuestionsScreen> createState() => _YourQuestionsScreenState();
}

class _YourQuestionsScreenState extends State<YourQuestionsScreen> {
  String selectedCategory = "Matematik";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = "Matematik";
                        });
                      },
                      child: const Text("Matematik")),
                  OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = "Veri tabanı";
                        });
                      },
                      child: const Text("Veri tabanı")),
                  OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = "İşletim Sistemleri";
                        });
                      },
                      child: const Text("İşletim Sistemleri")),
                  OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = "Algoritma";
                        });
                      },
                      child: const Text("Algoritma")),
                ],
              ),
            ),
          ),
          QuestionFilterbyId(selectedCategory: selectedCategory),
        ],
      ),
    );
  }
}
