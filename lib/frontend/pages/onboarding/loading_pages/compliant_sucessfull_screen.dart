import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:first_task_app/frontend/navigation/index.dart';
class ComplaintRegisteredLoadingScreen extends StatefulWidget {
  const ComplaintRegisteredLoadingScreen({super.key});

  @override
  State<ComplaintRegisteredLoadingScreen> createState() => _ComplaintRegisteredLoadingScreenState();
}

class _ComplaintRegisteredLoadingScreenState extends State<ComplaintRegisteredLoadingScreen> {
  final POSHController _controller = Get.find<POSHController>();

  @override
  void initState() {
    super.initState();
    _startTransition();
  }

  void _startTransition() async {
    // 1. Give the user a moment to see the "Registered" status (Psychological satisfaction)
    await Future.delayed(const Duration(seconds: 2));

    // 2. Add a light haptic tap to signal completion
    HapticFeedback.mediumImpact();

    // 3. Navigate to the Success/Reference ID screen
    // We pass the reference ID as an argument, or the success screen can pull it from the controller
    Navigator.pushNamedAndRemoveUntil(
        context, 
        Routes.compliantsucess, 
        (route) => false, // This clears the stack like offAllNamed
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Spinner with a bit more flair
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: CircularProgressIndicator(
                        value: value < 0.9 ? null : 1.0, // Switch from indeterminate to fixed
                        strokeWidth: 8,
                        color: Colors.black,
                        strokeCap: StrokeCap.round,
                        backgroundColor: Colors.grey.shade100,
                      ),
                    ),
                    if (value >= 0.9)
                      const Icon(Icons.check_circle, color: Colors.black, size: 40),
                  ],
                );
              },
            ),
            const SizedBox(height: 48),
            
            // Text Header
            const Text(
              'Complaint Registered!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 16),
            
            // Subtext - Connects to the Controller logic
            Obx(() => Text(
              _controller.isAnonymous.value 
                ? 'Your identity is protected. Generating your secure reference ID...'
                : 'Processing your report. Connecting with the ICC team...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade500,
                height: 1.4,
              ),
            )),
          ],
        ),
      ),
    );
  }
}