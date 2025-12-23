import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../providers/presentation_provider.dart';
import '../widgets/nominee_card.dart';
import '../widgets/control_buttons.dart';
import '../widgets/winner_epic_widget.dart';

class NomineeScreen extends ConsumerStatefulWidget {
  final Category category;
  const NomineeScreen({super.key, required this.category});

  @override
  ConsumerState<NomineeScreen> createState() => _NomineeScreenState();
}

class _NomineeScreenState extends ConsumerState<NomineeScreen> {
  bool showWinner = false;

  void revealWinner() {
    setState(() {
      showWinner = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(presentationProvider);
    final safeIndex = index.clamp(0, widget.category.nominees.length - 1);
    final nominee = widget.category.nominees[safeIndex];

    return Scaffold(
      body: showWinner
          ? WinnerEpicWidget(onBack: () => setState(() => showWinner = false))
          : Stack(
              children: [
                // CONTENIDO PRINCIPAL
                Column(
                  children: [
                    // TÍTULO DE LA SECCIÓN (espacio reservado)
                    Container(
                      height: 70, // Misma altura que el título flotante
                      color: Colors.transparent,
                    ),
                    
                    // CONTENIDO DEL CANDIDATO
                    Expanded(
                      child: NomineeCard(nominee: nominee),
                    ),
                    
                    // BOTONES DE CONTROL
                    ControlButtons(
                      total: widget.category.nominees.length,
                      onRevealWinner: revealWinner,
                    ),
                  ],
                ),
                
                // TÍTULO FLOTANTE DE LA SECCIÓN
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Row(
                        children: [
                          // Botón para volver
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.amber),
                            onPressed: () => Navigator.pop(context),
                            tooltip: 'Volver a categorías',
                          ),
                          
                          const SizedBox(width: 10),
                          
                          // TÍTULO DE LA SECCIÓN
                          Expanded(
                            child: Text(
                              widget.category.title.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10,
                                    color: Colors.black,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          
                          // CONTADOR DE CANDIDATOS
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              '${safeIndex + 1}/${widget.category.nominees.length}',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
}