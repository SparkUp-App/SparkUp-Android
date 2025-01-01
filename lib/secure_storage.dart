
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
  noProfile(key: "NO_PROFILE"),
  
  foregroundNewMessage(key: "FOREGROUND_NEW_MESSAGE"),
  foregroundApproveMessage(key: "FOREGROUND_APPROVE_MESSAGE"),
  foregroundRejectMessage(key: "FOREGROUND_REJECT_MESSAGE"),
  foregroundApplyMessage(key: "FOREGROUND_APPLY_MESSAGE"),
  
  backgroundNewMessage(key: "BACKGROUND_NEW_MESSAGE"),
  backgroundApproveMessage(key: "BACKGROUND_APPROVE_MESSAGE"),
  backgroundRejectMessage(key: "BACKGROUND_REJECT_MESSAGE"),
  backgroundApplyMessage(key: "BACKGROUND_APPLY_MESSAGE");

  final String key;
  const StoreKey({required this.key});
}