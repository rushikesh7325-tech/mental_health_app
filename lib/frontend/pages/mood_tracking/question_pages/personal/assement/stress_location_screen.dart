import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_task_app/frontend/navigation/index.dart'; // Adjust path


class MindfulnessLocationScreen extends StatefulWidget {
  final int questionid_10;
  const MindfulnessLocationScreen({super.key, required this.questionid_10});

  @override
  State<MindfulnessLocationScreen> createState() => _MindfulnessLocationScreenState();
}

class _MindfulnessLocationScreenState extends State<MindfulnessLocationScreen> {
  final List<Map<String, dynamic>> options = [
    {"label": "At my work / school", "icon": Icons.business_center_rounded},
    {"label": "In meetings or class", "icon": Icons.groups_rounded},
    {"label": "During commute", "icon": Icons.directions_bus_rounded},
    {"label": "At home", "icon": Icons.home_rounded},
    {"label": "In social situations", "icon": Icons.celebration_rounded},
  ];

  final Set<String> selectedOptions = {};

  void _onContinue() {
    if (selectedOptions.isNotEmpty) {
      AssessmentController().saveResponse(widget.questionid_10, selectedOptions.toList());
      // Navigate to Step 11
      Navigator.pushNamed(context, Routes.stresschallenge); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Where do you most often feel stress or want to practice?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                height: 1.2,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Select up to 3 options (${selectedOptions.length}/3)",
              style: TextStyle(
                color: selectedOptions.length == 3 ? Colors.blue : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final opt = options[index]['label'] as String;
                  final icon = options[index]['icon'] as IconData;
                  bool isSelected = selectedOptions.contains(opt);
                  
                  return _buildLocationTile(opt, icon, isSelected);
                },
              ),
            ),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Step 10 of 16",
        style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
    );
  }

  Widget _buildLocationTile(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedOptions.remove(label);
            HapticFeedback.lightImpact();
          } else if (selectedOptions.length < 3) {
            selectedOptions.add(label);
            HapticFeedback.mediumImpact();
          } else {
            HapticFeedback.vibrate();
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.black54),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, top: 16),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: selectedOptions.isNotEmpty ? _onContinue : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            disabledBackgroundColor: Colors.grey.shade200,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 0,
          ),
          child: const Text(
            "CONTINUE", 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1),
          ),
        ),
      ),
    );
  }
}