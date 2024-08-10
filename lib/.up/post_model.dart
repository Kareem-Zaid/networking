class Post {
  int id, userId;
  String title, body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }

  // INVALID SUBSTITUTE for 'Post.fromJson'
  // Map<String, dynamic> json2 = {};
  // Post fromJson = Post(
  //   id: json2['id'],
  //   userId: json2['userId'],
  //   title: json2['title'],
  //   body: json2['body'],
  // );
}

// VALID SUBSTITUTE for 'Post.fromJson'
// Map json = {};
// Post post = Post(
//   id: json['id'],
//   userId: json['userId'],
//   title: json['title'],
//   body: json['body'],
// );

// class KSZ {
//   late String shaaban;
//   KSZ({required this.shaaban});
//   KSZ.zaid();
// }