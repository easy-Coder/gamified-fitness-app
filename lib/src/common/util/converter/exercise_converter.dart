import 'package:drift/drift.dart';
import 'package:gamified/src/features/excersice/model/excercise.dart';

class ExerciseConverter extends TypeConverter<Exercise, String> {
  @override
  Exercise fromSql(String fromDb) {
    return Exercise.fromJson(fromDb);
  }

  @override
  String toSql(Exercise value) {
    return value.toJson();
  }
}
