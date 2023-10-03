// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();
final envKey = (key) => kReleaseMode ? key : "${key}_dev";

Future checkPlatformBackup({String? key}) async {
  debugPrint("checkPlatformBackup");
  try {
    if (key?.isNotEmpty ?? false) {
      debugPrint("checkPlatformBackup onKey: ${await readByKey(key!)}");
    }
    String? value = await readByKey("platformbackup");
    debugPrint("checkPlatformBackup: $value");
    if (value?.isEmpty ?? true) await writeValue("platformbackup", "safe");
  } on PlatformException catch (e) {
    debugPrint("onPlatformException\n: ${e.toString()}");
    await storage.deleteAll();
  }
  debugPrint("checkPlatformBackup complete");
}

FutureOr<String?> readByKey(String key) async {
  var _key = envKey(key);
  String? value = await storage.read(key: _key);
  return value;
}

void deleteAll() async {
  await storage.deleteAll();
}

Future writeValue(String key, String? value) async {
  return await storage.write(key: envKey(key), value: value);
}
