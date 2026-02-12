import 'package:flutter/material.dart';
import 'admin_dashboard_screen.dart';
import 'users_screen.dart';
import 'organization_screen.dart';
import 'complaints_screen.dart';
import 'reports_analytics_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  /// ✅ THIS METHOD WAS MISSING
  static void switchTab(BuildContext context, int index) {
    final state =
        context.findAncestorStateOfType<_MainNavigationScreenState>();
    state?._changeTab(index);
  }

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {

  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    AdminDashboardScreen(),
    UsersScreen(),
    OrganizationScreen(),
    ComplaintsScreen(),
    ReportsAnalyticsScreen(),
  ];

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _changeTab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Users"),
          BottomNavigationBarItem(
              icon: Icon(Icons.apartment_outlined),
              label: "Organizations"),
          BottomNavigationBarItem(
              icon: Icon(Icons.gavel_outlined),
              label: "Complaints"),
          BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              label: "Reports"),
        ],
      ),
    );
  }
}
