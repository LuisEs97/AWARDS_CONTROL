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
          : Column(
              children: [
                Expanded(child: NomineeCard(nominee: nominee)),
                ControlButtons(
                  total: widget.category.nominees.length,
                  onRevealWinner: revealWinner,
                ),
              ],
            ),
    );
  }
}
