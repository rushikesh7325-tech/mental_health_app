import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../services/company/posh.controller.dart';

class ComplaintTrackingScreen extends StatefulWidget {
  const ComplaintTrackingScreen({super.key});

  @override
  State<ComplaintTrackingScreen> createState() => _ComplaintTrackingScreenState();
}

class _ComplaintTrackingScreenState extends State<ComplaintTrackingScreen> {
  final POSHController controller = Get.find<POSHController>();

  @override
  void initState() {
    super.initState();
    controller.loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text("Case Tracking", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 22)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingReports.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        if (controller.userReports.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.loadReports,
                color: Colors.black,
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.userReports.length,
                  itemBuilder: (context, index) {
                    final report = controller.userReports[index];
                    return _buildModernCard(report);
                  },
                ),
              ),
            ),
            _buildBottomActionArea(),
          ],
        );
      }),
    );
  }

  Widget _buildModernCard(dynamic report) {
    String status = report['status'] ?? 'Submitted';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statusBadge(status),
                    Text(report['ref_id'], style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(report['category'], style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text("Submitted on ${_formatDate(report['submitted_at'])}", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildTimelineStep("Report Submitted", "Your case has been logged securely.", true),
                _buildTimelineStep("Under Investigation", "The ICC committee is reviewing the details.", status != 'Submitted'),
                _buildTimelineStep("Final Resolution", report['admin_remarks'] ?? "Awaiting official response.", status == 'Resolved', isLast: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- NEW: LIVE MESSAGE & CONTINUE AREA ---
  Widget _buildBottomActionArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Message / Support Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble_outline_rounded, color: Colors.blueGrey, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Need immediate help?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text("Message our support team regarding this case.", style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 12)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 12, color: Colors.blueGrey.shade400),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Continue Button
          ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pushNamed(context, '/help1'); // Or navigate to next screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 58),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 0,
            ),
            child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String title, String subtitle, bool isDone, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? Colors.black : Colors.white,
                border: Border.all(color: isDone ? Colors.black : Colors.grey.shade200, width: 2),
              ),
              child: isDone ? const Icon(Icons.check, size: 10, color: Colors.white) : null,
            ),
            if (!isLast)
              Container(width: 2, height: 40, color: isDone ? Colors.black : Colors.grey.shade100),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDone ? Colors.black : Colors.grey.shade400)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: isDone ? Colors.grey.shade600 : Colors.grey.shade300)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    bool isRes = status == 'Resolved';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isRes ? Colors.green.shade50 : Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(status.toUpperCase(), 
        style: TextStyle(color: isRes ? Colors.green.shade700 : Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
    );
  }

  String _formatDate(String dateStr) {
    try {
      return DateFormat('MMM dd, yyyy').format(DateTime.parse(dateStr));
    } catch (_) { return "Recently"; }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_edu_rounded, size: 80, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          const Text("No active cases found", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}