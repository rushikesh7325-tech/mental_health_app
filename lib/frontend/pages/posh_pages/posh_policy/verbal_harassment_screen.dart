import 'package:flutter/material.dart';

class VerbalHarassmentScreen extends StatefulWidget {
  const VerbalHarassmentScreen({super.key});

  @override
  State<VerbalHarassmentScreen> createState() => _VerbalHarassmentScreenState();
}

class _VerbalHarassmentScreenState extends State<VerbalHarassmentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

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
      backgroundColor: const Color(0xFFFAFBFF),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            // Optional: Progress bar for the policy flow
            const LinearProgressIndicator(
              value: 0.2, // 1st step of the policy
              backgroundColor: Color(0xFFE0E0E0),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              minHeight: 2,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildHeroSection(),
                    const SizedBox(height: 32),
                    _buildContentSection(),
                    const SizedBox(height: 32),
                    _buildExamplesGrid(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildFooterButton(context),
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
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Policy Education',
        style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildHeroSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: CircleAvatar(radius: 60, backgroundColor: Colors.blue.shade50.withOpacity(0.4)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.record_voice_over_rounded, size: 64, color: Colors.black),
                const SizedBox(height: 16),
                Text(
                  "Verbal Harassment",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue.shade900,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "UNDERSTANDING THE IMPACT",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Verbal harassment is the use of speech to humiliate or intimidate.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.3),
          ),
          const SizedBox(height: 12),
          Text(
            'It often leaves no physical marks but creates deep psychological distress and a toxic work culture.',
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildExamplesGrid() {
    final List<Map<String, dynamic>> examples = [
      {'icon': Icons.shutter_speed_rounded, 'text': 'Inappropriate Jokes'},
      {'icon': Icons.volume_up_rounded, 'text': 'Unwelcome Comments'},
      {'icon': Icons.warning_amber_rounded, 'text': 'Threatening Speech'},
      {'icon': Icons.person_off_rounded, 'text': 'Insulting Slurs'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Common Examples:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemCount: examples.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(examples[index]['icon'], size: 18, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      examples[index]['text'],
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFooterButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(true),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: const Text(
          'I Understand',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}