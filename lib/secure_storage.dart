
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const storage = FlutterSecureStorage();

  static store(StoreKey key, String value) async {
    storage.write(key: key.key, value: value);
  }

  static Future<String?> read(StoreKey key) async {
    return storage.read(key: key.key);
  }

  static delete(StoreKey key) async{
    storage.delete(key: key.key);
  }
}

enum StoreKey{
  userId(key: "USER_ID"),
  noProfile(key: "NO_PROFILE");

  final String key;
  const StoreKey({required this.key});
}