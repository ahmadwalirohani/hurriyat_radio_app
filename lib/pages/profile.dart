import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:just_audio/just_audio.dart';
import 'package:siri_wave/siri_wave.dart';

class LiveRadio extends StatefulWidget {
  const LiveRadio({Key? key}) : super(key: key);

  @override
  _LiveRadioState createState() => _LiveRadioState();
}

class _LiveRadioState extends State<LiveRadio>
    with AutomaticKeepAliveClientMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    // Set the audio stream URL
    await _audioPlayer.setUrl('https://support.aryanict.com/8006/stream');
    _audioPlayer.play();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      setState(() {
        _isPlaying = !_isPlaying;
      });
      await _audioPlayer.pause();
    } else {
      setState(() {
        _isPlaying = !_isPlaying;
      });
      await _audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final controller = IOS7SiriWaveformController(
      amplitude: 0.5,
      color: const Color.fromARGB(255, 29, 172, 255),
      frequency: 4,
      speed: 0.15,
    );

    // Get the screen width for image sizing
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('live radio').tr(),
        centerTitle: false,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min, // Minimize space taken by Column
        children: [
          // SiriWaveform at the top
          Container(
            width: double.infinity, // Ensures it takes full width
            child: SiriWaveform.ios7(
              controller: controller,
              options: const IOS7SiriWaveformOptions(
                  height: 250, width: double.infinity),
            ),
          ),

          // Image below the waveform, width set to screen width
          Padding(
            padding:
                const EdgeInsets.only(top: 0.0), // Small space above the image
            child: Image.asset(
              'assets/images/radio-waves.png', // Replace with your image path
              width: screenWidth, // Image width fixed to screen width
              height: 280, // Adjust height as needed
              fit: BoxFit.cover, // Ensures the image is not distorted
            ),
          ),

          // Play/Pause Button close to the image
          Padding(
            padding: const EdgeInsets.only(top: 12.0), // Reduced padding
            child: ElevatedButton(
              onPressed: _togglePlayPause,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(18.0), // Button size padding
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
