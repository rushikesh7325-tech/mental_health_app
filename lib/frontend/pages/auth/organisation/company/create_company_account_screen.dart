import 'package:first_task_app/frontend/navigation/index.dart'; // Ensure this contains your Routes

class CompanyCreateAccountScreen extends StatefulWidget {
  const CompanyCreateAccountScreen({super.key});

  @override
  State<CompanyCreateAccountScreen> createState() =>
      _CompanyCreateAccountScreenState();
}

class _CompanyCreateAccountScreenState
    extends State<CompanyCreateAccountScreen> {
  bool _isPasswordVisible = false;
  bool _isFormValid = false;
  bool _isLoading = false;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _orgController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _orgController.addListener(_validateForm);
    _roleController.addListener(_validateForm);

    // Autofill the organization name if passed from arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('company_name')) {
        _orgController.text = args['company_name'];
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _orgController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final bool isValid =
        _nameController.text.trim().isNotEmpty &&
        _emailController.text.contains('@') &&
        _passwordController.text.length >= 6 &&
        _orgController.text.trim().isNotEmpty &&
        _roleController.text.trim().isNotEmpty;

    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  // --- BACKEND INTEGRATION HANDLER ---
  Future<void> _handleSignUp() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    setState(() => _isLoading = true);

    try {
      await AuthService().register(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: "", // Add a controller if phone is required
        password: _passwordController.text,
        userType: 'company',
        extraData: {
          'company_name': _orgController.text.trim(),
          'org_code': args?['org_code'] ?? "",
          'role': _roleController.text.trim(),
        },
      );

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.login,
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Company Account created! Please log in."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
        title: const Text(
          'Company Sign Up',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Join Your Organization",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Complete your profile to access company resources.",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 30),

            _buildLabel("Full Name"),
            _buildTextField(
              _nameController,
              "e.g. John Doe",
              Icons.person_outline,
            ),

            const SizedBox(height: 18),
            _buildLabel("Work Email"),
            _buildTextField(
              _emailController,
              "name@company.com",
              Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 18),
            _buildLabel("Company Name"),
            _buildTextField(
              _orgController,
              "Organization Name",
              Icons.business_outlined,
              readOnly: true,
            ),

            const SizedBox(height: 18),
            _buildLabel("Your Role"),
            _buildTextField(
              _roleController,
              "e.g. HR Manager / Employee",
              Icons.badge_outlined,
            ),

            const SizedBox(height: 18),
            _buildLabel("Create Password"),
            _buildTextField(
              _passwordController,
              "••••••••",
              Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 40),
            _buildMainButton(),

            const SizedBox(height: 30),
            _buildSocialDivider(),

            const SizedBox(height: 20),
            _buildSocialButton(
              "Google",
              logo: const Icon(Icons.g_mobiledata, size: 30, color: Colors.red),
            ),

            const SizedBox(height: 40),
            _buildFooter(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- UI HELPER METHODS ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPassword = false,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: readOnly ? Colors.grey.shade50 : const Color(0xFFF9F9FB),
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
  }

  Widget _buildMainButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: _isFormValid && !_isLoading
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: (_isFormValid && !_isLoading) ? _handleSignUp : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildSocialDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "OR SIGN UP WITH",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialButton(String provider, {required Widget logo}) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          logo,
          const SizedBox(width: 10),
          Text(
            "Continue with $provider",
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, Routes.login),
        child: RichText(
          text: const TextSpan(
            text: 'Already have an account? ',
            style: TextStyle(color: Colors.grey, fontSize: 15),
            children: [
              TextSpan(
                text: 'Log In',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
