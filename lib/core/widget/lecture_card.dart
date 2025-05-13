import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unviersty_system/core/colors/app_colors.dart';

class LectureCard extends StatelessWidget {
  final String title;
  final String description;
  final String fileUrl;
  final int commentsCount;

  const LectureCard({
    super.key,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.commentsCount,
  });
  Future<void> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) return;

    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      // الصلاحية مرفوضة
      print("Permission Denied");
    }
  }

  Future<void> _downloadFile(BuildContext context) async {
    try {
      // اطلب صلاحية التخزين
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Storage permission denied")),
        );
        return;
      }

      // احصل على المسار
      final dir = await getExternalStorageDirectory();
      final savePath = '${dir!.path}/$title';

      // نزّل الملف
      Dio dio = Dio();
      await dio.download(fileUrl, savePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Downloaded to: $savePath")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Download failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Row for icon + title + download icon
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.lightGrey,
                child: Icon(Icons.picture_as_pdf, color: Colors.black),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Janna',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.download, color: AppColors.blue),
                onPressed: () => _downloadFile(context), // ✅ زر التحميل
              ),
            ],
          ),

          /// Description
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
              ),
            ),
          ),

          const SizedBox(height: 6),

          /// Add Comment Field + Send Button
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    hintText: "Add Comment",
                    hintStyle: const TextStyle(fontFamily: 'Janna'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// Comments count
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              "$commentsCount Comments",
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontFamily: 'Janna',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
