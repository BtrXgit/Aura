import 'package:flutter/material.dart';

class MusicOverlay extends StatelessWidget {
  final String songName;
  final String artistName;
  final VoidCallback onPlayPause;
  final VoidCallback onSkipForward;
  final VoidCallback onSkipBackward;

  const MusicOverlay({
    required this.songName,
    required this.artistName,
    required this.onPlayPause,
    required this.onSkipForward,
    required this.onSkipBackward,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.black.withOpacity(0.8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  songName,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  artistName,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: onSkipBackward,
                  color: Colors.white,
                ),
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: onPlayPause,
                  color: Colors.white,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: onSkipForward,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
