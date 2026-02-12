import 'package:flutter/material.dart';
import '../../../../navigation/index.dart';
// Ensure this is imported
import '../../../../services/university/UniversityAssessment.Controller.dart';// Import for the next screen

class ScheduleControlScreen extends StatefulWidget {
  const ScheduleControlScreen({super.key});

  @override
  State<ScheduleControlScreen> createState() => _ScheduleControlScreenState();
}

class _ScheduleControlScreenState extends State<ScheduleControlScreen> {
  int? _selectedIndex;

  final List<String> _options = [
    "I manage my time well",
    "I manage it sometimes",
    "I often feel behind",
    "I feel constantly rushed"
  ];

  void _handleContinue() {
    if (_selectedIndex != null) {
      // Save the selected response to the UniversityController
      UniversityController().saveField(
        'schedule_control', 
        _options[_selectedIndex!]
      );
      
      // Navigate to Question 5: Study Sentiment Screen
      Navigator.pushNamed(
        context, 
        Routes.uniassessment4
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
          "Question 4 of 12",
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
              "How much control do you\nfeel over your schedule?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 40),
            // Selection List
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
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        _options[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Continue Button
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