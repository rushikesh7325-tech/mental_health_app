import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_task_app/frontend/navigation/index.dart'; // Adjust path


class PhysicalActivityScreen extends StatefulWidget {
  final int questionid_7;
  const PhysicalActivityScreen({super.key, required this.questionid_7});

  @override
  State<PhysicalActivityScreen> createState() => _PhysicalActivityScreenState();
}

class _PhysicalActivityScreenState extends State<PhysicalActivityScreen> {
  String? selectedOption;
  
  // Added icons and descriptions for a richer UI
  final List<Map<String, dynamic>> activityOptions = [
    {"label": "Rarely", "icon": Icons.chair_rounded, "desc": "Little to no formal exercise"},
    {"label": "1-2 days a week", "icon": Icons.directions_walk_rounded, "desc": "Light activity or occasional walks"},
    {"label": "3-4 days a week", "icon": Icons.fitness_center_rounded, "desc": "Regular workouts or active lifestyle"},
    {"label": "5+ days a week", "icon": Icons.bolt_rounded, "desc": "Very active / Daily training"},
  ];

  void _onContinue() {
    if (selectedOption != null) {
      // Save the selection to our central controller
      AssessmentController().saveResponse(widget.questionid_7, selectedOption);
      
      // Navigate to Step 8
      Navigator.pushNamed(context, Routes.m2mindfulness); 
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
          "Step 7 of 16",
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
            const Text(
              "How often are you\nphysically active?",
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.bold, 
                color: Color(0xFF1A1A1A),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "This includes sports, gym, brisk walking, or yoga.",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: activityOptions.length,
                itemBuilder: (context, index) {
                  final option = activityOptions[index];
                  return _buildOptionTile(option);
                },
              ),
            ),
            _buildContinueButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(Map<String, dynamic> option) {
    bool isSelected = selectedOption == option['label'];
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        setState(() => selectedOption = option['label'] as String);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.2) : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                option['icon'] as IconData,
                color: isSelected ? Colors.white : Colors.black87,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option['label'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option['desc'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: selectedOption != null ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: Text(
          "CONTINUE",
          style: TextStyle(
            color: selectedOption != null ? Colors.white : Colors.grey.shade500,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}