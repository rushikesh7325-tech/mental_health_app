import 'package:flutter/material.dart';
import '../../../../navigation/index.dart';
import 'package:get/get.dart'; // Ensure GetX is imported

class ExplorePageCompany extends StatelessWidget {
  final String? userType;

  const ExplorePageCompany({super.key, this.userType});

  /// Logic to determine where the user should go when clicking POSH
  // explore_page_company.dart

  Future<void> _handlePOSHNavigation(BuildContext context) async {
    final POSHController poshController = Get.put<POSHController>(POSHController());

    debugPrint("🚀 [NAV DEBUG] Requesting status via Controller...");

    // Call the new method we just created
    final status = await poshController.fetchLiveStatus();

    if (status == null) {
      debugPrint("❌ [NAV DEBUG] Status was null, defaulting to posh1");
      Get.toNamed('/posh1');
      return;
    }

    // Use the data from the server
    final bool hasReport = status['report'] != null;
    final bool trainingDone = status['trainingComplete'] == true;

    if (hasReport) {
      Navigator.pushNamed(context, Routes.compliantloading);
    } else if (trainingDone) {
      Navigator.pushNamed(context, Routes.reportcompliant);
    } else {
      Navigator.pushNamed(context, Routes.posh1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPersonal = userType?.toLowerCase().trim() == 'personal';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 24),

            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/swot_analysis'),
              child: _buildFeaturedCard(),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/daily_journal'),
                    child: _buildSquareCard(
                      "Daily\nJournal",
                      "Work logs",
                      Icons.edit_note,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/assessment'),
                    child: _buildSquareCard(
                      "Mood\nTracking",
                      "Pulse check",
                      Icons.sentiment_satisfied_alt,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            if (!isPersonal) ...[
              const Text(
                "Mandatory Modules",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                // UPDATED ONTAP LOGIC
                onTap: () => _handlePOSHNavigation(context),
                child: _buildProgressCard(),
              ),
            ],

            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }

  // ... rest of your UI helper methods remain the same ...

  // --- UI HELPER METHODS (UNCHANGED EXCEPT FOR UI REFINEMENTS) ---

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
        color: Colors.black,
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
              "FEATURED",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "SWOT\nJournaling",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Analyze your Strengths, Weaknesses, Opportunities, and Threats.",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Text(
                "Start Analysis",
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              "POSH",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Corporate Ethics",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  "MODULE 3 OF 5",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 50,
            child: LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Color(0xFFEEEEEE),
              color: Colors.black,
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
