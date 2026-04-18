import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';

class SongCard extends StatefulWidget{
  final Song song;
  const SongCard({super.key, required this.song});

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;

  void togglePlay() async{
    if(isPlaying){
      await player.stop();
      setState(() {
        isPlaying = false;
      });
    }else{
      await player.play(
        AssetSource(widget.song.audio.replaceFirst("assets/", ""))
      );
      setState(() {
        isPlaying = true;
      });
    }
  }
   @override
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                widget.song.image,
                width: 70,
                height: 70,
                fit: BoxFit.cover, 
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.song.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 5,),
                  Text('Duracion: ${widget.song.duration}', style:  TextStyle(color: Colors.grey[600]),),
                ],
              ),
            ),
            IconButton(
              onPressed: togglePlay, 
              icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle, size: 35, color: Colors.green),
            )
          ],
        ),
      ),
    );
  }
}