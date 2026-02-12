import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:first_task_app/frontend/navigation/index.dart'; // Adjust path


class SupportLevelScreen extends StatefulWidget {
  final int questionid_5;
  const SupportLevelScreen({super.key, required this.questionid_5});

  @override
  State<SupportLevelScreen> createState() => _SupportLevelScreenState();
}

class _SupportLevelScreenState extends State<SupportLevelScreen> {
  double _value = 3;

  // Simplified mapping for the backend
  final List<String> emojis = ["😟", "😔", "😐", "🙂", "🥰"];
  
  // Text descriptions that change based on the slider
  final List<String> descriptions = [
    "I feel quite alone",
    "Support is limited",
    "I have some support",
    "I feel well supported",
    "I have a strong safety net"
  ];

  void _onContinue() {
    // 1. Save the numerical value (1-5) to the controller
    AssessmentController().saveResponse(widget.questionid_5, _value.round());

    // 2. Navigate to Step 6 (Sleep)
    Navigator.pushNamed(context, Routes.m2sleep);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Step 5 of 16',
          style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "How supported do you feel in your personal life?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 60),

            /// Emoji and Dynamic Text Area
            Center(
              child: Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    child: Text(
                      emojis[_value.round() - 1],
                      key: ValueKey<int>(_value.round()),
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    descriptions[_value.round() - 1],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            /// Styled Slider with Custom Thumb
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                activeTrackColor: Colors.black,
                inactiveTrackColor: Colors.grey.shade100,
                thumbColor: Colors.black,
                overlayColor: Colors.black.withOpacity(0.1),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12, elevation: 4),
                trackShape: const RoundedRectSliderTrackShape(),
              ),
              child: Slider(
                value: _value,
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (val) {
                  if (val != _value) {
                    HapticFeedback.selectionClick(); // Adds a premium feel
                    setState(() => _value = val);
                  }
                },
              ),
            ),

            /// Range Labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel("Very\nIsolated"),
                  _buildLabel("Highly\nSupported"),
                ],
              ),
            ),

            const Spacer(),
            _buildContinueButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: const Text(
          "CONTINUE",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade500,
        height: 1.4,
      ),
    );
  }
}