import 'package:flutter/material.dart';
import 'package:first_task_app/frontend/navigation/index.dart'; // Adjust path
 

class ReduceAnxietyFeelingsScreen extends StatefulWidget {
  final int questionid_3;

  const ReduceAnxietyFeelingsScreen({super.key, required this.questionid_3});

  @override
  State<ReduceAnxietyFeelingsScreen> createState() => _ReduceAnxietyFeelingsScreenState();
}

class _ReduceAnxietyFeelingsScreenState extends State<ReduceAnxietyFeelingsScreen> {
  final List<String> _options = [
    'Racing thoughts', 'Muscle tension', 'Negative Self-talk', 'Fatigue',
    'Restlessness', 'Irritability', 'Comparing to others', 'Fear of failure',
    'Forgetfulness', 'Easily distracted', 'Mental fog', 'Procrastination',
    'Self-doubt', 'Feeling overwhelmed'
  ];

  final Set<String> _selectedItems = {};

  void _toggleSelection(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  void _onContinue() {
    if (_selectedItems.isNotEmpty) {
      // 1. Save the list of selected strings to the controller
      AssessmentController().saveResponse(widget.questionid_3, _selectedItems.toList());
      
      // 2. Navigate to Step 4
      Navigator.pushNamed(context, Routes.m4copping);
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
          'Step 3 of 16',
          style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
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
              'When you think about reducing anxiety, what does it often feel like for you?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select all that apply to you.',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
            const SizedBox(height: 30),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Wrap(
                  spacing: 12.0, 
                  runSpacing: 12.0, 
                  children: _options.map((option) {
                    final bool isSelected = _selectedItems.contains(option);
                    return GestureDetector(
                      onTap: () => _toggleSelection(option),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            _buildContinueButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    final bool hasSelection = _selectedItems.isNotEmpty;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: hasSelection ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Text(
          'CONTINUE',
          style: TextStyle(
            color: hasSelection ? Colors.white : Colors.grey.shade500,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}