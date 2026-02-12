import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_task_app/frontend/navigation/index.dart';
class OpenSharingScreen extends StatefulWidget {
  final int questionid_14; // Add this
  const OpenSharingScreen({super.key, required this.questionid_14});

  @override
  State<OpenSharingScreen> createState() => _OpenSharingScreenState();
}

class _OpenSharingScreenState extends State<OpenSharingScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isHasText = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _isHasText = _textController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

void _handleNext() {
  HapticFeedback.mediumImpact();
  // ADD THIS LINE:
  AssessmentController().saveResponse(widget.questionid_14, _textController.text.trim());
  Navigator.pushNamed(context, Routes.insights);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), 
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Is there anything else on your mind you'd like to share?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                        height: 1.3,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "(This is completely optional)",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildInputContainer(),
                    const SizedBox(height: 24),
                    _buildPrivacyNote(),
                  ],
                ),
              ),
            ),
            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (!_isHasText)
          TextButton(
            onPressed: _handleNext,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.grey, 
                fontSize: 16, 
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildInputContainer() {
    return Container(
      constraints: const BoxConstraints(minHeight: 220),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: TextField(
        controller: _textController,
        maxLines: 8,
        minLines: 5,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(
          fontSize: 16, 
          color: Color(0xFF2D2D2D), 
          height: 1.5
        ),
        decoration: InputDecoration(
          hintText: 'Type anything here...\nyour hopes, fears, or what "mental clarity" means to you.',
          hintStyle: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade400,
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPrivacyNote() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.lock_person_rounded, 
          size: 16, 
          color: Colors.blueGrey.withOpacity(0.4)
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'This is for your personal reflection. Your privacy is protected and responses are encrypted.',
            style: TextStyle(
              fontSize: 12, 
              color: Colors.grey, 
              height: 1.4
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: _handleNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHasText ? Colors.black : Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            elevation: 0,
          ),
          child: Text(
            _isHasText ? 'CONTINUE' : 'NEXT',
            style: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold, 
              letterSpacing: 1.1,
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}