import 'package:consumo_api/models/post.dart';
import 'package:consumo_api/services/api_service.dart';
import 'package:consumo_api/widgets/post_card.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget{
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Future<List<Post>> futurePosts;

  @override
  void initState(){
    super.initState();

    futurePosts = ApiService().getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Posts"),
      ),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          // Loading
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // Error
          if(snapshot.hasError){
            return const Center(
              child: Text("Error al cargar los datos"),
            );
          }
          // Data
          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index){
              return PostCard(post: posts[index]);
            },
          );
        },
      ),
    );
  }
}