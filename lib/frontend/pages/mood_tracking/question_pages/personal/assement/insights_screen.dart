import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:first_task_app/frontend/navigation/index.dart';
class M4InsightsScreen extends StatefulWidget {
  final int questionid_15; // Add this
  const M4InsightsScreen({super.key, required this.questionid_15});
  @override
  State<M4InsightsScreen> createState() => _M4InsightsScreenState();
}

class _M4InsightsScreenState extends State<M4InsightsScreen> {
  // Data model for the insights
  final List<Map<String, dynamic>> insightOptions = [
    {
      "key": "Emotional Baseline",
      "title": "Your Emotional Baseline",
      "subtitle": "Understanding your stress triggers",
      "icon": Icons.analytics_outlined,
    },
    {
      "key": "Lifestyle Habits",
      "title": "Your Lifestyle Habits",
      "subtitle": "Routines that impact your mood",
      "icon": Icons.bedtime_outlined,
    },
    {
      "key": "Personal Context",
      "title": "Your Personal Context",
      "subtitle": "Environmental factors in focus",
      "icon": Icons.psychology_outlined,
    },
  ];

  final Set<String> selectedInsights = {};

  @override
  void initState() {
    super.initState();
    // Default: everything selected for a better "review" experience
    selectedInsights.addAll(insightOptions.map((e) => e['key'] as String));
  }

  void _handleContinue() {
  HapticFeedback.mediumImpact();
  // ADD THIS LINE:
  AssessmentController().saveResponse(widget.questionid_15, selectedInsights.toList());
  Navigator.pushNamed(context, Routes.m4processing);
}

  void _toggleInsight(String insight) {
    setState(() {
      if (selectedInsights.contains(insight)) {
        selectedInsights.remove(insight);
        HapticFeedback.lightImpact();
      } else {
        selectedInsights.add(insight);
        HapticFeedback.selectionClick();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Step 15 of 16",
          style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Review your Insights',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "We've analyzed your responses. Select the areas you'd like to include in your personalized report.",
                style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                  itemCount: insightOptions.length,
                  itemBuilder: (context, index) {
                    final item = insightOptions[index];
                    return _InsightCard(
                      title: item['title'],
                      subtitle: item['subtitle'],
                      icon: item['icon'],
                      isSelected: selectedInsights.contains(item['key']),
                      onTap: () => _toggleInsight(item['key']),
                    );
                  },
                ),
              ),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    bool isEmpty = selectedInsights.isEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: SizedBox(
        width: double.infinity,
        height: 62,
        child: ElevatedButton(
          onPressed: isEmpty ? null : _handleContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
          ),
          child: const Text(
            'LOOKS GOOD, SEE INSIGHTS',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _InsightCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey.shade200,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.15) : const Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: isSelected ? Colors.white : Colors.black87, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white70 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.add_circle_outline,
                color: isSelected ? Colors.white : Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}