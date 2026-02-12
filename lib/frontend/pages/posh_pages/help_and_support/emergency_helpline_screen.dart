import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for Haptic Feedback
import 'package:url_launcher/url_launcher.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  /// Helper to trigger the phone dialer with Haptic Feedback
  Future<void> _makeCall(String phoneNumber) async {
    // Provide physical feedback to the user immediately
    await HapticFeedback.vibrate(); 
    
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Could not launch $phoneNumber';
      }
    } catch (e) {
      debugPrint("Error launching dialer: $e");
    }
  }

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
                    
                    // High-Visibility Status Icon
                    _buildEmergencyHeader(),
                    
                    const SizedBox(height: 32),
                    const Text(
                      "Immediate Assistance",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28, 
                        fontWeight: FontWeight.w900, 
                        letterSpacing: -1.0
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "If you are in immediate danger or require urgent intervention, use the verified helplines below.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Priority Helpline List
                    _buildEmergencyCard(
                      number: "1091",
                      label: "Women's Helpline",
                      description: "Dedicated support for women in distress",
                      iconColor: Colors.purple.shade600,
                      onTap: () => _makeCall("1091"),
                    ),
                    const SizedBox(height: 16),
                    _buildEmergencyCard(
                      number: "112",
                      label: "Emergency (Pan-India)",
                      description: "Police, Fire, and Medical assistance",
                      iconColor: Colors.red.shade700,
                      onTap: () => _makeCall("112"),
                    ),
                    const SizedBox(height: 16),
                    _buildEmergencyCard(
                      number: "181",
                      label: "Domestic Abuse Hotline",
                      description: "Immediate reach for domestic safety",
                      iconColor: Colors.orange.shade700,
                      onTap: () => _makeCall("181"),
                    ),
                  ],
                ),
              ),
            ),
            
            // Fixed Footer with Critical Action
            _buildBottomAction(),
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
        "Emergency Support",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
      ),
    );
  }

  Widget _buildEmergencyHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsing-effect background
        Container(
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            color: Colors.red.shade50.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.red.shade100, width: 2),
          ),
          child: const Icon(
            Icons.notification_important_rounded,
            size: 70,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyCard({
    required String number,
    required String label,
    required String description,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
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
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.phone_forwarded_rounded, color: iconColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        number,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: 0.5),
                      ),
                      Text(
                        label,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87),
                      ),
                      Text(
                        description,
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.call_rounded, color: Colors.green.shade600),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline_rounded, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 6),
              Text(
                "Calls are confidential & location-encrypted",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 65,
            child: ElevatedButton(
              onPressed: () => _makeCall("112"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 4,
                shadowColor: Colors.red.withOpacity(0.4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bolt, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "SOS PANIC BUTTON (112)",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}