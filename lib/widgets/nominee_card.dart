import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/nominee.dart';
import 'audio_player_widget.dart';

class NomineeCard extends StatefulWidget {
  final Nominee nominee;
  const NomineeCard({super.key, required this.nominee});

  @override
  State<NomineeCard> createState() => _NomineeCardState();
}

class _NomineeCardState extends State<NomineeCard> {
  VideoPlayerController? _videoController;
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _initMedia();
  }

  @override
  void didUpdateWidget(covariant NomineeCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si cambia el candidato, reinicia video y audio
    if (widget.nominee.videoPath != oldWidget.nominee.videoPath ||
        widget.nominee.audioPath != oldWidget.nominee.audioPath) {
      _videoController?.pause();
      _videoController?.dispose();
      _audioPlayer?.stop();

      _initMedia();
    }
  }

  void _initMedia() {
    // Video
    if (widget.nominee.videoPath != null) {
      _videoController = VideoPlayerController.asset(widget.nominee.videoPath!)
        ..initialize().then((_) {
          setState(() {});
        });
    } else {
      _videoController = null;
    }

    // Audio - ya no inicializamos AudioPlayer aquí, lo maneja AudioPlayerWidget
  }

  Future<void> _showFullscreenVideo(BuildContext context) async {
    if (widget.nominee.videoPath == null) return;

    final controller = VideoPlayerController.asset(widget.nominee.videoPath!);
    await controller.initialize();
    // Sincroniza la posición pero NO reproducir automáticamente
    if (_videoController != null) {
      await controller.seekTo(_videoController!.value.position);
    }
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(10),
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(controller),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  VideoProgressIndicator(
                    controller,
                    allowScrubbing: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                        onPressed: () {
                          if (controller.value.isPlaying) {
                            controller.pause();
                          } else {
                            controller.play();
                          }
                          (context as Element).markNeedsBuild();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: () {
                          controller.pause();
                          controller.seekTo(Duration.zero);
                          (context as Element).markNeedsBuild();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // Guarda la posición al volver
    if (_videoController != null) {
      await _videoController!.seekTo(controller.value.position);
      if (controller.value.isPlaying) {
        _videoController!.play();
      } else {
        _videoController!.pause();
      }
    }
    await controller.dispose();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasVideo = widget.nominee.videoPath != null;
    final hasAudio = widget.nominee.audioPath != null;
    final isVideoInitialized = _videoController != null && _videoController!.value.isInitialized;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Mostrar video si existe
        if (hasVideo)
          isVideoInitialized
              ? Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                    ),
                    VideoProgressIndicator(
                      _videoController!,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: Colors.red,
                        bufferedColor: Colors.grey,
                        backgroundColor: Colors.black12,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(_videoController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow),
                          onPressed: () {
                            setState(() {
                              _videoController!.value.isPlaying
                                  ? _videoController!.pause()
                                  : _videoController!.play();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.stop),
                          onPressed: () {
                            setState(() {
                              _videoController!.pause();
                              _videoController!.seekTo(Duration.zero);
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.fullscreen),
                          onPressed: () => _showFullscreenVideo(context),
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox(
                  height: 250,
                  child: Center(child: CircularProgressIndicator()),
                )
        // Mostrar audio si existe (y no hay video)
        else if (hasAudio)
          Column(
            children: [
              AudioPlayerWidget(audioAsset: widget.nominee.audioPath!),
              const SizedBox(height: 20),
            ],
          )
        // Si no hay ni video ni audio, mostrar imagen
        else
          Image.asset(widget.nominee.imagePath, height: 400),
        
        const SizedBox(height: 20),
        Text(
          widget.nominee.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}