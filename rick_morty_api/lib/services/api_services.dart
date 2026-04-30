import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class ApiService {
  final String baseUrl = "https://rickandmortyapi.com/api/character";

  Future<List<Character>> fetchCharacters() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List results = data['results'];

      return results.map((e) => Character.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar personajes: ${response.statusCode}");
    }
  }
}