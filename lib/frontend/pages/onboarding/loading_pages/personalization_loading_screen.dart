import 'dart:async';
import 'package:flutter/material.dart';
import '../../../navigation/index.dart';

class LoadingSequenceScreen extends StatefulWidget {
  const LoadingSequenceScreen({super.key});

  @override
  State<LoadingSequenceScreen> createState() => _LoadingSequenceScreenState();
}

class _LoadingSequenceScreenState extends State<LoadingSequenceScreen> {
  int _currentIndex = 0;
  late Timer _timer;

  final List<String> _subtitles = [
    "Personalizing your experience...",
    "Setting up your wellbeing journey...",
    "Preparing insights based on your goals...",
    "Finalizing your dashboard...",
  ];

  @override
  void initState() {
    super.initState();
    _startLoadingSequence();
  }

  void _startLoadingSequence() {
    // Cycle through steps
    _timer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (_currentIndex < _subtitles.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        _timer.cancel();
        _navigateToAssessment();
      }
    });
  }

  void _navigateToAssessment() {
    // pushReplacementNamed ensures the user can't "back" into the loading screen
    Navigator.pushReplacementNamed(context, Routes.assessment);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Sleek Icon or Logo placeholder
            const Icon(Icons.auto_awesome, size: 48, color: Colors.black),
            const SizedBox(height: 32),
            
            // 2. Main Title
            const Text(
              'Crafting your space',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),

            // 3. Subtitle with Cross-Fade
            SizedBox(
              height: 40, // Fixed height prevents layout jumps
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  _subtitles[_currentIndex],
                  key: ValueKey(_currentIndex),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 4. Enhanced Progress Bar
            _buildProgressBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      width: 200,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            width: 200 * ((_currentIndex + 1) / _subtitles.length),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}