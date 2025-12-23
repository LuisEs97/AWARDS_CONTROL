import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioAsset;
  const AudioPlayerWidget({super.key, required this.audioAsset});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _player;
  double _volume = 1.0;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      await _player.setAsset(widget.audioAsset);
      await _player.setVolume(_volume);
      
      // Esperar a que se cargue la duración
      await _player.load();
      
      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      print("Error initializing audio: $e");
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isInitializing)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          )
        else
          StreamBuilder<PlayerState>(
            stream: _player.playerStateStream,
            builder: (context, snapshot) {
              final playing = snapshot.data?.playing ?? false;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                    iconSize: 40,
                    onPressed: () {
                      if (playing) {
                        _player.pause();
                      } else {
                        _player.play();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    iconSize: 40,
                    onPressed: () {
                      _player.stop();
                    },
                  ),
                ],
              );
            },
          ),
        
        if (!_isInitializing)
          StreamBuilder<Duration?>(
            stream: _player.durationStream,
            builder: (context, snapshot) {
              final duration = snapshot.data ?? Duration.zero;
              return StreamBuilder<Duration>(
                stream: _player.positionStream,
                builder: (context, posSnapshot) {
                  final position = posSnapshot.data ?? Duration.zero;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ProgressBar(
                      progress: position,
                      total: duration,
                      onSeek: (d) => _player.seek(d),
                    ),
                  );
                },
              );
            },
          ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.volume_up),
            SizedBox(
              width: 120,
              child: Slider(
                value: _volume,
                min: 0.0,
                max: 1.0,
                divisions: 20,
                label: (_volume * 100).toInt().toString(),
                onChanged: (v) {
                  setState(() {
                    _volume = v;
                  });
                  _player.setVolume(_volume);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}