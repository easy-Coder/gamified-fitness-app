import 'package:drift/drift.dart';
import 'package:gamified/src/common/util/list_converter.dart';

class Exercise extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get force => text().nullable()();
  TextColumn get level => text()();
  TextColumn get mechanic => text().nullable()();
  TextColumn get equipment => text().nullable()();
  TextColumn get primaryMuscles =>
      text().map(StringListTypeConverter()).nullable()();
  TextColumn get secondaryMuscles =>
      text().map(StringListTypeConverter()).nullable()();
  TextColumn get instruction => text().map(StringListTypeConverter())();
  TextColumn get category => text()();
  TextColumn get images => text().map(StringListTypeConverter())();
}
