import 'package:flutter/material.dart';
import '../../../../navigation/index.dart';
// Ensure this is imported
import '../../../../services/university/UniversityAssessment.Controller.dart';
class AcademicLoadScreen extends StatefulWidget {
  const AcademicLoadScreen({super.key});

  @override
  State<AcademicLoadScreen> createState() => _AcademicLoadScreenState();
}

class _AcademicLoadScreenState extends State<AcademicLoadScreen> {
  // 0.0 = Light, 0.5 = Neutral, 1.0 = Heavy
  double _currentSliderValue = 0.5;
  bool _hasInteracted = false;

  void _handleContinue() {
    // Convert double to a descriptive string for the backend
    String loadDescription;
    if (_currentSliderValue < 0.3) {
      loadDescription = "Light";
    } else if (_currentSliderValue > 0.7) {
      loadDescription = "Heavy";
    } else {
      loadDescription = "Neutral";
    }

    // Save to UniversityController
    UniversityController().saveField('academic_load_value', _currentSliderValue);
    UniversityController().saveField('academic_load_label', loadDescription);

    // Navigate to Question 4
    Navigator.pushNamed(context, Routes.uniassessment3);
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
          "Question 3 of 12",
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
              "How does your academic\nload feel currently?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 60),
            
            // Custom Styled Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.black,
                inactiveTrackColor: Colors.grey[200],
                thumbColor: Colors.black,
                overlayColor: Colors.black.withOpacity(0.1),
                trackHeight: 8.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
              ),
              child: Slider(
                value: _currentSliderValue,
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                    _hasInteracted = true;
                  });
                },
              ),
            ),
            
            // Labels for the Slider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Light", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  Text("Neutral", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  Text("Heavy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
            ),

            const Spacer(),

            // Continue Button
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _hasInteracted ? _handleContinue : null,
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
                      color: _hasInteracted ? Colors.white : Colors.grey[600],
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