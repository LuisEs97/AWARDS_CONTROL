import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/presentation_provider.dart';
import 'package:audioplayers/audioplayers.dart';


typedef RevealWinnerCallback = void Function();

class ControlButtons extends ConsumerStatefulWidget {
  final int total;
  final RevealWinnerCallback? onRevealWinner;
  const ControlButtons({super.key, required this.total, this.onRevealWinner});

  @override
  ConsumerState<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends ConsumerState<ControlButtons> {
  final AudioPlayer _redoblePlayer = AudioPlayer();
  bool _isRedoblePlaying = false;
  double _redobleVolume = 1.0;

  @override
  void dispose() {
    _redoblePlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleRedobleAudio() async {
    if (_isRedoblePlaying) {
      await _redoblePlayer.stop();
      setState(() {
        _isRedoblePlaying = false;
      });
    } else {
      await _redoblePlayer.stop();
      await _redoblePlayer.setVolume(_redobleVolume);
      await _redoblePlayer.play(AssetSource('audios/redoble.mp3'));
      setState(() {
        _isRedoblePlaying = true;
      });
      _redoblePlayer.onPlayerComplete.listen((event) {
        setState(() {
          _isRedoblePlaying = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(presentationProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: index > 0
                ? () =>
                      ref.read(presentationProvider.notifier).previousNominee()
                : null,
            child: const Text('Candidato anterior'),
          ),
          ElevatedButton(
            onPressed: index < widget.total - 1
                ? () =>
                      ref.read(presentationProvider.notifier).nextNominee(widget.total)
                : null,
            child: const Text('Siguiente candidato'),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: widget.onRevealWinner,
                child: const Text('Revelar ganador'),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  IconButton(
                    icon: Icon(_isRedoblePlaying ? Icons.stop : Icons.music_note, color: Colors.amber),
                    tooltip: _isRedoblePlaying ? 'Parar redoble' : 'Reproducir redoble',
                    onPressed: _toggleRedobleAudio,
                  ),
                  SizedBox(
                    width: 100,
                    child: Slider(
                      value: _redobleVolume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 20,
                      label: (_redobleVolume * 100).toInt().toString(),
                      onChanged: (v) async {
                        setState(() {
                          _redobleVolume = v;
                        });
                        await _redoblePlayer.setVolume(_redobleVolume);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
