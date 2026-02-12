import 'package:flutter/material.dart';

class ContactOfficerPage extends StatelessWidget {
  const ContactOfficerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? complaintId = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildHeader(complaintId),
            const SizedBox(height: 32),
            
            // Trust & Confidentiality Banner
            _buildConfidentialityCard(),
            
            const SizedBox(height: 32),
            _buildSectionHeader("Contact Channels"),
            const SizedBox(height: 12),

            _buildActionCard(
              icon: Icons.alternate_email_rounded,
              title: "Email IC Coordinator",
              subtitle: "icc@company.com",
              color: Colors.blue.shade700,
              onTap: () {
                // Potential: launchUrl(Uri.parse('mailto:icc@company.com?subject=Inquiry $complaintId'));
              },
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              icon: Icons.chat_bubble_outline_rounded,
              title: "Secure Message Portal",
              subtitle: "Start an encrypted chat with IC members",
              color: Colors.purple.shade700,
              onTap: () {},
            ),

            const SizedBox(height: 40),
            _buildSectionHeader("Support Workflow"),
            const SizedBox(height: 24),
            
            _buildTimelineStep(
              icon: Icons.mark_email_read_outlined, 
              title: "Acknowledgment", 
              desc: "You will receive a secure confirmation within 4 hours.",
              isLast: false,
            ),
            _buildTimelineStep(
              icon: Icons.admin_panel_settings_outlined, 
              title: "IC Review", 
              desc: "The Internal Committee reviews your inquiry under strict privacy.",
              isLast: false,
            ),
            _buildTimelineStep(
              icon: Icons.fact_check_outlined, 
              title: "Resolution", 
              desc: "A response or meeting request is issued via the secure portal.",
              isLast: true,
            ),

            const SizedBox(height: 40),
            _buildSecurityFooter(),
            const SizedBox(height: 40),
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
        "POSH Officer",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
      ),
    );
  }

  Widget _buildHeader(String? id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Get Support",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1.0),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15, height: 1.5),
            children: [
              const TextSpan(text: "Direct access to the Internal Committee for "),
              TextSpan(
                text: id ?? 'General Support',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfidentialityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.verified_user_rounded, color: Colors.blue.shade800, size: 28),
              const SizedBox(width: 12),
              const Text(
                "Privacy Guaranteed",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Your identity and details are shared exclusively with the IC members. No records are accessible to HR or your direct supervisors.",
            style: TextStyle(color: Colors.blue.shade900, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon, 
    required String title, 
    required String subtitle, 
    required Color color,
    required VoidCallback onTap
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
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

  Widget _buildTimelineStep({
    required IconData icon, 
    required String title, 
    required String desc, 
    required bool isLast
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: Colors.grey.shade200, margin: const EdgeInsets.symmetric(vertical: 4)),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4)),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w900,
        fontSize: 11,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildSecurityFooter() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_rounded, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 8),
              Text(
                "AES-256 BIT ENCRYPTION ENABLED",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text("Internal Use Only • Confidential", style: TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}