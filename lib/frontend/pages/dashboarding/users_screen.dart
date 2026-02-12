import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  String _searchQuery = "";

  List<UserModel> users = [
    UserModel("Ankita Joshi", "ankitajoshi@gmail.com", "Amazon India", true),
    UserModel("Rohit Shinde", "rohitshinde@tcs.com", "TCS", true),
    UserModel("Neha Patil", "nehapatil@gmail.com", "Infosys", false),
    UserModel("Aditya Kulkarni", "adityakulkarni@gmail.com", "Wipro", true),
    UserModel("Karan Mehta", "karanmehta@gmail.com", "Deloitte", true),
    UserModel("Sneha Iyer", "sneha@gmail.com", "HCL", false),
    UserModel("Rahul Nair", "rahuliyer@gmail.com", "Accenture", false),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  List<UserModel> getFilteredUsers() {
    List<UserModel> filtered = users.where((user) {
      return user.name
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();

    if (_tabController.index == 1) {
      filtered = filtered.where((u) => u.isActive).toList();
    } else if (_tabController.index == 2) {
      filtered = filtered.where((u) => !u.isActive).toList();
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
          "User",
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

          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: cardGrey,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
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

          /// USER LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: getFilteredUsers().length,
              itemBuilder: (context, index) {
                final user = getFilteredUsers()[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardGrey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [

                      /// AVATAR
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person_outline,
                            color: Colors.black),
                      ),

                      const SizedBox(width: 12),

                      /// DETAILS
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(user.name,
                                style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(user.email,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(
                                "Employee · ${user.organization} · ${user.isActive ? "Active" : "Suspended"}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey)),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// ACTION BUTTON
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: user.isActive
                                  ? Colors.grey.shade300
                                  : Colors.blue,
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6),
                            ),
                            onPressed: () {
                              setState(() {
                                user.isActive =
                                    !user.isActive;
                              });
                            },
                            child: Text(
                              user.isActive
                                  ? "Suspend"
                                  : "Active",
                              style: TextStyle(
                                fontSize: 12,
                                color: user.isActive
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// MODEL
class UserModel {
  final String name;
  final String email;
  final String organization;
  bool isActive;

  UserModel(
      this.name, this.email, this.organization, this.isActive);
}
