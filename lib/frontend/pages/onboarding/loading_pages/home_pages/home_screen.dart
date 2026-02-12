import 'package:flutter/material.dart';
import './explore_company_screen.dart';
import './explore_screen.dart';
import 'package:first_task_app/frontend/navigation/index.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  String? _userType;
  bool _isLoading = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initUserRole();
  }

  /// Fetches the user type from the JWT stored in secure storage
  Future<void> _initUserRole() async {
    debugPrint("DEBUG: _initUserRole started...");
    try {
      final type = await _authService.getUserType();
      debugPrint("DEBUG: Received type from service: '$type'");

      setState(() {
        _userType = type;
        _isLoading = false;
      });
      debugPrint("DEBUG: State updated. _userType is now: $_userType");
    } catch (e) {
      debugPrint("DEBUG: Error in _initUserRole: $e");
      setState(() => _isLoading = false);
    }
  }

  // Define the dynamic page list
  // Updated getter in MainNavigationScreen
  // Inside _MainNavigationScreenState
  List<Widget> get _pages {
    Widget exploreView;
    final typeString = _userType?.toString().toLowerCase().trim() ?? "unknown";

    if (typeString == 'company') {
      exploreView = const ExplorePageCompany();
    } else if (typeString == 'personal' || typeString == 'university') {
      // PASS THE TYPE HERE
      exploreView = PersonalExplorePage(userType: typeString);
    } else {
      exploreView = Center(
        child: Text("DEBUG: Unknown User Type: '$typeString'"),
      );
    }

    return [
      const HomeScreenContent(),
      exploreView,
      const Center(child: Text("History Page")),
      const Center(child: Text("Settings Page")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF9166FF)),
        ),
      );
    }
    debugPrint(
      "DEBUG: Building MainNavigation. Current _userType: '$_userType', Selected Index: $_selectedIndex",
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        color: Color(0xFFE8E8E8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home_filled, "Home", 0),
                  _navItem(Icons.explore_outlined, "Explore", 1),
                  const SizedBox(width: 40),
                  _navItem(Icons.calendar_month_outlined, "History", 2),
                  _navItem(Icons.settings_outlined, "Settings", 3),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    "Your data is private and secured",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: -25,
            child: GestureDetector(
              onTap: () {
                // Main Action (e.g., Quick Check-in)
              },
              child: const CircleAvatar(
                radius: 35,
                backgroundColor: Color(0xFF9166FF),
                child: Icon(Icons.add, color: Colors.white, size: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? Colors.black : Colors.grey, size: 28),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

/* ------------------- HOME CONTENT ------------------- */
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildHeader(),
            const SizedBox(height: 25),
            _buildCalendar(),
            const SizedBox(height: 30),
            _buildFocusBox(),
            const SizedBox(height: 30),
            _buildMotivation(),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.arrow_back, color: Colors.black54),
        const Text(
          "Good Afternoon !",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Text("Tue, 20 Jan "),
              Icon(Icons.calendar_month, size: 16, color: Color(0xFF9166FF)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _day("Fri", "30", "😍", false),
        _day("Sat", "31", "😟", false),
        _day("Sun", "01", "😊", true),
        _day("Mon", "02", "", false),
        _day("Tue", "03", "", false),
      ],
    );
  }

  Widget _day(String d, String n, String e, bool active) => Column(
    children: [
      Text(d),
      const SizedBox(height: 5),
      CircleAvatar(
        backgroundColor: active ? const Color(0xFF9166FF) : Colors.transparent,
        child: Text(
          n,
          style: TextStyle(color: active ? Colors.white : Colors.black),
        ),
      ),
      const SizedBox(height: 5),
      Text(e),
    ],
  );

  Widget _buildFocusBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Focus Today",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _chip("Anxiety")),
              const SizedBox(width: 10),
              Expanded(child: _chip("Mindfulness")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String t) => Container(
    height: 60,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(t),
  );

  Widget _buildMotivation() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=200",
            width: 120,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 15),
        const Expanded(
          child: Text(
            "Stay Calm & Mindful\n3-day streak 🔥",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
