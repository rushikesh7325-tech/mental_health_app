import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';
import 'doctor_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGrey = Color(0xFFF2F2F2);
    const cardGrey = Color(0xFFE9E9E9);
    const borderGrey = Color(0xFFD6D6D6);

    return Scaffold(
      backgroundColor: primaryGrey,

      appBar: AppBar(
        backgroundColor: primaryGrey,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Admin Dashboard",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(height: 2),
            Text(
              "System Overview",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.notifications_none,
                    size: 26, color: Colors.black),
              ),
              Positioned(
                right: 14,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "3",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10),
                  ),
                ),
              )
            ],
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// STATS ROW 1
            Row(
              children: const [
                Expanded(
                  child: _StatCard(
                      title: "Total Users",
                      value: "12,340",
                      icon: Icons.people_outline),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                      title: "Open POSH Cases",
                      value: "12",
                      icon: Icons.shield_outlined),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// STATS ROW 2
            Row(
              children: const [
                Expanded(
                  child: _StatCard(
                      title: "Doctors",
                      value: "980",
                      icon: Icons.add_circle_outline),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                      title: "Organizations",
                      value: "560",
                      icon: Icons.groups_outlined),
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// SERVER STATUS
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardGrey,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderGrey),
              ),
              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _StatusRow(
                      text:
                          "Server Status: Operational"),
                  SizedBox(height: 6),
                  _StatusRow(
                      text:
                          "Data Sync: Up to date"),
                  SizedBox(height: 6),
                  _StatusRow(
                      text:
                          "Alerts: 3 Pending Approvals"),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// MENU ITEMS
            _MenuTile(
              icon: Icons.people,
              title: "User Management",
              onTap: () {
                MainNavigationScreen.switchTab(
                    context, 1);
              },
            ),

            _MenuTile(
              icon:
                  Icons.medical_services_outlined,
              title: "Doctor Management",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const DoctorScreen(),
                  ),
                );
              },
            ),

            _MenuTile(
              icon: Icons.business_outlined,
              title:
                  "Organization Management",
              onTap: () {
                MainNavigationScreen.switchTab(
                    context, 2);
              },
            ),

            _MenuTile(
              icon:
                  Icons.verified_user_outlined,
              title:
                  "POSH Complaint Monitor",
              onTap: () {
                MainNavigationScreen.switchTab(
                    context, 3);
              },
            ),

            _MenuTile(
              icon: Icons.bar_chart_outlined,
              title:
                  "Reports & Analytics",
              onTap: () {
                MainNavigationScreen.switchTab(
                    context, 4);
              },
            ),

            const SizedBox(height: 16),

            /// ACTION BUTTONS
            Row(
              children: const [
                _SmallActionButton(
                    title: "Add Doctor"),
                SizedBox(width: 8),
                _SmallActionButton(
                    title:
                        "Add Organization"),
                SizedBox(width: 8),
                _SmallActionButton(
                    title:
                        "Send Announcement"),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              "Last data sync: 2 mins ago\nAdmin Role: Super Admin",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}

/// ================= COMPONENTS =================

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            const Color(0xFFE9E9E9),
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight:
                      FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              Text(value,
                  style:
                      const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight
                                  .bold)),
              Icon(icon,
                  color:
                      Colors.black54)
            ],
          )
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String text;
  const _StatusRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
            Icons.check_circle_outline,
            size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text))
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(
              bottom: 12),
      decoration: BoxDecoration(
        color:
            const Color(0xFFE9E9E9),
        borderRadius:
            BorderRadius.circular(
                16),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style:
              const TextStyle(
                  fontWeight:
                      FontWeight.w600),
        ),
        trailing: const Icon(
            Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _SmallActionButton
    extends StatelessWidget {
  final String title;
  const _SmallActionButton(
      {required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets
                .symmetric(
                vertical: 10),
        decoration:
            BoxDecoration(
          borderRadius:
              BorderRadius
                  .circular(20),
          border: Border.all(
              color:
                  Colors.black26),
        ),
        child: Center(
          child: Text(title,
              style:
                  const TextStyle(
                      fontSize:
                          12)),
        ),
      ),
    );
  }
}
