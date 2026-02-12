import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for Clipboard and Haptics
import 'package:first_task_app/frontend/navigation/index.dart';
class HelpAndSupport6 extends StatefulWidget {
  const HelpAndSupport6({super.key});

  @override
  State<HelpAndSupport6> createState() => _HelpAndSupport6State();
}

class _HelpAndSupport6State extends State<HelpAndSupport6> {
  String complaintId = 'CMP-82910-X2'; // Mock data for display

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // Enhanced Success Icon
                    _buildSuccessHero(),
                    
                    const SizedBox(height: 32),
                    const Text(
                      "Report Submitted",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Your case has been securely filed with the Internal Committee. Your courage helps keep our workplace safe.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Interactive ID Card
                    _buildInteractiveIDCard(),
                    
                    const SizedBox(height: 40),
                    
                    // Visual Timeline Header
                    _buildSectionHeader("NEXT STEPS"),
                    
                    const SizedBox(height: 20),
                    
                    // Visual Roadmap
                    _buildTimelineItem(
                      step: "1",
                      title: "Initial Review",
                      desc: "IC reviews report for policy alignment.",
                      isDone: true,
                    ),
                    _buildTimelineItem(
                      step: "2",
                      title: "Fact Finding",
                      desc: "Confidential inquiry and documentation.",
                      isDone: false,
                    ),
                    _buildTimelineItem(
                      step: "3",
                      title: "Resolution",
                      desc: "Decision and formal closing of case.",
                      isLast: true,
                      isDone: false,
                    ),
                  ],
                ),
              ),
            ),
            
            // Primary Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded, color: Colors.black), // "Close" instead of "Back" for finality
        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
      ),
      title: const Text(
        "Submission Status",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
      ),
    );
  }

  Widget _buildSuccessHero() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            color: const Color(0xFF00C569).withOpacity(0.08),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFFE7F9F0),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.verified_rounded,
            size: 80,
            color: Color(0xFF00C569),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveIDCard() {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: complaintId));
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ID copied to clipboard"), duration: Duration(seconds: 1)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [Colors.grey.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "COMPLAINT ID",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                ),
                const Icon(Icons.copy_rounded, size: 16, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              complaintId,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: 1.0),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  "Filed on April 24, 2024",
                  style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1.1),
        ),
        const SizedBox(width: 8),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String step,
    required String title,
    required String desc,
    bool isLast = false,
    bool isDone = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDone ? const Color(0xFF00C569) : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: isDone ? const Color(0xFF00C569) : Colors.grey.shade300, width: 2),
                ),
                child: Center(
                  child: isDone 
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : Text(step, style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: Colors.grey.shade200),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                Text(desc, style: TextStyle(color: Colors.grey.shade500, fontSize: 13, height: 1.4)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.pushNamed(context, '/tracking');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              child: const Text(
                "Track Detailed Status",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}