import 'package:flutter/material.dart';

class WinnerEpicWidget extends StatefulWidget {
  final VoidCallback? onBack;
  const WinnerEpicWidget({super.key, this.onBack});

  @override
  State<WinnerEpicWidget> createState() => _WinnerEpicWidgetState();
}

class _WinnerEpicWidgetState extends State<WinnerEpicWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _scaleAnim,
            builder: (context, child) => Transform.scale(
              scale: _scaleAnim.value,
              child: child,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¡GANADOR!',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(blurRadius: 20, color: Colors.amber, offset: Offset(0, 0)),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 16),
                    borderRadius: BorderRadius.circular(48),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.5),
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.asset(
                      'assets/images/default.jpg',
                      height: 500,
                      width: 500,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 40,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 60),
              onPressed: widget.onBack,
            ),
          ),
        ],
      ),
    );
  }
}
