import 'package:flutter/material.dart';
import 'package:music_app/data/songs_data.dart';
import 'package:music_app/widgets/song_card.dart';

class MusicScreen extends StatelessWidget{
  const MusicScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music App'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return SongCard(song: songs[index]);
        },
      ),
    );
  }

  
}