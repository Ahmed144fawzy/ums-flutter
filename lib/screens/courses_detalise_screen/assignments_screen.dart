import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/network/login.dart';
import '../../core/widget/assignments_due.dart';
import 'assginment_item.dart';

class AssignmentsScreen extends StatefulWidget {
  final String crn;

  const AssignmentsScreen({super.key, required this.crn});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  late Future<List<AssignmentItem>> assignmentsFuture;

  @override
  void initState() {
    super.initState();
    assignmentsFuture = getAssignmentsByCRN(widget.crn);
  }
  String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return DateFormat('dd MMM yyyy').format(date);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AssignmentItem>>(
        future: assignmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No assignments found."));
          }

          final assignments = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final assignment = assignments[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Icon inside circle
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.assignment, color: Colors.black54),
                    ),
                    const SizedBox(width: 12),

                    /// Texts
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Due ${formatDate(assignment.deadline)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            assignment.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            assignment.description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Down arrow
                    const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}