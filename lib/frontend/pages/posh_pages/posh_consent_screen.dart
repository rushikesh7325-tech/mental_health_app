import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:first_task_app/frontend/navigation/index.dart';
// Assuming your controller and routes are in these locations
// import 'package:firstproduction_pro/controllers/posh_controller.dart'; 

class PoshAwarenessScreen extends StatefulWidget {
  const PoshAwarenessScreen({super.key});

  @override
  State<PoshAwarenessScreen> createState() => _PoshAwarenessScreenState();
}

class _PoshAwarenessScreenState extends State<PoshAwarenessScreen> {
  // Initialize the bridge
  final POSHController _controller = Get.put(POSHController());

// In the Screen
void _onContinue() {
  if (_controller.canProceed) {
    _controller.saveInitialConsent(); // Persists/Finalizes the state
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, Routes.poshpolicy);
  }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildHeader(theme),
                    const SizedBox(height: 32),
                    _buildHeroIllustration(),
                    const SizedBox(height: 32),
                    _buildInfoCard(),
                    const SizedBox(height: 16),
                    _buildHighlightsCard(theme),
                    const SizedBox(height: 32),
                    _buildRulesSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            // Wrap the footer in Obx so it reacts to the bridge data
            Obx(() => _buildFooter(theme)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Policy Overview",
        style: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'POSH Awareness\n& Consent',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1A1C1E),
            height: 1.1,
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Our workplace is committed to a zero-tolerance policy against any form of sexual harassment.',
          style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildHeroIllustration() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background decorative elements
          Positioned(
            right: -20, top: -20,
            child: CircleAvatar(radius: 50, backgroundColor: Colors.blue.shade100.withOpacity(0.5)),
          ),
          // Placeholder for an SVG/Image illustration
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.diversity_3_rounded, size: 60, color: Colors.blue.shade700),
              const SizedBox(height: 12),
              const Text("Safe Workplace for All", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return _StyledCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
            child: Icon(Icons.verified_user_outlined, color: Colors.blue.shade700, size: 20),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Applicable to all employees, vendors, and visitors at our premises.',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightsCard(ThemeData theme) {
    return _StyledCard(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What constitutes harassment?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          const SizedBox(height: 20),
          const _BulletItem('Unwelcome physical advances or contact.'),
          const _BulletItem('Demand or request for sexual favors.'),
          const _BulletItem('Making sexually colored remarks or jokes.'),
          const _BulletItem('Showing pornography or suggestive visuals.'),
        ],
      ),
    );
  }

  Widget _buildRulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'COMMITMENT TO YOU',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.blue.shade900),
          ),
        ),
        const SizedBox(height: 16),
        const _CheckItem('100% Confidential Inquiry Process'),
        const _CheckItem('Protection against Retaliation'),
        const _CheckItem('Time-bound Case Resolution'),
      ],
    );
  }

Widget _buildFooter(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 20, 
            offset: const Offset(0, -10)
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              // Toggle data in the bridge
              _controller.setInitialConsent(!_controller.isAcknowledgeAccepted.value);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    height: 24, width: 24,
                    child: Checkbox(
                      // Bind directly to bridge
                      value: _controller.isAcknowledgeAccepted.value,
                      activeColor: Colors.blue.shade800,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      onChanged: (v) => _controller.setInitialConsent(v ?? false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'I acknowledge and accept the POSH guidelines.',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF424242)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              // Check proceed status from bridge
              onPressed: _controller.canProceed ? _onContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1C1E),
                disabledBackgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: Text(
                'Enter POSH Portal',
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold, 
                  color: _controller.canProceed ? Colors.white : Colors.grey.shade500
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Support widgets (Bullets, Styled Cards) remain consistent with your design
// --- Refined Supporting Widgets ---

class _StyledCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  const _StyledCard({required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2), // Ghost border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String text;
  const _CheckItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}