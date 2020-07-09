import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final YoutubePlayerController controller;
  VideoPlayer({Key key, @required this.controller}) : super(key: key);
  @override
  _VideoPlayerState createState() => _VideoPlayerState(controller);
}

class _VideoPlayerState extends State<VideoPlayer> {
  final YoutubePlayerController controller;
  _VideoPlayerState(this.controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: YoutubePlayer(
          controller: controller,
        ),
      ),
    );
  }
}
