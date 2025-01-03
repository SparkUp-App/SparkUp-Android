import 'package:spark_up/secure_storage.dart';

class NotificationManager {
  static bool allowNotification = true;

  static bool foregroundNewMessage = true;
  static bool foregroundApproveMessage = true;
  static bool foregroundRejectMessage = true;
  static bool foregroundApplyMessage = true;

  static bool backgroundNewMessage = true;
  static bool backgroundApproveMessage = true;
  static bool backgroundRejectMessage = true;
  static bool backgroundApplyMessage = true;

  static init() {
    SecureStorage.read(StoreKey.allowNotification).then((value) {
      allowNotification = value == "true" || value == null;
    });
    SecureStorage.read(StoreKey.foregroundNewMessage).then((value) {
      foregroundNewMessage = value == "true" || value == null;
    });
    SecureStorage.read(StoreKey.foregroundApproveMessage).then((value) {
      foregroundApproveMessage = value == "true" || value == null;
    });
    SecureStorage.read(StoreKey.foregroundRejectMessage).then((value) {
      foregroundRejectMessage = value == "true" || value == null;
    });
    SecureStorage.read(StoreKey.foregroundApplyMessage).then((value) {
      foregroundApplyMessage = value == "true" || value == null;
    });
    SecureStorage.read(StoreKey.backgroundNewMessage).then((value) {
      backgroundNewMessage = value == "true" || value == null;
    });
    SecureStorage.read(StoreKey.backgroundApproveMessage).then((value) {
      backgroundApproveMessage = value == "true" || value == null;
    });
    SecureStorage.read(StoreKey.backgroundRejectMessage).then((value) {
      backgroundRejectMessage = value == "true" || value == null;
    });
    SecureStorage.read(StoreKey.backgroundApplyMessage).then((value) {
      backgroundApplyMessage = value == "true" || value == null;
    });
    allowNotificationCheck();
  }

  static reset() {
    allowNotification = true;

    foregroundNewMessage = true;
    foregroundApproveMessage = true;
    foregroundRejectMessage = true;
    foregroundApplyMessage = true;

    backgroundNewMessage = true;
    backgroundApproveMessage = true;
    backgroundRejectMessage = true;
    backgroundApplyMessage = true;

    SecureStorage.store(StoreKey.foregroundNewMessage, "true");
    SecureStorage.store(StoreKey.foregroundApproveMessage, "true");
    SecureStorage.store(StoreKey.foregroundRejectMessage, "true");
    SecureStorage.store(StoreKey.foregroundApplyMessage, "true");

    SecureStorage.store(StoreKey.backgroundNewMessage, "true");
    SecureStorage.store(StoreKey.backgroundApproveMessage, "true");
    SecureStorage.store(StoreKey.backgroundRejectMessage, "true");
    SecureStorage.store(StoreKey.backgroundApplyMessage, "true");
  }

  static setNotification(StoreKey key) async {
    switch(key){
      case StoreKey.foregroundNewMessage:
        foregroundNewMessage = !foregroundNewMessage;
        SecureStorage.store(key, foregroundNewMessage.toString());
        break;
      case StoreKey.foregroundApproveMessage:
        foregroundApproveMessage = !foregroundApproveMessage;
        SecureStorage.store(key, foregroundApproveMessage.toString());
        break;
      case StoreKey.foregroundRejectMessage:
        foregroundRejectMessage = !foregroundRejectMessage;
        SecureStorage.store(key, foregroundRejectMessage.toString());
        break;
      case StoreKey.foregroundApplyMessage:
        foregroundApplyMessage = !foregroundApplyMessage;
        SecureStorage.store(key, foregroundApplyMessage.toString());
        break;
      case StoreKey.backgroundNewMessage:
        backgroundNewMessage = !backgroundNewMessage;
        SecureStorage.store(key, backgroundNewMessage.toString());
        break;
      case StoreKey.backgroundApproveMessage:
        backgroundApproveMessage = !backgroundApproveMessage;
        SecureStorage.store(key, backgroundApproveMessage.toString());
        break;
      case StoreKey.backgroundRejectMessage:
        backgroundRejectMessage = !backgroundRejectMessage;
        SecureStorage.store(key, backgroundRejectMessage.toString());
        break;
      case StoreKey.backgroundApplyMessage:
        backgroundApplyMessage = !backgroundApplyMessage;
        SecureStorage.store(key, backgroundApplyMessage.toString());
        break;
      case StoreKey.allowNotification:
        allowNotification = !allowNotification;
        foregroundNewMessage = allowNotification;
        foregroundApproveMessage = allowNotification;
        foregroundRejectMessage = allowNotification;
        foregroundApplyMessage = allowNotification;
        backgroundNewMessage = allowNotification;
        backgroundApproveMessage = allowNotification;
        backgroundRejectMessage = allowNotification;
        backgroundApplyMessage = allowNotification;
        SecureStorage.store(StoreKey.foregroundNewMessage, allowNotification.toString());
        SecureStorage.store(StoreKey.foregroundApproveMessage, allowNotification.toString());
        SecureStorage.store(StoreKey.foregroundRejectMessage, allowNotification.toString());
        SecureStorage.store(StoreKey.foregroundApplyMessage, allowNotification.toString());
        SecureStorage.store(StoreKey.backgroundNewMessage, allowNotification.toString());
        SecureStorage.store(StoreKey.backgroundApproveMessage, allowNotification.toString());
        SecureStorage.store(StoreKey.backgroundRejectMessage, allowNotification.toString());
        SecureStorage.store(StoreKey.backgroundApplyMessage, allowNotification.toString());
        SecureStorage.store(key, allowNotification.toString());
        break;
      default:
        break;
    }
    allowNotificationCheck();
  }

  static allowNotificationCheck(){
    if(foregroundNewMessage || foregroundApproveMessage || foregroundRejectMessage || foregroundApplyMessage || backgroundNewMessage || backgroundApproveMessage || backgroundRejectMessage || backgroundApplyMessage){
      allowNotification = true;
      SecureStorage.store(StoreKey.allowNotification, "true");
    } else {
      allowNotification = false;
      SecureStorage.store(StoreKey.allowNotification, "false");
    }
  }
}
