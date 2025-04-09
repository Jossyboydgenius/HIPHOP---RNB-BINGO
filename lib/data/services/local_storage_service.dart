import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../app/locator.dart';

enum LocalStorageKeys {
  accessToken,
  refreshToken,
  userId,
  userProfile,
}

extension LocalStorageKeysExtension on LocalStorageKeys {
  String get value {
    switch (this) {
      case LocalStorageKeys.accessToken:
        return 'access_token';
      case LocalStorageKeys.refreshToken:
        return 'refresh_token';
      case LocalStorageKeys.userId:
        return 'user_id';
      case LocalStorageKeys.userProfile:
        return 'user_profile';
      default:
        return '';
    }
  }
}

class LocalStorageService {
  final FlutterSecureStorage _secureStorage = locator<FlutterSecureStorage>();

  Future<void> setStorageValue(LocalStorageKeys key, String value) async {
    await _secureStorage.write(key: key.value, value: value);
  }

  Future<String?> getStorageValue(LocalStorageKeys key) async {
    return await _secureStorage.read(key: key.value);
  }

  Future<void> removeStorageValue(LocalStorageKeys key) async {
    await _secureStorage.delete(key: key.value);
  }

  Future<void> clearAllValues() async {
    await _secureStorage.deleteAll();
  }
}
