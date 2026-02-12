import 'package:flutter/material.dart';
import '../../../../navigation/index.dart';
// Updated import to point to UniversityController
import '../../../../services/university/UniversityAssessment.Controller.dart'; 

class AcademicMindsetScreen extends StatefulWidget {
  const AcademicMindsetScreen({super.key});

  @override
  State<AcademicMindsetScreen> createState() => _AcademicMindsetScreenState();
}

class _AcademicMindsetScreenState extends State<AcademicMindsetScreen> {
  int? _selectedIndex;

  final List<String> _options = [
    "Motivated and engaged",
    "Neutral and managing",
    "Stressed and tense",
    "Disconnected or exhausted"
  ];

  void _handleContinue() {
    if (_selectedIndex != null) {
      // CHANGED: Use UniversityController().saveField as requested
      // This maps the response to a specific key in your controller's data map
      UniversityController().saveField(
        'academic_mindset', 
        _options[_selectedIndex!]
      );
      
      // Navigate to the next screen (Question 9)
      Navigator.pushNamed(context, Routes.uniassessment9);
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
          "Question 8 of 12", // Updated total count
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
              "Which statement best\ndescribes your current\nacademic mindset?",
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
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
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