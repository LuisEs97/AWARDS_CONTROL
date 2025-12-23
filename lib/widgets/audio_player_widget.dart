import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/services.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioAsset;
  const AudioPlayerWidget({super.key, required this.audioAsset});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _player;
  double _volume = 1.0;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isLoading = true;
  String? _errorMessage;
  String? _currentAudioAsset;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer(playerId: 'audio_player_${widget.audioAsset.hashCode}');
    _currentAudioAsset = widget.audioAsset;
    _initializeAudio();
    _setupListeners();
  }

  @override
  void didUpdateWidget(covariant AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Verificar si el audio ha cambiado
    if (widget.audioAsset != oldWidget.audioAsset) {
      _handleAudioChange();
    }
  }

  Future<void> _handleAudioChange() async {
    // Guardar volumen actual
    final currentVolume = _volume;
    
    // Detener audio actual
    await _player.stop();
    
    // Resetear estado
    setState(() {
      _isPlaying = false;
      _position = Duration.zero;
      _duration = Duration.zero;
      _isLoading = true;
      _errorMessage = null;
      _currentAudioAsset = widget.audioAsset;
    });
    
    // Reinicializar con nuevo audio
    await _initializeAudio();
    
    // Restaurar volumen
    await _player.setVolume(currentVolume);
  }

  Future<void> _initializeAudio() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Para Flutter web, necesitamos manejar diferentes codecs
      final isWeb = identical(0, 0.0); // Hack para detectar si es web
      
      if (widget.audioAsset.toLowerCase().endsWith('.opus')) {
        // Para archivos .opus en web
        if (isWeb) {
          // En web, intentamos cargarlo como un blob
          final bytes = await _loadAssetBytes(widget.audioAsset);
          if (bytes != null) {
            await _player.setSourceBytes(bytes);
          } else {
            throw Exception('No se pudo cargar el archivo .opus');
          }
        } else {
          // En móvil/nativo, usar AssetSource normal
          await _player.setSource(AssetSource(widget.audioAsset));
        }
      } else {
        // Para otros formatos (mp3, etc.)
        await _player.setSource(AssetSource(widget.audioAsset));
      }
      
      // Obtener la duración
      await Future.delayed(Duration(milliseconds: 300)); // Dar tiempo para cargar
      final duration = await _player.getDuration();
      
      if (duration != null && duration.inSeconds > 0) {
        setState(() {
          _duration = duration;
          _isLoading = false;
        });
      } else {
        // Reintentar si no se obtuvo la duración
        await Future.delayed(Duration(milliseconds: 500));
        final duration2 = await _player.getDuration();
        
        setState(() {
          _duration = duration2 ?? Duration.zero;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print("Error initializing audio: $e");
      print("Stack trace: $stackTrace");
      
      // Intentar una alternativa para web
      try {
        await _tryAlternativeLoading();
      } catch (e2) {
        setState(() {
          _errorMessage = 'Formato no compatible: ${widget.audioAsset}\nRecomendado: usar .mp3';
          _isLoading = false;
        });
      }
    }
  }

  Future<Uint8List?> _loadAssetBytes(String path) async {
    try {
      // Remover 'assets/' del path si está presente
      String assetPath = path;
      if (path.startsWith('assets/')) {
        assetPath = path.substring(7); // Remover 'assets/'
      }
      
      final byteData = await rootBundle.load(assetPath);
      return byteData.buffer.asUint8List();
    } catch (e) {
      print("Error loading asset bytes: $e");
      return null;
    }
  }

  Future<void> _tryAlternativeLoading() async {
    // Intentar cargar como URL para web
    final url = 'assets/${widget.audioAsset.replaceFirst('assets/', '')}';
    await _player.setSourceUrl(url);
    
    final duration = await _player.getDuration();
    setState(() {
      _duration = duration ?? Duration.zero;
      _isLoading = false;
    });
  }

  void _setupListeners() {
    _player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _player.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _player.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _player.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  Future<void> _togglePlay() async {
    try {
      if (_isPlaying) {
        await _player.pause();
      } else {
        // Si estamos al final, volver al inicio
        if (_position >= _duration) {
          await _player.seek(Duration.zero);
        }
        await _player.resume();
      }
    } catch (e) {
      print("Error toggling play: $e");
      setState(() {
        _errorMessage = 'Error al reproducir: ${e.toString()}';
      });
    }
  }

  Future<void> _stop() async {
    try {
      await _player.stop();
      if (mounted) {
        setState(() {
          _position = Duration.zero;
          _isPlaying = false;
        });
      }
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  Future<void> _seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      print("Error seeking: $e");
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
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.amber),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    _initializeAudio(); // Reintentar
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Cargando audio...', style: TextStyle(fontSize: 12)),
              ],
            ),
          )
        else if (_duration.inSeconds == 0 && _errorMessage == null)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Audio no disponible (formato no compatible)',
              style: TextStyle(color: Colors.red),
            ),
          )
        else
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 40,
                    onPressed: _togglePlay,
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    iconSize: 40,
                    onPressed: _stop,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ProgressBar(
                  progress: _position,
                  total: _duration,
                  onSeek: _seek,
                ),
              ),
            ],
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
                onChanged: (v) async {
                  setState(() {
                    _volume = v;
                  });
                  try {
                    await _player.setVolume(_volume);
                  } catch (e) {
                    print("Error setting volume: $e");
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}