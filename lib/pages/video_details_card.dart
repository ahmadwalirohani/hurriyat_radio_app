import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetailsCard extends StatefulWidget {
  final String? videoUrl;
  final String title;
  final String info;
  final String host;

  const VideoDetailsCard({
    Key? key,
    required this.videoUrl,
    required this.title,
    required this.info,
    required this.host,
  }) : super(key: key);

  @override
  _VideoDetailsCardState createState() => _VideoDetailsCardState();
}

class _VideoDetailsCardState extends State<VideoDetailsCard> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl ?? '')!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Align video player slightly above the center
          Align(
            alignment: Alignment(0, -0.2), // Slightly above center (Y = -0.2)
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () {
                print('Video is ready!');
              },
            ),
          ),

          // Overlay Title and Info at the bottom of the screen
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.host,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Html(
                    data: widget.info, // Pass the HTML content here
                    style: {
                      "body": Style(
                        color: Colors
                            .white70, // Set the text color for HTML content
                        fontSize: FontSize(14),
                      ),
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
