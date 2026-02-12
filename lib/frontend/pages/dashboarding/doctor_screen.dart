import 'package:flutter/material.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  String searchQuery = "";

  List<DoctorModel> doctors = [
    DoctorModel("Dr. Jenny Whitman", "Cardiologist", 4.9, 200, DoctorStatus.active),
    DoctorModel("Dr. Amit Desai", "Family Medicine", 4.6, 150, DoctorStatus.pending),
    DoctorModel("Dr. Rajesh Bhandari", "Psychiatrist", 4.9, 210, DoctorStatus.active),
    DoctorModel("Dr. Gargi Wigham", "Pediatrician", 4.8, 175, DoctorStatus.suspended),
    DoctorModel("Dr. Tanya Verma", "Dermatologist", 4.6, 150, DoctorStatus.active),
    DoctorModel("Dr. Stebin William", "OB-GYN", 4.6, 187, DoctorStatus.active),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  List<DoctorModel> getFilteredDoctors() {
    List<DoctorModel> filtered = doctors.where((doctor) {
      return doctor.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    if (_tabController.index == 1) {
      filtered = filtered.where((d) => d.status == DoctorStatus.active).toList();
    } else if (_tabController.index == 2) {
      filtered = filtered.where((d) => d.status == DoctorStatus.suspended).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    const primaryGrey = Color(0xFFF2F2F2);

    return Scaffold(
      backgroundColor: primaryGrey,
      appBar: AppBar(
        backgroundColor: primaryGrey,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Doctor",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black),
        ),
      ),

      body: Column(
        children: [

          /// SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE9E9E9),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Search doctors...",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          /// TABS
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            onTap: (_) => setState(() {}),
            tabs: const [
              Tab(text: "All"),
              Tab(text: "Active"),
              Tab(text: "Suspended"),
            ],
          ),

          /// LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: getFilteredDoctors().length,
              itemBuilder: (context, index) {
                final doctor = getFilteredDoctors()[index];

                return Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person_outline,
                              color: Colors.black),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(doctor.name,
                                  style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(doctor.specialization,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                      "${doctor.rating} (${doctor.reviews} Reviews)",
                                      style: const TextStyle(
                                          fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _statusBadge(doctor.status),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _statusBadge(DoctorStatus status) {
    Color color;
    String text;

    switch (status) {
      case DoctorStatus.active:
        color = Colors.green.shade200;
        text = "View";
        break;
      case DoctorStatus.pending:
        color = Colors.orange.shade200;
        text = "Pending";
        break;
      case DoctorStatus.suspended:
        color = Colors.red.shade200;
        text = "Suspended";
        break;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 12)),
    );
  }
}

enum DoctorStatus { active, pending, suspended }

class DoctorModel {
  final String name;
  final String specialization;
  final double rating;
  final int reviews;
  DoctorStatus status;

  DoctorModel(this.name, this.specialization,
      this.rating, this.reviews, this.status);
}
