import 'package:flutter/material.dart';
import 'package:rick_morty_api/services/api_services.dart';
import '../models/character.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  HomeScreen({super.key});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.greenAccent;
      case 'dead':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Rick ',
                style: TextStyle(
                  color: Color(0xFF00FF9C),
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              TextSpan(
                text: '& Morty',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Character>>(
        future: apiService.fetchCharacters(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final characters = snapshot.data!;

            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(character: character),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C2D3F),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00FF9C).withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Imagen con overlay de gradiente
                          Expanded(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  character.image,
                                  fit: BoxFit.cover,
                                ),
                                // Gradiente inferior sobre la imagen
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          const Color(0xFF1C2D3F),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Info del personaje
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  character.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(character.status),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: _getStatusColor(character.status)
                                                .withOpacity(0.6),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        '${character.status} · ${character.species}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.55),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off_rounded, color: Colors.redAccent, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Oops, algo salió mal',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(
              color: const Color(0xFF00FF9C),
              strokeWidth: 2.5,
            ),
          );
        },
      ),
    );
  }
}