import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_task_app/frontend/navigation/index.dart'; // Adjust path


class BarriersToEntryScreen extends StatefulWidget {
  final int questionid_11;
  const BarriersToEntryScreen({super.key, required this.questionid_11});

  @override
  State<BarriersToEntryScreen> createState() => _BarriersToEntryScreenState();
}

class _BarriersToEntryScreenState extends State<BarriersToEntryScreen> {
  final List<String> options = [
    "Nothing, I'm ready",
    "Not sure what to do",
    "Forgetting to open it",
    "Lack of time",
  ];

  final Set<String> selectedOptions = {};

  void _handleToggle(String opt) {
    setState(() {
      if (opt == "Nothing, I'm ready") {
        // Clear everything else if "Ready" is picked
        selectedOptions.clear();
        selectedOptions.add(opt);
        HapticFeedback.mediumImpact();
      } else {
        // Remove "Ready" if a challenge is picked
        selectedOptions.remove("Nothing, I'm ready");
        
        if (selectedOptions.contains(opt)) {
          selectedOptions.remove(opt);
          HapticFeedback.lightImpact();
        } else if (selectedOptions.length < 3) {
          selectedOptions.add(opt);
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.vibrate();
        }
      }
    });
  }

  void _onContinue() {
    if (selectedOptions.isNotEmpty) {
      AssessmentController().saveResponse(widget.questionid_11, selectedOptions.toList());
      // Navigate to Step 12
      Navigator.pushNamed(context, Routes.learningPreference); 
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
              "What might make it challenging to use a wellbeing app regularly?",
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
              "Your honesty helps us support you better.",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final opt = options[index];
                  bool isSelected = selectedOptions.contains(opt);
                  
                  return _buildChallengeTile(opt, isSelected);
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
        "Step 11 of 16",
        style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
    );
  }

  Widget _buildChallengeTile(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _handleToggle(label),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: isSelected 
              ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]
              : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 17, 
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
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