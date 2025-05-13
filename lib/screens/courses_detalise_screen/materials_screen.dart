import 'package:flutter/material.dart';
import 'package:unviersty_system/core/widget/lecture_card.dart';
import 'material_item.dart';
import '../../core/network/login.dart';

class MaterialsScreen extends StatefulWidget {
  final String crn;

  const MaterialsScreen({super.key, required this.crn});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  late Future<List<MaterialItem>> materialsFuture;

  @override
  void initState() {
    super.initState();
    materialsFuture = getMaterialsByCRN(widget.crn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<MaterialItem>>(
        future: materialsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("❌ Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No materials available."));
          }

          final materials = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.only(top: 16, bottom: 24),
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final item = materials[index];
              return LectureCard(
                title: item.fileName,
                description: item.description,
                fileUrl: item.filePath,
                commentsCount: item.commentsCount ?? 0,
              );
            },
          );
        },
      ),
    );
  }
}
