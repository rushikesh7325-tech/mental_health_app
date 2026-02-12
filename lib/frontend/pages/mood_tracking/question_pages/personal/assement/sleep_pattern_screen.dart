import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_task_app/frontend/navigation/index.dart'; // Adjust path


class SleepQualityScreen extends StatefulWidget {
  final int questionid_6;
  const SleepQualityScreen({super.key, required this.questionid_6});

  @override
  State<SleepQualityScreen> createState() => _SleepQualityScreenState();
}

class _SleepQualityScreenState extends State<SleepQualityScreen> {
  String? selectedHours;
  String? selectedQuality;
  
  final List<String> hoursOptions = ["<5", "6", "7", "8", "9+"];
  final List<String> qualityOptions = ["Sound", "Fair", "Restless"];

  bool get isContinueEnabled => selectedHours != null && selectedQuality != null;

  void _onContinue() {
    if (isContinueEnabled) {
      // Save as a map: { "hours": "7", "quality": "Sound" }
      AssessmentController().saveResponse(widget.questionid_6, {
        "hours": selectedHours,
        "quality": selectedQuality,
      });
      
      Navigator.pushNamed(context, Routes.physicalActivity);
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
          "Step 6 of 16",
          style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildSectionTitle("How many hours of sleep\ndo you usually get?"),
            const SizedBox(height: 20),
            _buildOptionGrid(hoursOptions, selectedHours, (val) {
              setState(() => selectedHours = val);
            }),
            
            const SizedBox(height: 48),
            
            _buildSectionTitle("How would you rate the\noverall quality?"),
            const SizedBox(height: 20),
            _buildOptionGrid(qualityOptions, selectedQuality, (val) {
              setState(() => selectedQuality = val);
            }, isFullWidth: true),
            
            const Spacer(),
            _buildContinueButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22, 
        fontWeight: FontWeight.bold, 
        color: Color(0xFF1A1A1A),
        height: 1.2
      ),
    );
  }

  Widget _buildOptionGrid(List<String> options, String? selectedValue, Function(String) onSelect, {bool isFullWidth = false}) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        final bool isSelected = selectedValue == option;
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onSelect(option);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: isFullWidth ? 32 : 24, 
              vertical: 16
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.black : Colors.grey.shade200,
                width: 1.5,
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isContinueEnabled ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: Text(
          "CONTINUE",
          style: TextStyle(
            color: isContinueEnabled ? Colors.white : Colors.grey.shade500,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}