import 'package:flutter/material.dart';
import '../../../../navigation/index.dart';
// Ensure this is imported
import '../../../../services/university/UniversityAssessment.Controller.dart';
class StudySentimentScreen extends StatefulWidget {
  const StudySentimentScreen({super.key});

  @override
  State<StudySentimentScreen> createState() => _StudySentimentScreenState();
}

class _StudySentimentScreenState extends State<StudySentimentScreen> {
  int? _selectedRating;

  final List<Map<String, dynamic>> _sentiments = [
    {"value": 1, "emoji": "😟", "label": "Very low"},
    {"value": 2, "emoji": "😔", "label": "2"},
    {"value": 3, "emoji": "😅", "label": "3"},
    {"value": 4, "emoji": "🙂", "label": "4"},
    {"value": 5, "emoji": "🥰", "label": "Very happy"},
  ];

  void _handleContinue() {
    if (_selectedRating != null) {
      // Save the numerical rating to the UniversityController
      UniversityController().saveField('study_sentiment_rating', _selectedRating);
      
      // Navigate to Question 6
     Navigator.pushNamed(context, Routes.uniassessment5);
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
          "Question 5 of 12",
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
              "How do you usually feel\nafter a full study day?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 60),
            
            // Custom Emoji Rating Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _sentiments.map((item) {
                bool isSelected = _selectedRating == item['value'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedRating = item['value']),
                  child: Column(
                    children: [
                      Text(
                        item['emoji'],
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 15),
                      // The "Dot" and Line Connector visual
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.black : Colors.grey[300],
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item['label'],
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.black : Colors.grey,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            // Continue Button
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedRating != null ? _handleContinue : null,
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
                      color: _selectedRating != null ? Colors.white : Colors.grey[600],
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