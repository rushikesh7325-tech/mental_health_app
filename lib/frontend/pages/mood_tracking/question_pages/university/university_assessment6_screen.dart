import 'package:flutter/material.dart';
import '../../../../navigation/index.dart';
// Assuming UniversityController is in this path based on your prompt
import '../../../../services/university/UniversityAssessment.Controller.dart'; 

class StressTriggersScreen extends StatefulWidget {
  const StressTriggersScreen({super.key});

  @override
  State<StressTriggersScreen> createState() => _StressTriggersScreenState();
}

class _StressTriggersScreenState extends State<StressTriggersScreen> {
  int? _selectedIndex;

  final List<String> _options = [
    "At the beginning of the day",
    "As tasks pile up",
    "Near exams or deadlines",
    "It changes often"
  ];

  void _handleContinue() {
    if (_selectedIndex != null) {
      // UPDATED: Using saveField as requested for the University Assessment
      // We save the text response under the key 'stress_trigger_timing'
      UniversityController().saveField('stress_trigger_timing', _options[_selectedIndex!]);
      
      // Navigate to the next screen in your route index
      Navigator.pushNamed(
        context, 
        Routes.uniassessment8, // Assuming the next route is 8
      );
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
          "Question 7 of 12", // Updated to reflect the university assessment length
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
              "When do studies usually\nstart to feel stressful?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.separated(
                itemCount: _options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  bool isSelected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3), // Slightly lighter grey for a cleaner look
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        _options[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: Colors.black87,
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
                  onPressed: _selectedIndex != null ? _handleContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      color: _selectedIndex != null ? Colors.white : Colors.grey[600],
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