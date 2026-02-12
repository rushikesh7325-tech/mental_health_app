import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:first_task_app/frontend/navigation/index.dart';

class ComplaintFormScreen extends StatefulWidget {
  const ComplaintFormScreen({super.key});

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final POSHController _controller = Get.find<POSHController>();
  final _formKey = GlobalKey<FormState>();

  // Controllers for text input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final List<String> categories = [
    'Verbal Harassment',
    'Physical Harassment',
    'Visual/Digital Harassment',
    'Other',
  ];

  @override
  void dispose() {
    for (var c in [
      nameController,
      descriptionController,
      dateController,
      timeController,
      locationController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Communicates with the Controller to process the report
/// Communicates with the Controller to process the report
  Future<void> _handleSubmission() async {
    // 1. Validate Form Fields
    if (!_formKey.currentState!.validate()) return;

    // 2. Validate GetX Controller state (Incident Category)
    if (_controller.selectedCategory.value == null) {
      _showSnackBar('Please select an incident category', isError: true);
      return;
    }

    // 3. Trigger Submission in Controller
    // Note: isSubmitting becomes true inside this call, triggering the Obx loading spinner
    final success = await _controller.submitOfficialReport(
      description: descriptionController.text,
      date: dateController.text,
      time: timeController.text,
      location: locationController.text,
      // If anonymous is true, we send null to ensure backend masking
      userName: _controller.isAnonymous.value ? null : nameController.text,
    );

    if (success) {
      HapticFeedback.heavyImpact();

      // 4. Navigate to the Loading Transition screen
      // Use Get.offNamed so the user cannot go "back" to the form after submission
    Navigator.pushNamedAndRemoveUntil(
        context, 
        Routes.compliantloading, 
        (route) => false, // This clears the stack like offAllNamed
      );
    } else {
      _showSnackBar(
        'Submission failed. Please check your connection.',
        isError: true,
      );
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.redAccent : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildHeader(),
                const SizedBox(height: 32),

                Obx(() => _buildIdentityToggle()),
                const SizedBox(height: 32),

                Obx(
                  () => !_controller.isAnonymous.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Your Full Name'),
                            _buildTextField(
                              controller: nameController,
                              hintText: 'John Doe',
                              validator: (v) => v!.isEmpty
                                  ? "Name is required for named reports"
                                  : null,
                            ),
                            const SizedBox(height: 24),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),

                _buildLabel('Incident Category'),
                _buildDropdown(),
                const SizedBox(height: 24),

                _buildLabel('Description'),
                _buildTextField(
                  controller: descriptionController,
                  hintText: 'Provide as much detail as possible...',
                  maxLines: 5,
                  validator: (v) =>
                      v!.length < 10 ? "Please provide more detail" : null,
                ),
                const SizedBox(height: 24),

                _buildLabel('Date & Time'),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: dateController,
                        hintText: 'Date',
                        suffixIcon: Icons.calendar_today_outlined,
                        onTap: () => _selectDate(context),
                        validator: (v) => v!.isEmpty ? "Required" : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: timeController,
                        hintText: 'Time',
                        suffixIcon: Icons.access_time,
                        onTap: () => _selectTime(context),
                        validator: (v) => v!.isEmpty ? "Required" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildLabel('Specific Location'),
                _buildTextField(
                  controller: locationController,
                  hintText: 'e.g. Conference Room B',
                  validator: (v) => v!.isEmpty ? "Location is required" : null,
                ),

                const SizedBox(height: 48),
                Obx(() => _buildActionButtons()),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => Get.back(), // GetX style back navigation
      ),
      title: const Text(
        'Report Incident',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Submission Form',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Detailed reports help the Internal Complaints Committee (ICC) investigate effectively.',
          style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildIdentityToggle() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _toggleItem(
              'Anonymous',
              _controller.isAnonymous.value,
              () => _controller.isAnonymous.value = true,
            ),
          ),
          Expanded(
            child: _toggleItem(
              'Named',
              !_controller.isAnonymous.value,
              () => _controller.isAnonymous.value = false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleItem(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: active ? FontWeight.bold : FontWeight.w600,
              color: active ? Colors.black : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: Colors.grey.shade600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    IconData? suffixIcon,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: onTap != null,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, size: 18, color: Colors.black54)
            : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _controller.selectedCategory.value,
            isExpanded: true,
            hint: Text(
              'Choose category',
              style: TextStyle(color: Colors.grey.shade400),
            ),
            items: categories
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Text(
                      c,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) => _controller.selectedCategory.value = val,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton(
            onPressed: _controller.isSubmitting.value
                ? null
                : _handleSubmission,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
            ),
            child: _controller.isSubmitting.value
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Submit Official Report',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => _showSnackBar('Draft saved successfully'),
          child: Text(
            'Save as Draft',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.black,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      dateController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.black),
        ),
        child: child!,
      ),
    );
    if (picked != null) timeController.text = picked.format(context);
  }
}
