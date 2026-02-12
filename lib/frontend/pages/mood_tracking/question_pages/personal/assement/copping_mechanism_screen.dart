import 'package:flutter/material.dart';
import 'package:first_task_app/frontend/navigation/index.dart'; // Adjust path


class OverwhelmedActionsScreen extends StatefulWidget {
  final int questionid_4;
  const OverwhelmedActionsScreen({super.key, required this.questionid_4});

  @override
  State<OverwhelmedActionsScreen> createState() => _OverwhelmedActionsScreenState();
}

class _OverwhelmedActionsScreenState extends State<OverwhelmedActionsScreen> {
  final List<_ActionItem> actions = [
    _ActionItem("Take a walk", Icons.directions_walk_rounded),
    _ActionItem("Talk to someone", Icons.chat_bubble_outline_rounded),
    _ActionItem("Scroll on phone", Icons.phone_android_rounded),
    _ActionItem("Isolate myself", Icons.person_outline_rounded),
    _ActionItem("Practice deep breathing", Icons.self_improvement_rounded),
    _ActionItem("Skip meals", Icons.no_food_rounded),
    _ActionItem("Journal", Icons.menu_book_rounded),
  ];

  bool get allAnswered => actions.every((action) => action.helpsMe != null);

  void _onContinue() {
    if (allAnswered) {
      // 1. Convert the custom items into a serializable Map for the backend
      // { "Take a walk": true, "Scroll on phone": false, ... }
      final Map<String, bool> results = {
        for (var action in actions) action.label: action.helpsMe!
      };

      // 2. Save to Controller
      AssessmentController().saveResponse(widget.questionid_4, results);

      // 3. Navigate to Step 5
      Navigator.pushNamed(context, Routes.m5support);
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
          'Step 4 of 16',
          style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "What do you typically do when feeling overwhelmed or down?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Rate how each action impacts your wellbeing.",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: actions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _ActionTile(
                    item: actions[index],
                    onChanged: () => setState(() {}),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildContinueButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: allAnswered ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Text(
          "CONTINUE",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: allAnswered ? Colors.white : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}

class _ActionItem {
  final String label;
  final IconData icon;
  bool? helpsMe;
  _ActionItem(this.label, this.icon);
}

class _ActionTile extends StatelessWidget {
  final _ActionItem item;
  final VoidCallback onChanged;

  const _ActionTile({required this.item, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: item.helpsMe != null ? Colors.black.withOpacity(0.05) : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, size: 20, color: Colors.black87),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SegmentButton(
                  text: "Helps me",
                  isSelected: item.helpsMe == true,
                  activeColor: Colors.green.shade400,
                  onTap: () {
                    item.helpsMe = true;
                    onChanged();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SegmentButton(
                  text: "Doesn't help",
                  isSelected: item.helpsMe == false,
                  activeColor: Colors.orange.shade400,
                  onTap: () {
                    item.helpsMe = false;
                    onChanged();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.text,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade200,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}