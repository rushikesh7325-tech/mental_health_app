import 'package:flutter/material.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() =>
      _ComplaintsScreenState();
}

class _ComplaintsScreenState
    extends State<ComplaintsScreen> {

  String selectedFilter = "All";
  String searchQuery = "";

  List<ComplaintModel> complaints = [
    ComplaintModel("#101", "Neha Sharma", "Sexual Harassment", ComplaintStatus.active),
    ComplaintModel("#102", "Rahul Verma", "Discrimination", ComplaintStatus.inProgress),
    ComplaintModel("#103", "Swati Kapoor", "Bullying", ComplaintStatus.resolved),
    ComplaintModel("#104", "Anil Roy", "Bullying", ComplaintStatus.resolved),
    ComplaintModel("#105", "Sayli Mehta", "Verbal Harassment", ComplaintStatus.resolved),
  ];

  List<ComplaintModel> getFilteredList() {
    List<ComplaintModel> filtered =
        complaints.where((c) {
      return c.name
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          c.id.contains(searchQuery);
    }).toList();

    if (selectedFilter == "In progress") {
      filtered = filtered
          .where((c) =>
              c.status == ComplaintStatus.inProgress)
          .toList();
    } else if (selectedFilter == "Resolved") {
      filtered = filtered
          .where((c) =>
              c.status == ComplaintStatus.resolved)
          .toList();
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
        leading: const Icon(Icons.arrow_back,
            color: Colors.black),
        title: const Text(
          "Complaint",
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
              child: Icon(Icons.person,
                  size: 18,
                  color: Colors.white),
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
                border:
                    Border.all(color: Colors.black),
                borderRadius:
                    BorderRadius.circular(25),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration:
                    const InputDecoration(
                  hintText:
                      "Search complaints..",
                  prefixIcon:
                      Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(
                          vertical: 14),
                ),
              ),
            ),
          ),

          /// FILTER BUTTONS
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            children: [
              _filterButton("All"),
              _filterButton("In progress"),
              _filterButton("Resolved"),
            ],
          ),

          const SizedBox(height: 16),

          /// LIST
          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(
                      horizontal: 16),
              itemCount:
                  getFilteredList().length,
              itemBuilder:
                  (context, index) {
                final complaint =
                    getFilteredList()[index];

                return Container(
                  margin:
                      const EdgeInsets.only(
                          bottom: 16),
                  padding:
                      const EdgeInsets.all(16),
                  decoration:
                      BoxDecoration(
                    color: cardGrey,
                    borderRadius:
                        BorderRadius.circular(
                            18),
                    border: Border.all(
                        color:
                            Colors.black26),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [

                      /// ID + STATUS
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          Text(
                            complaint.id,
                            style:
                                const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold),
                          ),
                          _statusBadge(
                              complaint
                                  .status),
                        ],
                      ),

                      const SizedBox(
                          height: 8),

                      Text(
                        complaint.name,
                        style:
                            const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                                fontSize: 16),
                      ),

                      const SizedBox(
                          height: 4),

                      Text(
                        complaint.category,
                        style:
                            const TextStyle(
                                fontSize: 13),
                      ),
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
    bool isSelected =
        selectedFilter == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.grey.shade300
              : Colors.transparent,
          border: Border.all(
              color: Colors.black),
          borderRadius:
              BorderRadius.circular(8),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _statusBadge(
      ComplaintStatus status) {
    Color color;
    String text;

    switch (status) {
      case ComplaintStatus.active:
        color = Colors.grey.shade400;
        text = "Active";
        break;
      case ComplaintStatus.inProgress:
        color = Colors.orange.shade200;
        text = "In progress";
        break;
      case ComplaintStatus.resolved:
        color = Colors.grey.shade300;
        text = "Resolved";
        break;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style:
            const TextStyle(fontSize: 12),
      ),
    );
  }
}

/// MODEL

enum ComplaintStatus {
  active,
  inProgress,
  resolved
}

class ComplaintModel {
  final String id;
  final String name;
  final String category;
  ComplaintStatus status;

  ComplaintModel(
      this.id,
      this.name,
      this.category,
      this.status);
}
