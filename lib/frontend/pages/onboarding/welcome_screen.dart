
import '../../navigation/index.dart'; 

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Removed the Back Button in AppBar because Welcome is usually the root.
      // If the user can't go back further, a back button can be confusing.
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Prevents default back button
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              "What Brings You Here?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "This is your journey, choose how you want to grow.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            // Option 1: Personal Growth
            _buildActionCard(
              context,
              image: 'assets/images/personal_growth.png',
              routeName: Routes.signup, // Used constant
            ),

            const SizedBox(height: 16),

            // Option 2: Organization
            _buildActionCard(
              context,
              image: 'assets/images/organization.png',
              routeName: Routes.companyVerification, // Used constant
            ),

            const SizedBox(height: 40),
            _buildFooterText(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required String image, required String routeName}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, routeName),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            image, 
            fit: BoxFit.cover,
            // Error builder in case the image path is wrong
            errorBuilder: (context, error, stackTrace) => Container(
              height: 150,
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(fontSize: 12, color: Colors.black54),
          children: [
            TextSpan(text: 'By selecting a path you agree to our\n'),
            TextSpan(
              text: 'Terms of services',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy.',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}