import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../services/personal/assesment_service.dart'; // Ensure this path is correct

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({Key? key}) : super(key: key);

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  int _completedSteps = 0;
  double _progressValue = 0.0;
  late Timer _sequenceTimer;

  // State flags for synchronization
  bool _isDataSubmitted = false;
  bool _hasError = false;
  bool _animationFinished = false;

  final List<String> _statuses = [
    "Analyzing your patterns...",
    "Personalizing your goals...",
    "Curating mindfulness tools...",
    "Finalizing your sanctuary...",
  ];

  @override
  void initState() {
    super.initState();
    _startFlow();
  }

  void _startFlow() {
    _startAnimation();
    _submitData();
  }

  /// Communicates with AssessmentService to sync with PostgreSQL
  Future<void> _submitData() async {
    try {
      final service = AssessmentService();
      bool success = await service.submitAssessment();

      if (mounted) {
        if (success) {
          setState(() => _isDataSubmitted = true);
          _attemptNavigation();
        } else {
          _handleFailure();
        }
      }
    } catch (e) {
      if (mounted) _handleFailure();
    }
  }

  void _handleFailure() {
    setState(() => _hasError = true);
    _sequenceTimer.cancel();
    HapticFeedback.vibrate(); // Physical feedback for error
  }

  void _startAnimation() {
    const totalDuration = Duration(seconds: 6);
    const refreshRate = Duration(milliseconds: 50);
    int steps = totalDuration.inMilliseconds ~/ refreshRate.inMilliseconds;
    double increment = 1.0 / steps;

    _sequenceTimer = Timer.periodic(refreshRate, (timer) {
      if (!mounted) return;
      setState(() {
        if (_progressValue < 1.0) {
          _progressValue += increment;

          int newStepIndex = (_progressValue * _statuses.length).floor();
          if (newStepIndex > _completedSteps &&
              newStepIndex < _statuses.length) {
            _completedSteps = newStepIndex;
          }
        } else {
          _sequenceTimer.cancel();
          _animationFinished = true;
          _attemptNavigation();
        }
      });
    });
  }

  /// Only navigates if API call is done AND animation reached 100%
  void _attemptNavigation() {
    if (_isDataSubmitted && _animationFinished) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      });
    }
  }

  @override
  void dispose() {
    _sequenceTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) return _buildErrorUI();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                'Creating Your\nPersonal Sanctuary',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 40),

              // Visual asset placeholder
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: // Replace the empty Image.asset with:
                  Image.asset(
                    'assets/images/processing_sanctuary.png', // Ensure this is in pubspec.yaml
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.auto_awesome,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Status Checklist
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _statuses.length,
                  (index) => _buildStepRow(index),
                ),
              ),

              const Spacer(),

              _buildProgressBar(),
              const SizedBox(height: 16),

              // Feedback text for the data sync
              Text(
                _isDataSubmitted
                    ? "Insights Synchronized"
                    : "Securing your responses...",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Stack(
      children: [
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 8,
          width:
              MediaQuery.of(context).size.width *
              _progressValue.clamp(0.0, 1.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget _buildStepRow(int index) {
    bool isCompleted = index < _completedSteps;
    bool isCurrent = index == _completedSteps;
    double opacity = (isCompleted || isCurrent) ? 1.0 : 0.3;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: opacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.black : Colors.grey.shade300,
              size: 20,
            ),
            const SizedBox(width: 16),
            Text(
              _statuses[index],
              style: TextStyle(
                fontSize: 16,
                fontWeight: isCompleted || isCurrent
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: isCompleted || isCurrent
                    ? Colors.black
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorUI() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 20),
              const Text(
                "Upload Failed",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "We couldn't save your assessment. Please check your connection.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("TRY AGAIN"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
