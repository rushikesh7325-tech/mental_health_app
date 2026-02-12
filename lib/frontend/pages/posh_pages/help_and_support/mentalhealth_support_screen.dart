import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpSupportScreen4 extends StatelessWidget {
  const HelpSupportScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    // Defining a calming theme color
    const Color primaryWellness = Color(0xFF5C6BC0); // Indigo-ish Teal

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
                    const SizedBox(height: 32),
                    
                    // Relaxing Hero Icon
                    _buildWellnessHero(primaryWellness),
                    
                    const SizedBox(height: 32),
                    const Text(
                      "Mental Health Support",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Your well-being is our priority. Speak confidentially with trained counselors in a safe, non-judgmental environment.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Availability Indicator
                    _buildStatusBanner(),

                    const SizedBox(height: 32),
                    _buildSupportAction(
                      icon: Icons.chat_bubble_rounded,
                      title: "Chat with Counselor",
                      subtitle: "Private, encrypted text session",
                      accentColor: Colors.blue.shade400,
                      onTap: () => HapticFeedback.lightImpact(),
                    ),
                    const SizedBox(height: 16),
                    _buildSupportAction(
                      icon: Icons.phone_callback_rounded,
                      title: "Request a Call",
                      subtitle: "Professional support within 15 mins",
                      accentColor: Colors.teal.shade400,
                      onTap: () => HapticFeedback.lightImpact(),
                    ),
                    const SizedBox(height: 16),
                    _buildSupportAction(
                      icon: Icons.auto_stories_rounded,
                      title: "Self-Help Library",
                      subtitle: "Guided modules for stress & anxiety",
                      accentColor: Colors.orange.shade400,
                      onTap: () => HapticFeedback.lightImpact(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // Reassurance & Primary CTA
            _buildFooter(primaryWellness),
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
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Wellness Hub",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
      ),
    );
  }

  Widget _buildWellnessHero(Color color) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.1), width: 2),
      ),
      child: Icon(
        Icons.spa_rounded, // Changed to Lotus/Spa for a calmer feel
        size: 70,
        color: color,
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(
            "Counselors currently online",
            style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: accentColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.black26),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, -5))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user_rounded, size: 14, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text(
                "100% Anonymous & Secure Sessions",
                style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: const Text(
                "Immediate Counseling",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}