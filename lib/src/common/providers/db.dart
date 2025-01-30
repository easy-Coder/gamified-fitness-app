import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db.g.dart';

@riverpod
Future<Isar> db(Ref ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(schemas: [], directory: dir.path);
}