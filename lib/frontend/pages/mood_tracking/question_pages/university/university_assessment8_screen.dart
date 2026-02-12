import 'package:flutter/material.dart';
import '../../../../navigation/index.dart';
import '../../../../services/university/UniversityAssessment.Controller.dart'; 

class AcademicPressureResponseScreen extends StatefulWidget {
  const AcademicPressureResponseScreen({super.key});

  @override
  State<AcademicPressureResponseScreen> createState() =>
      _AcademicPressureResponseScreenState();
}

class _AcademicPressureResponseScreenState
    extends State<AcademicPressureResponseScreen> {
  int? _selectedIndex;

  final List<String> _options = [
    "I plan and work harder",
    "Busy but manageable",
    "Frequently stressful",
    "Extremely overwhelming",
  ];

  void _handleContinue() {
    if (_selectedIndex != null) {
      // UPDATED: Saving using UniversityController().saveField as requested
      // Using 'academic_pressure_response' as the key
      UniversityController().saveField(
        'academic_pressure_response', 
        _options[_selectedIndex!]
      );

      // Navigate to the next screen (Question 10: Stress Sources)
      Navigator.pushNamed(context, Routes.uniassessment10);
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
          "Question 9 of 12", // Updated to reflect 16 total screens
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
              "How do you usually\nrespond when academic\npressure increases?",
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
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
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
                      color: _selectedIndex != null
                          ? Colors.white
                          : Colors.grey[600],
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