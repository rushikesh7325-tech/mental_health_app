import 'package:first_task_app/frontend/navigation/index.dart';

class UniversityVerification extends StatefulWidget {
  const UniversityVerification({super.key});

  @override
  State<UniversityVerification> createState() => _UniversityVerificationState();
}

class _UniversityVerificationState extends State<UniversityVerification> {
  final TextEditingController universityController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  bool isButtonEnabled = false;

  void checkFields() {
    setState(() {
      isButtonEnabled =
          universityController.text.trim().isNotEmpty &&
          codeController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    universityController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Student Verification",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // 🔹 Academic Icon Header
              Container(
                height: 90,
                width: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.school_outlined,
                  size: 36,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                "Verify Student Status",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Access your university's wellness benefits privately. Your academic record remains untouched.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 Modern Input Card
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel("University Name"),
                  _inputField(
                    hint: 'e.g. Stanford University',
                    icon: Icons.account_balance_outlined,
                    controller: universityController,
                  ),

                  const SizedBox(height: 24),
                  _fieldLabel("Student Code or Edu Email"),
                  _inputField(
                    hint: 'e.g. STU987 or name@uni.edu',
                    icon: Icons.alternate_email_rounded,
                    controller: codeController,
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () => 
                            Navigator.pushNamed(
                              context,
                              Routes.uniSignUp,
                              arguments: {
                                'university_name': universityController.text
                                    .trim(),
                                'verification_code': codeController.text.trim(),
                              },
                            )
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isButtonEnabled
                            ? Colors.black
                            : const Color(0xFFE0E0E0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildSecureFooter(),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSecureFooter() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield_outlined, size: 14, color: Colors.grey.shade400),
            const SizedBox(width: 6),
            Text(
              "SECURE STUDENT VERIFICATION",
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: TextField(
        controller: controller,
        onChanged: (_) => checkFields(),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black45, size: 20),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26, fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}
