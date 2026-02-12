import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_task_app/frontend/navigation/index.dart';

class WeeklyCommitment extends StatefulWidget {
  final int questionid_13; // Add this
  const WeeklyCommitment({super.key, required this.questionid_13});
  @override
  State<WeeklyCommitment> createState() => _WeeklyCommitmentState();
}

class _WeeklyCommitmentState extends State<WeeklyCommitment> {
  String? selectedOption;

  final List<Map<String, dynamic>> options = [
    {'label': 'Just 5-10 minutes, a few times', 'icon': Icons.timer_outlined},
    {'label': '15-20 minutes, 2-3 times', 'icon': Icons.alarm_on_rounded},
    {'label': "I'll play it by ear", 'icon': Icons.auto_awesome_rounded},
  ];

void _onContinue() {
  if (selectedOption != null) {
    HapticFeedback.mediumImpact();
    // ADD THIS LINE:
    AssessmentController().saveResponse(widget.questionid_13, selectedOption); 
    Navigator.pushNamed(context, Routes.m4opensharing); 
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              "Set your pace",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Commitment helps build habits. Choose a realistic starting point.",
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 40),

            // Map the options to our custom tile widget
            ...options.map((opt) => _buildOptionTile(opt)),

            const Spacer(),
            _buildPrimaryButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(Map<String, dynamic> option) {
    final String label = option['label'];
    final IconData icon = option['icon'];
    final bool isSelected = selectedOption == label;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => selectedOption = label);
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey.shade200,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.black45,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: const BackButton(color: Colors.black),
      centerTitle: true,
      title: const Column(
        children: [
          Text(
            'Step 13 of 16',
            style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          // Simplified Progress Bar
          SizedBox(
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: 0.81, // 13/16
                backgroundColor: Color(0xFFEEEEEE),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                minHeight: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton() {
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
        child: const Text(
          'CONTINUE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}