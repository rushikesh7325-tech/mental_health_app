import 'package:flutter/material.dart';
import '../../../../navigation/index.dart';
import '../../../../services/university/UniversityAssessment.Controller.dart';
import '../../../../services/university/university_service.dart'; // Import your service

class FinalUniversityAssessmentScreen extends StatefulWidget {
  const FinalUniversityAssessmentScreen({super.key});

  @override
  State<FinalUniversityAssessmentScreen> createState() => _FinalUniversityAssessmentScreenState();
}

class _FinalUniversityAssessmentScreenState extends State<FinalUniversityAssessmentScreen> {
  final Set<int> _selectedIndices = {};
  bool _isSubmitting = false;

  final List<String> _options = [
    "Nothing, I'm ready",
    "Not sure what to do",
    "Forgetting to open it",
    "Lack of time"
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
            const SnackBar(
              content: Text("Please select up to 3 options only"),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    });
  }

  /// FINAL SUBMISSION LOGIC
  Future<void> _handleCompleteAssessment() async {
    if (_selectedIndices.isEmpty) return;

    setState(() => _isSubmitting = true);

    // 1. Save the final response to the UniversityController
    List<String> selectedAnswers = 
        _selectedIndices.map((index) => _options[index]).toList();
    UniversityController().saveField('app_usage_challenges', selectedAnswers);

    // 2. Submit the entire University Assessment payload to the backend
    final bool success = await UniversityService().submitUniversityDetails();

    setState(() => _isSubmitting = false);

    if (success) {
      // 3. Clear data is handled inside the service upon success
      debugPrint("✅ University Assessment Complete");
      
      // Navigate to your Success Screen or Dashboard
      // Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Submission failed. Please check your connection.")),
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
          "Question 12 of 12",
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
              "What might make it challenging\nto use a wellbeing app regularly?",
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
                        textAlign: TextAlign.center,
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

            // Final Submission Button
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0, top: 20),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: (_selectedIndices.isNotEmpty && !_isSubmitting) 
                      ? _handleCompleteAssessment 
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isSubmitting 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Complete Assessment",
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