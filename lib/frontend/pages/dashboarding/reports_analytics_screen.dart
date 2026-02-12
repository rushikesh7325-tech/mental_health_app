import 'package:flutter/material.dart';

class ReportsAnalyticsScreen extends StatelessWidget {
  const ReportsAnalyticsScreen({super.key});

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
          "Reports & Analytics",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// SELECT PERIOD BUTTON
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Select Period"),
                    SizedBox(width: 6),
                    Icon(Icons.keyboard_arrow_down, size: 18)
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// DAILY ACTIVE USERS
            _CardContainer(
              title: "Daily Active Users",
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Line Chart Placeholder",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// NEW VS RETURNING
            _CardContainer(
              title: "New Users Vs Returning",
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Bar Chart Placeholder",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// MOOD TRENDS
            _CardContainer(
              title: "Mood Trends",
              child: Column(
                children: const [
                  _ProgressRow(label: "Positive", percent: 0.9),
                  SizedBox(height: 12),
                  _ProgressRow(label: "Negative", percent: 0.6),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// TOP REPORTED CHALLENGES
            _CardContainer(
              title: "Top Reported Challenges",
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: const [
                        _ProgressRow(label: "Stress", percent: 0.85),
                        SizedBox(height: 10),
                        _ProgressRow(label: "Sleep Issues", percent: 0.75),
                        SizedBox(height: 10),
                        _ProgressRow(label: "Anxiety", percent: 0.80),
                        SizedBox(height: 10),
                        _ProgressRow(label: "Work Pressure", percent: 0.70),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black26),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("75%",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 6),
                        Text(
                          "Assessment\nCompletion\nRate",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// SESSIONS BOOKED
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "Sessions Booked",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),

      
    );
  }
}

class _CardContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _CardContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          child
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final double percent;

  const _ProgressRow({required this.label, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label,
              style: const TextStyle(fontSize: 13)),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percent,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
