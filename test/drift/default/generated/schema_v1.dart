// dart format width=80
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i2;
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class WaterIntakes extends Table
    with TableInfo<WaterIntakes, WaterIntakesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  WaterIntakes(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> drinkType = GeneratedColumn<int>(
    'drink_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, amount, drinkType, time];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_intakes';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterIntakesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterIntakesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      drinkType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}drink_type'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}time'],
      )!,
    );
  }

  @override
  WaterIntakes createAlias(String alias) {
    return WaterIntakes(attachedDatabase, alias);
  }
}

class WaterIntakesData extends DataClass
    implements Insertable<WaterIntakesData> {
  final int id;
  final int amount;
  final int drinkType;
  final DateTime time;
  const WaterIntakesData({
    required this.id,
    required this.amount,
    required this.drinkType,
    required this.time,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<int>(amount);
    map['drink_type'] = Variable<int>(drinkType);
    map['time'] = Variable<DateTime>(time);
    return map;
  }

  WaterIntakesCompanion toCompanion(bool nullToAbsent) {
    return WaterIntakesCompanion(
      id: Value(id),
      amount: Value(amount),
      drinkType: Value(drinkType),
      time: Value(time),
    );
  }

  factory WaterIntakesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterIntakesData(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<int>(json['amount']),
      drinkType: serializer.fromJson<int>(json['drinkType']),
      time: serializer.fromJson<DateTime>(json['time']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<int>(amount),
      'drinkType': serializer.toJson<int>(drinkType),
      'time': serializer.toJson<DateTime>(time),
    };
  }

  WaterIntakesData copyWith({
    int? id,
    int? amount,
    int? drinkType,
    DateTime? time,
  }) => WaterIntakesData(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    drinkType: drinkType ?? this.drinkType,
    time: time ?? this.time,
  );
  WaterIntakesData copyWithCompanion(WaterIntakesCompanion data) {
    return WaterIntakesData(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      drinkType: data.drinkType.present ? data.drinkType.value : this.drinkType,
      time: data.time.present ? data.time.value : this.time,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterIntakesData(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('drinkType: $drinkType, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, drinkType, time);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterIntakesData &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.drinkType == this.drinkType &&
          other.time == this.time);
}

class WaterIntakesCompanion extends UpdateCompanion<WaterIntakesData> {
  final Value<int> id;
  final Value<int> amount;
  final Value<int> drinkType;
  final Value<DateTime> time;
  const WaterIntakesCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.drinkType = const Value.absent(),
    this.time = const Value.absent(),
  });
  WaterIntakesCompanion.insert({
    this.id = const Value.absent(),
    required int amount,
    required int drinkType,
    required DateTime time,
  }) : amount = Value(amount),
       drinkType = Value(drinkType),
       time = Value(time);
  static Insertable<WaterIntakesData> custom({
    Expression<int>? id,
    Expression<int>? amount,
    Expression<int>? drinkType,
    Expression<DateTime>? time,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (drinkType != null) 'drink_type': drinkType,
      if (time != null) 'time': time,
    });
  }

  WaterIntakesCompanion copyWith({
    Value<int>? id,
    Value<int>? amount,
    Value<int>? drinkType,
    Value<DateTime>? time,
  }) {
    return WaterIntakesCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      drinkType: drinkType ?? this.drinkType,
      time: time ?? this.time,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (drinkType.present) {
      map['drink_type'] = Variable<int>(drinkType.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterIntakesCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('drinkType: $drinkType, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }
}

class User extends Table with TableInfo<User, UserData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  User(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    check: () => i2.ComparableExpr(
      age,
    ).isBetween(const i2.Constant(10), const i2.Constant(90)),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> gender = GeneratedColumn<int>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, age, gender, height, weight];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gender'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
    );
  }

  @override
  User createAlias(String alias) {
    return User(attachedDatabase, alias);
  }
}

class UserData extends DataClass implements Insertable<UserData> {
  final int id;
  final String name;
  final int age;
  final int gender;
  final double height;
  final double weight;
  const UserData({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['age'] = Variable<int>(age);
    map['gender'] = Variable<int>(gender);
    map['height'] = Variable<double>(height);
    map['weight'] = Variable<double>(weight);
    return map;
  }

  UserCompanion toCompanion(bool nullToAbsent) {
    return UserCompanion(
      id: Value(id),
      name: Value(name),
      age: Value(age),
      gender: Value(gender),
      height: Value(height),
      weight: Value(weight),
    );
  }

  factory UserData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
      gender: serializer.fromJson<int>(json['gender']),
      height: serializer.fromJson<double>(json['height']),
      weight: serializer.fromJson<double>(json['weight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
      'gender': serializer.toJson<int>(gender),
      'height': serializer.toJson<double>(height),
      'weight': serializer.toJson<double>(weight),
    };
  }

  UserData copyWith({
    int? id,
    String? name,
    int? age,
    int? gender,
    double? height,
    double? weight,
  }) => UserData(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age ?? this.age,
    gender: gender ?? this.gender,
    height: height ?? this.height,
    weight: weight ?? this.weight,
  );
  UserData copyWithCompanion(UserCompanion data) {
    return UserData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      height: data.height.present ? data.height.value : this.height,
      weight: data.weight.present ? data.weight.value : this.weight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('height: $height, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, age, gender, height, weight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserData &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.height == this.height &&
          other.weight == this.weight);
}

class UserCompanion extends UpdateCompanion<UserData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> age;
  final Value<int> gender;
  final Value<double> height;
  final Value<double> weight;
  const UserCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.height = const Value.absent(),
    this.weight = const Value.absent(),
  });
  UserCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int age,
    required int gender,
    required double height,
    required double weight,
  }) : name = Value(name),
       age = Value(age),
       gender = Value(gender),
       height = Value(height),
       weight = Value(weight);
  static Insertable<UserData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? age,
    Expression<int>? gender,
    Expression<double>? height,
    Expression<double>? weight,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
    });
  }

  UserCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? age,
    Value<int>? gender,
    Value<double>? height,
    Value<double>? weight,
  }) {
    return UserCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int>(gender.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('height: $height, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }
}

class Goal extends Table with TableInfo<Goal, GoalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Goal(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<int> fitnessGoal = GeneratedColumn<int>(
    'fitness_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> targetWeight = GeneratedColumn<double>(
    'target_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> hydrationGoal = GeneratedColumn<double>(
    'hydration_goal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fitnessGoal,
    targetWeight,
    hydrationGoal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fitnessGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fitness_goal'],
      )!,
      targetWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight'],
      )!,
      hydrationGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hydration_goal'],
      )!,
    );
  }

  @override
  Goal createAlias(String alias) {
    return Goal(attachedDatabase, alias);
  }
}

class GoalData extends DataClass implements Insertable<GoalData> {
  final int id;
  final int fitnessGoal;
  final double targetWeight;
  final double hydrationGoal;
  const GoalData({
    required this.id,
    required this.fitnessGoal,
    required this.targetWeight,
    required this.hydrationGoal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fitness_goal'] = Variable<int>(fitnessGoal);
    map['target_weight'] = Variable<double>(targetWeight);
    map['hydration_goal'] = Variable<double>(hydrationGoal);
    return map;
  }

  GoalCompanion toCompanion(bool nullToAbsent) {
    return GoalCompanion(
      id: Value(id),
      fitnessGoal: Value(fitnessGoal),
      targetWeight: Value(targetWeight),
      hydrationGoal: Value(hydrationGoal),
    );
  }

  factory GoalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalData(
      id: serializer.fromJson<int>(json['id']),
      fitnessGoal: serializer.fromJson<int>(json['fitnessGoal']),
      targetWeight: serializer.fromJson<double>(json['targetWeight']),
      hydrationGoal: serializer.fromJson<double>(json['hydrationGoal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fitnessGoal': serializer.toJson<int>(fitnessGoal),
      'targetWeight': serializer.toJson<double>(targetWeight),
      'hydrationGoal': serializer.toJson<double>(hydrationGoal),
    };
  }

  GoalData copyWith({
    int? id,
    int? fitnessGoal,
    double? targetWeight,
    double? hydrationGoal,
  }) => GoalData(
    id: id ?? this.id,
    fitnessGoal: fitnessGoal ?? this.fitnessGoal,
    targetWeight: targetWeight ?? this.targetWeight,
    hydrationGoal: hydrationGoal ?? this.hydrationGoal,
  );
  GoalData copyWithCompanion(GoalCompanion data) {
    return GoalData(
      id: data.id.present ? data.id.value : this.id,
      fitnessGoal: data.fitnessGoal.present
          ? data.fitnessGoal.value
          : this.fitnessGoal,
      targetWeight: data.targetWeight.present
          ? data.targetWeight.value
          : this.targetWeight,
      hydrationGoal: data.hydrationGoal.present
          ? data.hydrationGoal.value
          : this.hydrationGoal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalData(')
          ..write('id: $id, ')
          ..write('fitnessGoal: $fitnessGoal, ')
          ..write('targetWeight: $targetWeight, ')
          ..write('hydrationGoal: $hydrationGoal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fitnessGoal, targetWeight, hydrationGoal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalData &&
          other.id == this.id &&
          other.fitnessGoal == this.fitnessGoal &&
          other.targetWeight == this.targetWeight &&
          other.hydrationGoal == this.hydrationGoal);
}

class GoalCompanion extends UpdateCompanion<GoalData> {
  final Value<int> id;
  final Value<int> fitnessGoal;
  final Value<double> targetWeight;
  final Value<double> hydrationGoal;
  const GoalCompanion({
    this.id = const Value.absent(),
    this.fitnessGoal = const Value.absent(),
    this.targetWeight = const Value.absent(),
    this.hydrationGoal = const Value.absent(),
  });
  GoalCompanion.insert({
    this.id = const Value.absent(),
    required int fitnessGoal,
    required double targetWeight,
    required double hydrationGoal,
  }) : fitnessGoal = Value(fitnessGoal),
       targetWeight = Value(targetWeight),
       hydrationGoal = Value(hydrationGoal);
  static Insertable<GoalData> custom({
    Expression<int>? id,
    Expression<int>? fitnessGoal,
    Expression<double>? targetWeight,
    Expression<double>? hydrationGoal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fitnessGoal != null) 'fitness_goal': fitnessGoal,
      if (targetWeight != null) 'target_weight': targetWeight,
      if (hydrationGoal != null) 'hydration_goal': hydrationGoal,
    });
  }

  GoalCompanion copyWith({
    Value<int>? id,
    Value<int>? fitnessGoal,
    Value<double>? targetWeight,
    Value<double>? hydrationGoal,
  }) {
    return GoalCompanion(
      id: id ?? this.id,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      targetWeight: targetWeight ?? this.targetWeight,
      hydrationGoal: hydrationGoal ?? this.hydrationGoal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fitnessGoal.present) {
      map['fitness_goal'] = Variable<int>(fitnessGoal.value);
    }
    if (targetWeight.present) {
      map['target_weight'] = Variable<double>(targetWeight.value);
    }
    if (hydrationGoal.present) {
      map['hydration_goal'] = Variable<double>(hydrationGoal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalCompanion(')
          ..write('id: $id, ')
          ..write('fitnessGoal: $fitnessGoal, ')
          ..write('targetWeight: $targetWeight, ')
          ..write('hydrationGoal: $hydrationGoal')
          ..write(')'))
        .toString();
  }
}

class Preference extends Table with TableInfo<Preference, PreferenceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Preference(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<int> weightUnit = GeneratedColumn<int>(
    'weight_unit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> fluidUnit = GeneratedColumn<int>(
    'fluid_unit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, weightUnit, fluidUnit];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreferenceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weightUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_unit'],
      )!,
      fluidUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fluid_unit'],
      )!,
    );
  }

  @override
  Preference createAlias(String alias) {
    return Preference(attachedDatabase, alias);
  }
}

class PreferenceData extends DataClass implements Insertable<PreferenceData> {
  final int id;
  final int weightUnit;
  final int fluidUnit;
  const PreferenceData({
    required this.id,
    required this.weightUnit,
    required this.fluidUnit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['weight_unit'] = Variable<int>(weightUnit);
    map['fluid_unit'] = Variable<int>(fluidUnit);
    return map;
  }

  PreferenceCompanion toCompanion(bool nullToAbsent) {
    return PreferenceCompanion(
      id: Value(id),
      weightUnit: Value(weightUnit),
      fluidUnit: Value(fluidUnit),
    );
  }

  factory PreferenceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceData(
      id: serializer.fromJson<int>(json['id']),
      weightUnit: serializer.fromJson<int>(json['weightUnit']),
      fluidUnit: serializer.fromJson<int>(json['fluidUnit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weightUnit': serializer.toJson<int>(weightUnit),
      'fluidUnit': serializer.toJson<int>(fluidUnit),
    };
  }

  PreferenceData copyWith({int? id, int? weightUnit, int? fluidUnit}) =>
      PreferenceData(
        id: id ?? this.id,
        weightUnit: weightUnit ?? this.weightUnit,
        fluidUnit: fluidUnit ?? this.fluidUnit,
      );
  PreferenceData copyWithCompanion(PreferenceCompanion data) {
    return PreferenceData(
      id: data.id.present ? data.id.value : this.id,
      weightUnit: data.weightUnit.present
          ? data.weightUnit.value
          : this.weightUnit,
      fluidUnit: data.fluidUnit.present ? data.fluidUnit.value : this.fluidUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceData(')
          ..write('id: $id, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('fluidUnit: $fluidUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weightUnit, fluidUnit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceData &&
          other.id == this.id &&
          other.weightUnit == this.weightUnit &&
          other.fluidUnit == this.fluidUnit);
}

class PreferenceCompanion extends UpdateCompanion<PreferenceData> {
  final Value<int> id;
  final Value<int> weightUnit;
  final Value<int> fluidUnit;
  const PreferenceCompanion({
    this.id = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.fluidUnit = const Value.absent(),
  });
  PreferenceCompanion.insert({
    this.id = const Value.absent(),
    required int weightUnit,
    required int fluidUnit,
  }) : weightUnit = Value(weightUnit),
       fluidUnit = Value(fluidUnit);
  static Insertable<PreferenceData> custom({
    Expression<int>? id,
    Expression<int>? weightUnit,
    Expression<int>? fluidUnit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weightUnit != null) 'weight_unit': weightUnit,
      if (fluidUnit != null) 'fluid_unit': fluidUnit,
    });
  }

  PreferenceCompanion copyWith({
    Value<int>? id,
    Value<int>? weightUnit,
    Value<int>? fluidUnit,
  }) {
    return PreferenceCompanion(
      id: id ?? this.id,
      weightUnit: weightUnit ?? this.weightUnit,
      fluidUnit: fluidUnit ?? this.fluidUnit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weightUnit.present) {
      map['weight_unit'] = Variable<int>(weightUnit.value);
    }
    if (fluidUnit.present) {
      map['fluid_unit'] = Variable<int>(fluidUnit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceCompanion(')
          ..write('id: $id, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('fluidUnit: $fluidUnit')
          ..write(')'))
        .toString();
  }
}

class WorkoutPlan extends Table with TableInfo<WorkoutPlan, WorkoutPlanData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  WorkoutPlan(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 10,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<bool> isVisible = GeneratedColumn<bool>(
    'is_visible',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_visible" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, dayOfWeek, isVisible];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_plan';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutPlanData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutPlanData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      )!,
      isVisible: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_visible'],
      )!,
    );
  }

  @override
  WorkoutPlan createAlias(String alias) {
    return WorkoutPlan(attachedDatabase, alias);
  }
}

class WorkoutPlanData extends DataClass implements Insertable<WorkoutPlanData> {
  final int id;
  final String name;
  final int dayOfWeek;
  final bool isVisible;
  const WorkoutPlanData({
    required this.id,
    required this.name,
    required this.dayOfWeek,
    required this.isVisible,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['is_visible'] = Variable<bool>(isVisible);
    return map;
  }

  WorkoutPlanCompanion toCompanion(bool nullToAbsent) {
    return WorkoutPlanCompanion(
      id: Value(id),
      name: Value(name),
      dayOfWeek: Value(dayOfWeek),
      isVisible: Value(isVisible),
    );
  }

  factory WorkoutPlanData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutPlanData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      isVisible: serializer.fromJson<bool>(json['isVisible']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'isVisible': serializer.toJson<bool>(isVisible),
    };
  }

  WorkoutPlanData copyWith({
    int? id,
    String? name,
    int? dayOfWeek,
    bool? isVisible,
  }) => WorkoutPlanData(
    id: id ?? this.id,
    name: name ?? this.name,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    isVisible: isVisible ?? this.isVisible,
  );
  WorkoutPlanData copyWithCompanion(WorkoutPlanCompanion data) {
    return WorkoutPlanData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      isVisible: data.isVisible.present ? data.isVisible.value : this.isVisible,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlanData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('isVisible: $isVisible')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, dayOfWeek, isVisible);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutPlanData &&
          other.id == this.id &&
          other.name == this.name &&
          other.dayOfWeek == this.dayOfWeek &&
          other.isVisible == this.isVisible);
}

class WorkoutPlanCompanion extends UpdateCompanion<WorkoutPlanData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> dayOfWeek;
  final Value<bool> isVisible;
  const WorkoutPlanCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.isVisible = const Value.absent(),
  });
  WorkoutPlanCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int dayOfWeek,
    this.isVisible = const Value.absent(),
  }) : name = Value(name),
       dayOfWeek = Value(dayOfWeek);
  static Insertable<WorkoutPlanData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? dayOfWeek,
    Expression<bool>? isVisible,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (isVisible != null) 'is_visible': isVisible,
    });
  }

  WorkoutPlanCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? dayOfWeek,
    Value<bool>? isVisible,
  }) {
    return WorkoutPlanCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (isVisible.present) {
      map['is_visible'] = Variable<bool>(isVisible.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlanCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('isVisible: $isVisible')
          ..write(')'))
        .toString();
  }
}

class WorkoutExcercise extends Table
    with TableInfo<WorkoutExcercise, WorkoutExcerciseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  WorkoutExcercise(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_plan (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  late final GeneratedColumn<String> exercise = GeneratedColumn<String>(
    'exercise',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> orderInWorkout = GeneratedColumn<int>(
    'order_in_workout',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, planId, exercise, orderInWorkout];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_excercise';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutExcerciseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExcerciseData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_id'],
      )!,
      exercise: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise'],
      )!,
      orderInWorkout: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_in_workout'],
      )!,
    );
  }

  @override
  WorkoutExcercise createAlias(String alias) {
    return WorkoutExcercise(attachedDatabase, alias);
  }
}

class WorkoutExcerciseData extends DataClass
    implements Insertable<WorkoutExcerciseData> {
  final int id;
  final int planId;
  final String exercise;
  final int orderInWorkout;
  const WorkoutExcerciseData({
    required this.id,
    required this.planId,
    required this.exercise,
    required this.orderInWorkout,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<int>(planId);
    map['exercise'] = Variable<String>(exercise);
    map['order_in_workout'] = Variable<int>(orderInWorkout);
    return map;
  }

  WorkoutExcerciseCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExcerciseCompanion(
      id: Value(id),
      planId: Value(planId),
      exercise: Value(exercise),
      orderInWorkout: Value(orderInWorkout),
    );
  }

  factory WorkoutExcerciseData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExcerciseData(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<int>(json['planId']),
      exercise: serializer.fromJson<String>(json['exercise']),
      orderInWorkout: serializer.fromJson<int>(json['orderInWorkout']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<int>(planId),
      'exercise': serializer.toJson<String>(exercise),
      'orderInWorkout': serializer.toJson<int>(orderInWorkout),
    };
  }

  WorkoutExcerciseData copyWith({
    int? id,
    int? planId,
    String? exercise,
    int? orderInWorkout,
  }) => WorkoutExcerciseData(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    exercise: exercise ?? this.exercise,
    orderInWorkout: orderInWorkout ?? this.orderInWorkout,
  );
  WorkoutExcerciseData copyWithCompanion(WorkoutExcerciseCompanion data) {
    return WorkoutExcerciseData(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      exercise: data.exercise.present ? data.exercise.value : this.exercise,
      orderInWorkout: data.orderInWorkout.present
          ? data.orderInWorkout.value
          : this.orderInWorkout,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExcerciseData(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('exercise: $exercise, ')
          ..write('orderInWorkout: $orderInWorkout')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, planId, exercise, orderInWorkout);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExcerciseData &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.exercise == this.exercise &&
          other.orderInWorkout == this.orderInWorkout);
}

class WorkoutExcerciseCompanion extends UpdateCompanion<WorkoutExcerciseData> {
  final Value<int> id;
  final Value<int> planId;
  final Value<String> exercise;
  final Value<int> orderInWorkout;
  const WorkoutExcerciseCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.exercise = const Value.absent(),
    this.orderInWorkout = const Value.absent(),
  });
  WorkoutExcerciseCompanion.insert({
    this.id = const Value.absent(),
    required int planId,
    required String exercise,
    required int orderInWorkout,
  }) : planId = Value(planId),
       exercise = Value(exercise),
       orderInWorkout = Value(orderInWorkout);
  static Insertable<WorkoutExcerciseData> custom({
    Expression<int>? id,
    Expression<int>? planId,
    Expression<String>? exercise,
    Expression<int>? orderInWorkout,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (exercise != null) 'exercise': exercise,
      if (orderInWorkout != null) 'order_in_workout': orderInWorkout,
    });
  }

  WorkoutExcerciseCompanion copyWith({
    Value<int>? id,
    Value<int>? planId,
    Value<String>? exercise,
    Value<int>? orderInWorkout,
  }) {
    return WorkoutExcerciseCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      exercise: exercise ?? this.exercise,
      orderInWorkout: orderInWorkout ?? this.orderInWorkout,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (exercise.present) {
      map['exercise'] = Variable<String>(exercise.value);
    }
    if (orderInWorkout.present) {
      map['order_in_workout'] = Variable<int>(orderInWorkout.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExcerciseCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('exercise: $exercise, ')
          ..write('orderInWorkout: $orderInWorkout')
          ..write(')'))
        .toString();
  }
}

class WorkoutLogs extends Table with TableInfo<WorkoutLogs, WorkoutLogsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  WorkoutLogs(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_plan (id)',
    ),
  );
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<DateTime> workoutDate = GeneratedColumn<DateTime>(
    'workout_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('CURRENT_DATE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, planId, duration, workoutDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_logs';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutLogsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutLogsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_id'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      )!,
      workoutDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}workout_date'],
      ),
    );
  }

  @override
  WorkoutLogs createAlias(String alias) {
    return WorkoutLogs(attachedDatabase, alias);
  }
}

class WorkoutLogsData extends DataClass implements Insertable<WorkoutLogsData> {
  final int id;
  final int planId;
  final int duration;
  final DateTime? workoutDate;
  const WorkoutLogsData({
    required this.id,
    required this.planId,
    required this.duration,
    this.workoutDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<int>(planId);
    map['duration'] = Variable<int>(duration);
    if (!nullToAbsent || workoutDate != null) {
      map['workout_date'] = Variable<DateTime>(workoutDate);
    }
    return map;
  }

  WorkoutLogsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutLogsCompanion(
      id: Value(id),
      planId: Value(planId),
      duration: Value(duration),
      workoutDate: workoutDate == null && nullToAbsent
          ? const Value.absent()
          : Value(workoutDate),
    );
  }

  factory WorkoutLogsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutLogsData(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<int>(json['planId']),
      duration: serializer.fromJson<int>(json['duration']),
      workoutDate: serializer.fromJson<DateTime?>(json['workoutDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<int>(planId),
      'duration': serializer.toJson<int>(duration),
      'workoutDate': serializer.toJson<DateTime?>(workoutDate),
    };
  }

  WorkoutLogsData copyWith({
    int? id,
    int? planId,
    int? duration,
    Value<DateTime?> workoutDate = const Value.absent(),
  }) => WorkoutLogsData(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    duration: duration ?? this.duration,
    workoutDate: workoutDate.present ? workoutDate.value : this.workoutDate,
  );
  WorkoutLogsData copyWithCompanion(WorkoutLogsCompanion data) {
    return WorkoutLogsData(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      duration: data.duration.present ? data.duration.value : this.duration,
      workoutDate: data.workoutDate.present
          ? data.workoutDate.value
          : this.workoutDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutLogsData(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('duration: $duration, ')
          ..write('workoutDate: $workoutDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, planId, duration, workoutDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutLogsData &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.duration == this.duration &&
          other.workoutDate == this.workoutDate);
}

class WorkoutLogsCompanion extends UpdateCompanion<WorkoutLogsData> {
  final Value<int> id;
  final Value<int> planId;
  final Value<int> duration;
  final Value<DateTime?> workoutDate;
  const WorkoutLogsCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.duration = const Value.absent(),
    this.workoutDate = const Value.absent(),
  });
  WorkoutLogsCompanion.insert({
    this.id = const Value.absent(),
    required int planId,
    required int duration,
    this.workoutDate = const Value.absent(),
  }) : planId = Value(planId),
       duration = Value(duration);
  static Insertable<WorkoutLogsData> custom({
    Expression<int>? id,
    Expression<int>? planId,
    Expression<int>? duration,
    Expression<DateTime>? workoutDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (duration != null) 'duration': duration,
      if (workoutDate != null) 'workout_date': workoutDate,
    });
  }

  WorkoutLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? planId,
    Value<int>? duration,
    Value<DateTime?>? workoutDate,
  }) {
    return WorkoutLogsCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      duration: duration ?? this.duration,
      workoutDate: workoutDate ?? this.workoutDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (workoutDate.present) {
      map['workout_date'] = Variable<DateTime>(workoutDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutLogsCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('duration: $duration, ')
          ..write('workoutDate: $workoutDate')
          ..write(')'))
        .toString();
  }
}

class ExerciseLogs extends Table
    with TableInfo<ExerciseLogs, ExerciseLogsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ExerciseLogs(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  late final GeneratedColumn<int> workoutLogId = GeneratedColumn<int>(
    'workout_log_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_logs (id)',
    ),
  );
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
    'sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('CURRENT_TIMESTAMP'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutLogId,
    exerciseId,
    sets,
    reps,
    weight,
    duration,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_logs';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseLogsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseLogsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workoutLogId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_log_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      sets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sets'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  ExerciseLogs createAlias(String alias) {
    return ExerciseLogs(attachedDatabase, alias);
  }
}

class ExerciseLogsData extends DataClass
    implements Insertable<ExerciseLogsData> {
  final int id;
  final int workoutLogId;
  final String exerciseId;
  final int sets;
  final int? reps;
  final double? weight;
  final int? duration;
  final DateTime createdAt;
  const ExerciseLogsData({
    required this.id,
    required this.workoutLogId,
    required this.exerciseId,
    required this.sets,
    this.reps,
    this.weight,
    this.duration,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout_log_id'] = Variable<int>(workoutLogId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['sets'] = Variable<int>(sets);
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExerciseLogsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseLogsCompanion(
      id: Value(id),
      workoutLogId: Value(workoutLogId),
      exerciseId: Value(exerciseId),
      sets: Value(sets),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      weight: weight == null && nullToAbsent
          ? const Value.absent()
          : Value(weight),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      createdAt: Value(createdAt),
    );
  }

  factory ExerciseLogsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseLogsData(
      id: serializer.fromJson<int>(json['id']),
      workoutLogId: serializer.fromJson<int>(json['workoutLogId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      sets: serializer.fromJson<int>(json['sets']),
      reps: serializer.fromJson<int?>(json['reps']),
      weight: serializer.fromJson<double?>(json['weight']),
      duration: serializer.fromJson<int?>(json['duration']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workoutLogId': serializer.toJson<int>(workoutLogId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'sets': serializer.toJson<int>(sets),
      'reps': serializer.toJson<int?>(reps),
      'weight': serializer.toJson<double?>(weight),
      'duration': serializer.toJson<int?>(duration),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExerciseLogsData copyWith({
    int? id,
    int? workoutLogId,
    String? exerciseId,
    int? sets,
    Value<int?> reps = const Value.absent(),
    Value<double?> weight = const Value.absent(),
    Value<int?> duration = const Value.absent(),
    DateTime? createdAt,
  }) => ExerciseLogsData(
    id: id ?? this.id,
    workoutLogId: workoutLogId ?? this.workoutLogId,
    exerciseId: exerciseId ?? this.exerciseId,
    sets: sets ?? this.sets,
    reps: reps.present ? reps.value : this.reps,
    weight: weight.present ? weight.value : this.weight,
    duration: duration.present ? duration.value : this.duration,
    createdAt: createdAt ?? this.createdAt,
  );
  ExerciseLogsData copyWithCompanion(ExerciseLogsCompanion data) {
    return ExerciseLogsData(
      id: data.id.present ? data.id.value : this.id,
      workoutLogId: data.workoutLogId.present
          ? data.workoutLogId.value
          : this.workoutLogId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      sets: data.sets.present ? data.sets.value : this.sets,
      reps: data.reps.present ? data.reps.value : this.reps,
      weight: data.weight.present ? data.weight.value : this.weight,
      duration: data.duration.present ? data.duration.value : this.duration,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseLogsData(')
          ..write('id: $id, ')
          ..write('workoutLogId: $workoutLogId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('duration: $duration, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutLogId,
    exerciseId,
    sets,
    reps,
    weight,
    duration,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseLogsData &&
          other.id == this.id &&
          other.workoutLogId == this.workoutLogId &&
          other.exerciseId == this.exerciseId &&
          other.sets == this.sets &&
          other.reps == this.reps &&
          other.weight == this.weight &&
          other.duration == this.duration &&
          other.createdAt == this.createdAt);
}

class ExerciseLogsCompanion extends UpdateCompanion<ExerciseLogsData> {
  final Value<int> id;
  final Value<int> workoutLogId;
  final Value<String> exerciseId;
  final Value<int> sets;
  final Value<int?> reps;
  final Value<double?> weight;
  final Value<int?> duration;
  final Value<DateTime> createdAt;
  const ExerciseLogsCompanion({
    this.id = const Value.absent(),
    this.workoutLogId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sets = const Value.absent(),
    this.reps = const Value.absent(),
    this.weight = const Value.absent(),
    this.duration = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExerciseLogsCompanion.insert({
    this.id = const Value.absent(),
    required int workoutLogId,
    required String exerciseId,
    required int sets,
    this.reps = const Value.absent(),
    this.weight = const Value.absent(),
    this.duration = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : workoutLogId = Value(workoutLogId),
       exerciseId = Value(exerciseId),
       sets = Value(sets);
  static Insertable<ExerciseLogsData> custom({
    Expression<int>? id,
    Expression<int>? workoutLogId,
    Expression<String>? exerciseId,
    Expression<int>? sets,
    Expression<int>? reps,
    Expression<double>? weight,
    Expression<int>? duration,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutLogId != null) 'workout_log_id': workoutLogId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sets != null) 'sets': sets,
      if (reps != null) 'reps': reps,
      if (weight != null) 'weight': weight,
      if (duration != null) 'duration': duration,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExerciseLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? workoutLogId,
    Value<String>? exerciseId,
    Value<int>? sets,
    Value<int?>? reps,
    Value<double?>? weight,
    Value<int?>? duration,
    Value<DateTime>? createdAt,
  }) {
    return ExerciseLogsCompanion(
      id: id ?? this.id,
      workoutLogId: workoutLogId ?? this.workoutLogId,
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workoutLogId.present) {
      map['workout_log_id'] = Variable<int>(workoutLogId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseLogsCompanion(')
          ..write('id: $id, ')
          ..write('workoutLogId: $workoutLogId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('duration: $duration, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV1 extends GeneratedDatabase {
  DatabaseAtV1(QueryExecutor e) : super(e);
  late final WaterIntakes waterIntakes = WaterIntakes(this);
  late final User user = User(this);
  late final Goal goal = Goal(this);
  late final Preference preference = Preference(this);
  late final WorkoutPlan workoutPlan = WorkoutPlan(this);
  late final WorkoutExcercise workoutExcercise = WorkoutExcercise(this);
  late final WorkoutLogs workoutLogs = WorkoutLogs(this);
  late final ExerciseLogs exerciseLogs = ExerciseLogs(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    waterIntakes,
    user,
    goal,
    preference,
    workoutPlan,
    workoutExcercise,
    workoutLogs,
    exerciseLogs,
  ];
  @override
  int get schemaVersion => 1;
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}
