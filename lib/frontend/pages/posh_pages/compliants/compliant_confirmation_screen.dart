import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add to pubspec for date formatting
import 'package:first_task_app/frontend/navigation/index.dart';
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Connect to the controller
    final POSHController controller = Get.find<POSHController>();
    
    // Format the current date
    final String submissionDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.offAllNamed('/home'), // Go back to main dashboard
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Success Icon with a soft glow
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_rounded, size: 80, color: Colors.black),
              ),
              const SizedBox(height: 32),
              
              const Text(
                'Submission Successful',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Thank you for coming forward.\nYour report has been securely filed.',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),

              // --- COMPLAINT ID CARD ---
              _buildInfoCard(
                color: Colors.grey.shade50,
                child: Column(
                  children: [
                    Text(
                      'REFERENCE ID',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => Text(
                          controller.lastReportReference.value ?? 'PENDING',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, fontFamily: 'monospace'),
                        )),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: controller.lastReportReference.value ?? ""));
                            Get.snackbar('Copied', 'Reference ID copied to clipboard', 
                              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.black, colorText: Colors.white);
                          },
                        )
                      ],
                    ),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text('Submitted on: $submissionDate', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- NEXT STEPS ---
              _buildInfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('What happens now?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 20),
                    _buildStep(Icons.shield_outlined, 'Your report remains confidential and secure.'),
                    _buildStep(Icons.rate_review_outlined, 'The ICC committee will review the details within 48 hours.'),
                    _buildStep(Icons.notifications_active_outlined, 'You will receive updates via your registered mail.', isLast: true),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- PRIMARY ACTION ---
              ElevatedButton(
                onPressed: () {
                   HapticFeedback.lightImpact();
                   Navigator.pushNamed(context, Routes.complianttracking); // Navigate to progress tracking screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 64),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ),
                child: const Text('Track Progress', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
              ),
              
              const SizedBox(height: 24),
              
              // Privacy Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline_rounded, size: 14, color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Obx(() => Text(
                      controller.isAnonymous.value ? 'Identity: Anonymous' : 'Identity: Verified Reporter',
                      style: const TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.w700),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required Widget child, Color? color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildStep(IconData icon, String text, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800, fontWeight: FontWeight.w500, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}