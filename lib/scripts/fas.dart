import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static FlutterSecureStorage? _storage;

  static void initialize() => _storage = const FlutterSecureStorage(
        iOptions: IOSOptions(accessibility: IOSAccessibility.first_unlock),
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  static Future<String?> read(String key) => _storage!.read(key: key);
  static Future<Map<String, String>> readAll() => _storage!.readAll();

  static Future<void> write(String key, String value) =>
      _storage!.write(key: key, value: value);

  static Future<void> delete(String key) => _storage!.delete(key: key);
  static Future<void> deleteAll() => _storage!.deleteAll();
}
