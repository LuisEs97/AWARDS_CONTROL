import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import '../providers/presentation_provider.dart';
import 'nominee_screen.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  double _volume = 1.0;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePresentationAudio() async {
    if (_isPlaying) {
      await _player.stop();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _player.stop();
      await _player.setVolume(_volume);
      await _player.play(AssetSource('audios/presentacion.mp3'));
      setState(() {
        _isPlaying = true;
      });
      _player.onPlayerComplete.listen((event) {
        setState(() {
          _isPlaying = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  icon: Icon(_isPlaying ? Icons.stop : Icons.music_note),
                  label: Text(_isPlaying ? 'Parar presentación' : 'Reproducir presentación'),
                  onPressed: _togglePresentationAudio,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.volume_up),
                    SizedBox(
                      width: 180,
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
                          await _player.setVolume(_volume);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(categories[index].title),
                  onTap: () {
                    ref.read(presentationProvider.notifier).reset();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NomineeScreen(category: categories[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
