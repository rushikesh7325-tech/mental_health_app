import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_task_app/frontend/navigation/index.dart'; // Adjust path

class MindfulnessRoutineScreen extends StatefulWidget {
  final int questionid_8;
  const MindfulnessRoutineScreen({super.key, required this.questionid_8});

  @override
  State<MindfulnessRoutineScreen> createState() => _MindfulnessRoutineScreenState();
}

class _MindfulnessRoutineScreenState extends State<MindfulnessRoutineScreen> {
  final Map<String, int> mindfulnessAnswerMap = {
    'Yes, regularly': 2,
    'Yes, sometimes': 1,
    'No': 0,
  };

  String? selectedOption;
  final TextEditingController detailsController = TextEditingController();

  bool get showDetailsInput =>
      selectedOption == 'Yes, regularly' || selectedOption == 'Yes, sometimes';

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (selectedOption != null) {
      // Create a structured response
      final Map<String, dynamic> responseData = {
        "score": mindfulnessAnswerMap[selectedOption],
        "label": selectedOption,
        "details": showDetailsInput ? detailsController.text.trim() : null,
      };

      // Save to Controller
      AssessmentController().saveResponse(widget.questionid_8, responseData);
      
      // Navigate to Step 9 (Stress)
      Navigator.pushNamed(context, Routes.stress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView( // Changed to ScrollView to handle keyboard
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              "Do you currently have any routines for mindfulness, relaxation, or dedicated 'you-time'?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 32),
            
            _buildOptionTile('Yes, regularly'),
            _buildOptionTile('Yes, sometimes'),
            _buildOptionTile('No'),

            const SizedBox(height: 8),
            
            // Smoother Conditional Input
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(sizeFactor: animation, child: child),
                );
              },
              child: showDetailsInput ? _buildDetailsField() : const SizedBox.shrink(),
            ),

            const SizedBox(height: 100), // Space for button/scrolling
          ],
        ),
      ),
      bottomSheet: _buildBottomButton(), // Keeps button fixed above keyboard
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
      title: Column(
        children: [
          const Text('Step 8 of 16', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: LinearProgressIndicator(
              value: 8 / 16,
              backgroundColor: Colors.grey.shade100,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildOptionTile(String text) {
    final bool isSelected = selectedOption == text;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          selectedOption = text;
          if (text == 'No') detailsController.clear();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            if (isSelected) 
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: detailsController,
        maxLines: 2,
        maxLength: 50,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: "What kind? (e.g., meditation, reading)",
          hintStyle: TextStyle(color: Colors.grey.shade400),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: SizedBox(
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
            "CONTINUE",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1),
          ),
        ),
      ),
    );
  }
}