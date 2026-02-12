import 'package:flutter/material.dart';

class PersonalExplorePage extends StatelessWidget {
  final String? userType;

  const PersonalExplorePage({super.key, this.userType});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 24),

            // Featured Card - Personal Growth Focus
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/swot_analysis'),
              child: _buildFeaturedCard(),
            ),
            const SizedBox(height: 24),

            // Interaction Row
            // Interaction Row - Inside Column children
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/daily_journal'),
                    child: _buildSquareCard(
                      "Daily\nJournal",
                      "Write it out",
                      Icons.edit_note,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // --- USER TYPE CHECK ---
                      if (userType == 'university') {
                        // Company users track POSH cases
                        Navigator.pushNamed(context, '/uniassessment');
                      } else {
                        // University/Personal users track Mood Assessments
                        Navigator.pushNamed(context, '/assessment');
                      }
                    },
                    child: _buildSquareCard(
                      "Mood\nTracking",
                      "Check in",
                      Icons.sentiment_satisfied_alt,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // NEW SECTION: Personal Wellness instead of POSH
            const Text(
              "Wellness Journey",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/wellness_stats'),
              child: _buildWellnessCard(),
            ),

            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Explore',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.search, size: 28)),
      ],
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // Sleek off-black
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "RECOMMENDED",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Self-Discovery\nSWOT",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Map out your personal strengths and growth areas.",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Text(
                "Explore Now",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 18),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSquareCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Replacement for POSH Card
  Widget _buildWellnessCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8DEF8), // Light Purple
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.wb_sunny_outlined,
              color: Color(0xFF6750A4),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mindfulness Streak",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  "4 days active",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 60,
            child: LinearProgressIndicator(
              value: 0.8,
              backgroundColor: Color(0xFFF3F4F6),
              color: Colors.black,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
