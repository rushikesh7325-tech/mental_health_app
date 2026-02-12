import 'package:flutter/material.dart';
import 'package:first_task_app/frontend/navigation/index.dart';

// 1. Data Model for Support Items
class SupportItem {
  final IconData icon;
  final String title;
  final String? routeName;
  final String section;

  SupportItem({
    required this.icon,
    required this.title,
    this.routeName,
    required this.section,
  });
}

class HelpHomeScreen extends StatefulWidget {
  const HelpHomeScreen({super.key});

  @override
  State<HelpHomeScreen> createState() => _HelpHomeScreenState();
}

class _HelpHomeScreenState extends State<HelpHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // 2. Centralized List of Resources
  final List<SupportItem> _allResources = [
    SupportItem(icon: Icons.person_search_outlined, title: "POSH Officer", routeName: Routes.help2, section: "Support Channels"),
    SupportItem(icon: Icons.phone_in_talk_outlined, title: "Emergency Helpline", routeName: Routes.help3, section: "Support Channels"),
    SupportItem(icon: Icons.psychology_outlined, title: "Mental Health Support", routeName: Routes.help4, section: "Support Channels"),
    SupportItem(icon: Icons.gavel_outlined, title: "Report Retaliation", routeName: Routes.help5, section: "Support Channels"),
    SupportItem(icon: Icons.shield_outlined, title: "Workplace Safety", routeName: Routes.help6, section: "Safety Resources"),
    SupportItem(icon: Icons.menu_book_outlined, title: "Anti-Harassment Policy", routeName: Routes.poshpolicy, section: "Safety Resources"),
    SupportItem(icon: Icons.favorite_border_rounded, title: "Mental Wellness", section: "Safety Resources"),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? complaintId = ModalRoute.of(context)?.settings.arguments as String?;

    // 3. Filtering Logic
    final filteredResources = _allResources.where((item) {
      return item.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 35),
            if (filteredResources.isEmpty)
              const Center(child: Text("No resources found."))
            else
              ..._buildGroupedSections(context, filteredResources, complaintId),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Sub-Widgets ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: _buildCircleBackButton(context),
      title: const Text(
        "Help and Support",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 22),
      ),
    );
  }

  Widget _buildCircleBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _searchQuery = value),
      decoration: InputDecoration(
        hintText: 'Search support topics...',
        prefixIcon: const Icon(Icons.search, color: Colors.black54),
        suffixIcon: _searchQuery.isNotEmpty 
            ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = "");
              }) 
            : null,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  List<Widget> _buildGroupedSections(BuildContext context, List<SupportItem> items, String? complaintId) {
    final sections = items.map((e) => e.section).toSet().toList();
    return sections.map((section) {
      final sectionItems = items.where((item) => item.section == section).toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(section),
          ...sectionItems.map((item) => _buildTile(context, item, complaintId)),
          const SizedBox(height: 20),
        ],
      );
    }).toList();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w800,
          fontSize: 13,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, SupportItem item, String? complaintId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.04),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(item.icon, color: Colors.black, size: 24),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black26, size: 16),
        onTap: () {
          if (item.routeName != null) {
            Navigator.pushNamed(context, item.routeName!, arguments: complaintId);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Resource coming soon!"), behavior: SnackBarBehavior.floating),
            );
          }
        },
      ),
    );
  }
}