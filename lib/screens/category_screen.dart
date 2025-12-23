import 'package:awards_presentation/models/category.dart';
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
  
  // VARIABLE PARA CONTROLAR LA ALTURA DEL OVERLAY
  double _overlayHeight = 0;

  @override
  void initState() {
    super.initState();
    // Inicializar overlay cubriendo toda la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _overlayHeight = MediaQuery.of(context).size.height;
        });
      }
    });
  }

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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // PANTALLA PRINCIPAL (contenido real)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
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
              child: _buildMainContent(categories),
            ),
          ),
          
          // OVERLAY DESLIZABLE (imagen que se mueve)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: _overlayHeight,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                // Actualizar altura según el deslizamiento
                setState(() {
                  _overlayHeight -= details.delta.dy;
                  // Limitar valores
                  if (_overlayHeight < 0) _overlayHeight = 0;
                  if (_overlayHeight > screenHeight) {
                    _overlayHeight = screenHeight;
                  }
                });
              },
              onVerticalDragEnd: (details) {
                // Ajustar a posiciones al soltar
                if (_overlayHeight > screenHeight * 0.5) {
                  // Volver a cubrir toda la pantalla
                  setState(() {
                    _overlayHeight = screenHeight;
                  });
                } else {
                  // Ocultar completamente
                  setState(() {
                    _overlayHeight = 0;
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _overlayHeight,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/portada.jpg'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // CONTENIDO DE LA PORTADA
                    if (_overlayHeight > screenHeight * 0.8)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // TÍTULO
                              const Column(
                                children: [
                                  Text(
                                    'AWARDS 2025',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 3,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 20,
                                          color: Colors.black,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Presentación de Premios',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 26,
                                      fontStyle: FontStyle.italic,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10,
                                          color: Colors.black,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 60),
                              
                              // BOTÓN PARA REPRODUCIR PRESENTACIÓN
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: Colors.amber, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.amber.withOpacity(0.4),
                                      blurRadius: 15,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  icon: Icon(
                                    _isPlaying ? Icons.stop : Icons.play_arrow,
                                    color: Colors.amber,
                                    size: 34,
                                  ),
                                  label: Text(
                                    _isPlaying ? 'PARAR PRESENTACIÓN' : 'REPRODUCIR PRESENTACIÓN',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  onPressed: _togglePresentationAudio,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // CONTROL DE VOLUMEN EN PORTADA
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.volume_up,
                                      color: Colors.amber,
                                      size: 30,
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: 200,
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
                                            activeColor: Colors.amber,
                                            inactiveColor: Colors.grey[700],
                                            thumbColor: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Volumen: ${(_volume * 100).toInt()}%',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 40),
                              
                              // BOTÓN PARA ENTRAR
                              ElevatedButton.icon(
                                icon: const Icon(Icons.arrow_downward),
                                label: const Text('ENTRAR A LAS CATEGORÍAS'),
                                onPressed: () {
                                  setState(() {
                                    _overlayHeight = 0;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 18,
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // INSTRUCCIÓN ADICIONAL
                              const Text(
                                'También puedes deslizar hacia abajo',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(List<Category> categories) {
    return Column(
      children: [
        // AppBar personalizado
        Container(
          height: kToolbarHeight + 20,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            border: Border(
              bottom: BorderSide(
                color: Colors.amber.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón para volver a mostrar la portada
                IconButton(
                  icon: const Icon(Icons.arrow_upward, color: Colors.amber),
                  onPressed: () {
                    setState(() {
                      _overlayHeight = MediaQuery.of(context).size.height;
                    });
                  },
                  tooltip: 'Volver a portada',
                ),
                
                const Text(
                  'CATEGORÍAS',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                // Botón para reproducir presentación en la vista principal
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.stop : Icons.music_note,
                    color: Colors.amber,
                  ),
                  onPressed: _togglePresentationAudio,
                  tooltip: 'Reproducir presentación',
                ),
              ],
            ),
          ),
        ),
        
        // Contenido de audio en vista principal
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
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
    );
  }
}