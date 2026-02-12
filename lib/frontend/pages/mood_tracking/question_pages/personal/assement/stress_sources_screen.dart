import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_task_app/frontend/navigation/index.dart'; // Adjust path


class StressSourceScreen extends StatefulWidget {
  final int questionid_9;
  const StressSourceScreen({super.key, required this.questionid_9});

  @override
  State<StressSourceScreen> createState() => _StressSourceScreenState();
}

class _StressSourceScreenState extends State<StressSourceScreen> {
  final List<String> _options = [
    "Workload",
    "Academics",
    "Health",
    "Financial Concerns",
    "Feeling Disconnected",
    "Relationships\n(Personal/Professional)"
  ];

  final Set<int> _selectedIndices = {};

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        HapticFeedback.lightImpact();
      } else {
        if (_selectedIndices.length < 3) {
          _selectedIndices.add(index);
          HapticFeedback.mediumImpact();
        } else {
          // Provide feedback that limit is reached
          HapticFeedback.vibrate(); 
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please select up to 3 options"),
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });
  }

  void _onContinue() {
    if (_selectedIndices.isNotEmpty) {
      // Map indices back to labels
      final selectedLabels = _selectedIndices.map((i) => _options[i]).toList();
      
      // Save to controller
      AssessmentController().saveResponse(widget.questionid_9, selectedLabels);
      
      // Navigate to Step 10
      Navigator.pushNamed(context, Routes.stresslocation); 
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
              "What are your biggest sources of stress or pressure right now?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Select up to 3 options (${_selectedIndices.length}/3)",
              style: TextStyle(
                color: _selectedIndices.length == 3 ? Colors.green : Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndices.contains(index);
                  return _buildSelectableTile(index, isSelected);
                },
              ),
            ),
            _buildBottomButton(),
            const SizedBox(height: 40),
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
        "Step 9 of 16",
        style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSelectableTile(int index, bool isSelected) {
    return InkWell(
      onTap: () => _toggleSelection(index),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: isSelected 
            ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))]
            : [],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              _options[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            if (isSelected)
              const Positioned(
                right: 0,
                child: Icon(Icons.check_circle, color: Colors.white, size: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return ElevatedButton(
      onPressed: _selectedIndices.isEmpty ? null : _onContinue,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        disabledBackgroundColor: Colors.grey.shade200,
        minimumSize: const Size(double.infinity, 64),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
      child: const Text(
        "CONTINUE",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}