class Post {
  // Atributos
  final int id;
  final String title;
  final String body;

  // constructor
  Post({
    required this.id,
    required this.title,
    required this.body
  });

  // Metodo para convertir un JSON a obj Post
  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      id: json["id"],
      title: json["title"],
      body: json["body"]
    );
  }
}