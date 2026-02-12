import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_task_app/frontend/navigation/index.dart'; // Adjust path


class LearningPreferenceScreen extends StatefulWidget {
  final int questionid_12;
  const LearningPreferenceScreen({super.key, required this.questionid_12});

  @override
  State<LearningPreferenceScreen> createState() => _LearningPreferenceScreenState();
}

class _LearningPreferenceScreenState extends State<LearningPreferenceScreen> {
  double sliderValue = 1.0; // Using 0, 1, 2 for 3 distinct steps

  final List<Map<String, String>> preferences = [
    {
      "title": "Guided Path",
      "desc": "I want a step-by-step daily plan\ntailored for me.",
      "icon": "🎯"
    },
    {
      "title": "Balanced Mix",
      "desc": "I like a mix of guidance and\npersonal freedom.",
      "icon": "⚖️"
    },
    {
      "title": "Self-Directed",
      "desc": "I prefer to browse and choose\ntools at my own pace.",
      "icon": "🧭"
    },
  ];

  void _onContinue() {
    AssessmentController().saveResponse(widget.questionid_12, {
      "preference_index": sliderValue.toInt(),
      "label": preferences[sliderValue.toInt()]['title'],
    });
    
    // Navigate to Step 13
    Navigator.pushNamed(context, Routes.m4weekly);
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = sliderValue.toInt();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "How do you prefer to\nexplore wellbeing?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26, 
                fontWeight: FontWeight.bold, 
                height: 1.2,
                color: Color(0xFF1A1A1A)
              ),
            ),
            const SizedBox(height: 60),
            
            // Preference Display Card
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey<int>(currentIndex),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  children: [
                    Text(preferences[currentIndex]['icon']!, style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 16),
                    Text(
                      preferences[currentIndex]['title']!,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      preferences[currentIndex]['desc']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 60),
            
            // Enhanced Slider
            _buildSliderLayout(),
            
            const Spacer(),
            _buildContinueButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderLayout() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.grey.shade200,
            thumbColor: Colors.black,
            overlayColor: Colors.black.withOpacity(0.1),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 4),
            activeTickMarkColor: Colors.black,
            inactiveTickMarkColor: Colors.grey.shade400,
          ),
          child: Slider(
            value: sliderValue,
            min: 0,
            max: 2,
            divisions: 2,
            onChanged: (v) {
              if (v != sliderValue) {
                HapticFeedback.selectionClick();
                setState(() => sliderValue = v);
              }
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Structured", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
              Text("Flexible", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
            ],
          ),
        )
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text("Step 12 of 16", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600)),
      centerTitle: true,
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1)
        ),
      ),
    );
  }
}