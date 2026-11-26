import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:quest_log/core/database/app_database.dart';

AppDatabase createTestDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}
