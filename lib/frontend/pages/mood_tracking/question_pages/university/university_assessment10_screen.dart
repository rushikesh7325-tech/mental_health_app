import 'package:flutter/material.dart';
import '../../../../navigation/index.dart';
import '../../../../services/university/UniversityAssessment.Controller.dart'; // Replace with your actual next screen file
 // Using the UniversityController as requested
class StressLocationScreen extends StatefulWidget {
  const StressLocationScreen({super.key});

  @override
  State<StressLocationScreen> createState() => _StressLocationScreenState();
}

class _StressLocationScreenState extends State<StressLocationScreen> {
  // Set to store multiple selected indices (up to 3)
  final Set<int> _selectedIndices = {};

  final List<String> _options = [
    "At my work / school",
    "In meetings or class",
    "During commute",
    "At home",
    "In social situations"
  ];

  void _onOptionTapped(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        if (_selectedIndices.length < 3) {
          _selectedIndices.add(index);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Select up to 3 options")),
          );
        }
      }
    });
  }

  void _handleContinue() {
    if (_selectedIndices.isNotEmpty) {
      // Map indices to actual text values
      List<String> selectedAnswers = 
          _selectedIndices.map((index) => _options[index]).toList();

      // Save to AssessmentController with Question ID 11
      UniversityController().saveField('stress_sources', selectedAnswers);
      
      // Navigate to Question 12
      Navigator.pushNamed(context, Routes.uniassessment11);
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Question 11 of 12",
          style: TextStyle(color: Colors.grey, fontSize: 16),
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
              "Where do you most often feel\nyour stress or want to practice\nmindfulness?",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Select 3 options that apply to your day.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                itemCount: _options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  bool isSelected = _selectedIndices.contains(index);
                  return GestureDetector(
                    onTap: () => _onOptionTapped(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.black12,
                          width: isSelected ? 2 : 1.5,
                        ),
                      ),
                      child: Text(
                        _options[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0, top: 20),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedIndices.isNotEmpty ? _handleContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}