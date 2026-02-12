import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:first_task_app/frontend/navigation/index.dart';

class PoshPolicyScreen extends StatefulWidget {
  const PoshPolicyScreen({super.key});

  @override
  State<PoshPolicyScreen> createState() => _PoshPolicyScreenState();
}

class _PoshPolicyScreenState extends State<PoshPolicyScreen> {
  // 1. Link to the Controller Bridge
  final POSHController _controller = Get.find<POSHController>();

  final Map<String, Map<String, String>> _policySteps = {
    'verbal': {'name': 'Verbal Harassment', 'route': Routes.poshpolicy8},
    'physical': {'name': 'Physical Harassment', 'route': Routes.poshpolicy9},
    'digital': {'name': 'Visual / Digital Harassment', 'route': Routes.poshpolicy10},
    'workplace': {'name': 'Workplace Definition', 'route': Routes.poshpolicy11},
    'evidence': {'name': 'Upload Evidence', 'route': Routes.poshpolicy12},
  };

  Future<void> _handleNavigation(String key, String routeName) async {
    // Navigate and wait for the "true" result from the sub-module
    final result = await Navigator.of(context).pushNamed(routeName);

    if (result == true) {
      // Save the response to the controller bridge
      _controller.markModuleAsComplete(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 2. Wrap in Obx so the UI updates when the controller data changes
    return Obx(() => Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'POSH Awareness',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildHeaderCard(),
                  const SizedBox(height: 32),
                  Text(
                    'MANDATORY MODULES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade500,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Map modules from the controller's state
                  ..._policySteps.entries.map((entry) {
                    final isDone = _controller.completedModules[entry.key] ?? false;
                    return _buildPolicyItem(
                      entry.value['name']!, 
                      entry.key, 
                      entry.value['route']!,
                      isDone
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildFooterButton(),
        ],
      ),
    ));
  }

  Widget _buildProgressBar() {
    return Container(
      width: double.infinity,
      height: 6,
      color: Colors.grey.shade200,
      child: AnimatedFractionallySizedBox(
        duration: const Duration(milliseconds: 600),
        // Uses the getter from your controller
        widthFactor: _controller.progressPercentage,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.security_rounded, color: Colors.amber, size: 32),
          const SizedBox(height: 16),
          const Text(
            'Zero Tolerance Policy',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete all ${_policySteps.length} sections to understand your rights and the reporting process.',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(String title, String key, String route, bool isDone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleNavigation(key, route),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: isDone ? Colors.green.shade50.withOpacity(0.5) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDone ? Colors.green.shade200 : Colors.grey.shade200,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: isDone ? Colors.green.shade800 : Colors.black87,
                    ),
                  ),
                ),
                isDone
                    ? const Icon(Icons.check_circle, color: Colors.green, size: 24)
                    : const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 62,
        child: ElevatedButton(
          onPressed: _controller.isFlowComplete 
              ? () => Navigator.pushNamed(context, Routes.reportcompliant) 
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
          ),
          child: Text(
            _controller.isFlowComplete ? 'Proceed to Report' : 'Complete All Modules',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      ),
    );
  }
}