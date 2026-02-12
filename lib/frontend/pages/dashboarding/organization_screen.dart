import 'package:flutter/material.dart';

class OrganizationScreen extends StatefulWidget {
  const OrganizationScreen({super.key});

  @override
  State<OrganizationScreen> createState() =>
      _OrganizationScreenState();
}

class _OrganizationScreenState
    extends State<OrganizationScreen> {

  String selectedFilter = "All";
  String searchQuery = "";

  List<OrganizationModel> organizations = [
    OrganizationModel("Stellar Industries", 245, true),
    OrganizationModel("MedianTech Solutions", 1150, true),
    OrganizationModel("Richard Pvt.LTD", 89, false),
    OrganizationModel("KraftTech Solutions", 501, true),
    OrganizationModel("CareASA Company", 9085, true),
  ];

  List<OrganizationModel> getFilteredList() {
    List<OrganizationModel> filtered =
        organizations.where((org) {
      return org.name
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

    if (selectedFilter == "Active") {
      filtered = filtered.where((o) => o.isActive).toList();
    } else if (selectedFilter == "Suspended") {
      filtered = filtered.where((o) => !o.isActive).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    const primaryGrey = Color(0xFFF2F2F2);
    const cardGrey = Color(0xFFE9E9E9);

    return Scaffold(
      backgroundColor: primaryGrey,
      appBar: AppBar(
        backgroundColor: primaryGrey,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "Organization",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
          )
        ],
      ),

      body: Column(
        children: [

          /// SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Search Organizations..",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          /// FILTER BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _filterButton("All"),
              _filterButton("Active"),
              _filterButton("Suspended"),
            ],
          ),

          const SizedBox(height: 16),

          /// LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: getFilteredList().length,
              itemBuilder: (context, index) {
                final org = getFilteredList()[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardGrey,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(org.name,
                                style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 16)),
                            const SizedBox(height: 6),
                            Text("Users    ${org.users}",
                                style: const TextStyle(
                                    fontSize: 13)),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.work_outline),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _filterButton(String title) {
    bool isSelected = selectedFilter == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.grey.shade300
              : Colors.transparent,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(title),
      ),
    );
  }
}

/// MODEL

class OrganizationModel {
  final String name;
  final int users;
  final bool isActive;

  OrganizationModel(this.name, this.users, this.isActive);
}
