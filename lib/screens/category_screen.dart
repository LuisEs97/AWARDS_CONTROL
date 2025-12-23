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
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: Colors.transparent, // AppBar transparente
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Iconos blancos
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      extendBodyBehindAppBar: true, // Para que el fondo esté detrás del AppBar
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // Overlay oscuro para mejorar la legibilidad del contenido
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            children: [
              // Espacio para el AppBar
              const SizedBox(height: kToolbarHeight + 20),
              
              // Contenido de audio
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    // Botón de presentación con estilo mejorado
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.amber, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        icon: Icon(
                          _isPlaying ? Icons.stop : Icons.music_note,
                          color: Colors.amber,
                          size: 28,
                        ),
                        label: Text(
                          _isPlaying ? 'PARAR PRESENTACIÓN' : 'REPRODUCIR PRESENTACIÓN',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: _togglePresentationAudio,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Control de volumen con estilo mejorado
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.volume_up, color: Colors.amber, size: 28),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 180,
                            child: Column(
                              children: [
                                Slider(
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
                                  activeColor: Colors.amber,
                                  inactiveColor: Colors.grey[700],
                                  thumbColor: Colors.white,
                                ),
                                Text(
                                  'Volumen: ${(_volume * 100).toInt()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Lista de categorías
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (_, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.grey[900]!.withOpacity(0.8),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            title: Text(
                              categories[index].title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 0.5,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.5),
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                            onTap: () {
                              ref.read(presentationProvider.notifier).reset();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NomineeScreen(category: categories[index]),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              // Espacio inferior
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}