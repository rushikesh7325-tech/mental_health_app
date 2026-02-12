import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback

class PhysicalHarassmentScreen extends StatefulWidget {
  const PhysicalHarassmentScreen({super.key});

  @override
  State<PhysicalHarassmentScreen> createState() => _PhysicalHarassmentScreenState();
}

class _PhysicalHarassmentScreenState extends State<PhysicalHarassmentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Physical Harassment',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      _buildIllustrationSection(),
                      const SizedBox(height: 40),
                      _buildPolicyDescription(),
                      const SizedBox(height: 24),
                      _buildExamplesList(),
                    ],
                  ),
                ),
              ),
              _buildActionFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustrationSection() {
    return TweenAnimationBuilder(
      duration: const Duration(seconds: 2),
      tween: Tween<double>(begin: 0.95, end: 1.05),
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            height: 260,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFFFFF5F5), Colors.red.shade50.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pulse Effect
                Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                const Icon(
                  Icons.front_hand_rounded,
                  size: 85,
                  color: Color(0xFFE53935),
                ),
              ],
            ),
          ),
        );
      },
      onEnd: () {}, // Optional: loop the animation logic here
    );
  }

  Widget _buildPolicyDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.shade100.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "ZONE OF SAFETY",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.red.shade900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Physical harassment involves unwanted contact that violates personal safety.',
          style: TextStyle(
            fontSize: 24,
            height: 1.3,
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
      ],
    );
  }

  Widget _buildExamplesList() {
    final List<String> examples = [
      "Unwanted touching or physical contact",
      "Pushing, hitting, or physical assault",
      "Blocking movements or preventing exit",
      "Any action threatening physical integrity"
    ];

    return Column(
      children: examples.map((text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle_outline, size: 20, color: Colors.red.shade300),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey.shade700),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildActionFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 62,
        child: ElevatedButton(
          onPressed: () {
            HapticFeedback.lightImpact(); // Haptic Feedback
            Navigator.of(context).pop(true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1A1A),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text(
            'I Understand',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}