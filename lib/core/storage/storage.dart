import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
  encryptedSharedPreferences: true,
);
final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

Future<String?> readStorage({required String key}) async {
 return await storage.read(key: key);
}

Future<void> deleteStorage({required String key}) async {
  await storage.delete(key: key);
}

Future<void> writeStorage({required String key , required String value}) async {
  await storage.write(key: key, value: value);
}