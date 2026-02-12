import 'package:flutter/material.dart';
import 'package:first_task_app/frontend/navigation/index.dart'; // Adjust path


class MoodSelectionScreen extends StatefulWidget {
  final int questionid_2; // Passed from RouteGenerator

  const MoodSelectionScreen({super.key, required this.questionid_2});

  @override
  State<MoodSelectionScreen> createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  String? selectedMood;
  
  final List<Map<String, String>> moods = [
    {'label': 'Drained', 'emoji': '😫'},
    {'label': 'Low', 'emoji': '😔'},
    {'label': 'Neutral', 'emoji': '😐'},
    {'label': 'Good', 'emoji': '🙂'},
    {'label': 'Energetic', 'emoji': '🤩'},
  ];

  void _onContinue() {
    if (selectedMood != null) {
      // 1. Save to the Controller
      AssessmentController().saveResponse(widget.questionid_2, selectedMood);
      
      // 2. Navigate to Step 3
      Navigator.pushNamed(context, Routes.m3primary);
    }
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
          'Step 2 of 16',
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
              'Over the past week, how would you describe your overall energy and mood?',
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: moods.map((mood) {
                    bool isSelected = selectedMood == mood['label'];
                    return _buildMoodCard(mood, isSelected);
                  }).toList(),
                ),
              ),
            ),
            _buildContinueButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(Map<String, String> mood, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: (MediaQuery.of(context).size.width / 2) - 40,
      child: GestureDetector(
        onTap: () => setState(() => selectedMood = mood['label']),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: isSelected 
              ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]
              : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mood['emoji']!, 
                style: const TextStyle(fontSize: 32)
              ),
              const SizedBox(height: 12),
              Text(
                mood['label']!,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: selectedMood != null ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Text(
          'CONTINUE',
          style: TextStyle(
            color: selectedMood != null ? Colors.white : Colors.grey.shade500,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}