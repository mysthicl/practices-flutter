import 'dart:convert';

import 'package:consumo_api/models/post.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> getPosts() async {
    final response = await http.get(
      Uri.parse("$baseUrl/posts"),
      //headers: {"Content-Type": "application/json", "User-Agent": "FlutterApp"},
      );

      if(response.statusCode == 200){
        List data = json.decode(response.body);
        return data.map((json)=> Post.fromJson(json)).toList();
      }else{
        throw Exception("Error al cargar posts");
      }
  }
}