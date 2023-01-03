class UserModel {
  String id;
  String email;
  String imageDownloadUrl;
  String description;
  String name;
  bool isStudent;

  UserModel(
      {required this.id,
      required this.email,
      required this.imageDownloadUrl,
      this.description = "",
      required this.name,
      required this.isStudent});
}
