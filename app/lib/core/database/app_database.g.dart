// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkspacesTable extends Workspaces
    with TableInfo<$WorkspacesTable, Workspace> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkspacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workspaces';
  @override
  VerificationContext validateIntegrity(
    Insertable<Workspace> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Workspace map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workspace(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $WorkspacesTable createAlias(String alias) {
    return $WorkspacesTable(attachedDatabase, alias);
  }
}

class Workspace extends DataClass implements Insertable<Workspace> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  const Workspace({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    return map;
  }

  WorkspacesCompanion toCompanion(bool nullToAbsent) {
    return WorkspacesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
    );
  }

  factory Workspace.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workspace(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
    };
  }

  Workspace copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
  }) => Workspace(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
  );
  Workspace copyWithCompanion(WorkspacesCompanion data) {
    return Workspace(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Workspace(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, deletedAt, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workspace &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name);
}

class WorkspacesCompanion extends UpdateCompanion<Workspace> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<int> rowid;
  const WorkspacesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkspacesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Workspace> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkspacesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return WorkspacesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkspacesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itflowClientIdMeta = const VerificationMeta(
    'itflowClientId',
  );
  @override
  late final GeneratedColumn<int> itflowClientId = GeneratedColumn<int>(
    'itflow_client_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contingentAePerMonthMeta =
      const VerificationMeta('contingentAePerMonth');
  @override
  late final GeneratedColumn<int> contingentAePerMonth = GeneratedColumn<int>(
    'contingent_ae_per_month',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    color,
    address,
    notes,
    itflowClientId,
    contingentAePerMonth,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('itflow_client_id')) {
      context.handle(
        _itflowClientIdMeta,
        itflowClientId.isAcceptableOrUnknown(
          data['itflow_client_id']!,
          _itflowClientIdMeta,
        ),
      );
    }
    if (data.containsKey('contingent_ae_per_month')) {
      context.handle(
        _contingentAePerMonthMeta,
        contingentAePerMonth.isAcceptableOrUnknown(
          data['contingent_ae_per_month']!,
          _contingentAePerMonthMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      itflowClientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}itflow_client_id'],
      ),
      contingentAePerMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contingent_ae_per_month'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final int? color;
  final String? address;
  final String? notes;
  final int? itflowClientId;
  final int? contingentAePerMonth;
  final bool isFavorite;
  const Customer({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    this.color,
    this.address,
    this.notes,
    this.itflowClientId,
    this.contingentAePerMonth,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || itflowClientId != null) {
      map['itflow_client_id'] = Variable<int>(itflowClientId);
    }
    if (!nullToAbsent || contingentAePerMonth != null) {
      map['contingent_ae_per_month'] = Variable<int>(contingentAePerMonth);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      itflowClientId: itflowClientId == null && nullToAbsent
          ? const Value.absent()
          : Value(itflowClientId),
      contingentAePerMonth: contingentAePerMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(contingentAePerMonth),
      isFavorite: Value(isFavorite),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int?>(json['color']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      itflowClientId: serializer.fromJson<int?>(json['itflowClientId']),
      contingentAePerMonth: serializer.fromJson<int?>(
        json['contingentAePerMonth'],
      ),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int?>(color),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'itflowClientId': serializer.toJson<int?>(itflowClientId),
      'contingentAePerMonth': serializer.toJson<int?>(contingentAePerMonth),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  Customer copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    Value<int?> color = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<int?> itflowClientId = const Value.absent(),
    Value<int?> contingentAePerMonth = const Value.absent(),
    bool? isFavorite,
  }) => Customer(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
    address: address.present ? address.value : this.address,
    notes: notes.present ? notes.value : this.notes,
    itflowClientId: itflowClientId.present
        ? itflowClientId.value
        : this.itflowClientId,
    contingentAePerMonth: contingentAePerMonth.present
        ? contingentAePerMonth.value
        : this.contingentAePerMonth,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      itflowClientId: data.itflowClientId.present
          ? data.itflowClientId.value
          : this.itflowClientId,
      contingentAePerMonth: data.contingentAePerMonth.present
          ? data.contingentAePerMonth.value
          : this.contingentAePerMonth,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('itflowClientId: $itflowClientId, ')
          ..write('contingentAePerMonth: $contingentAePerMonth, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    color,
    address,
    notes,
    itflowClientId,
    contingentAePerMonth,
    isFavorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.color == this.color &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.itflowClientId == this.itflowClientId &&
          other.contingentAePerMonth == this.contingentAePerMonth &&
          other.isFavorite == this.isFavorite);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<int?> color;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<int?> itflowClientId;
  final Value<int?> contingentAePerMonth;
  final Value<bool> isFavorite;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.itflowClientId = const Value.absent(),
    this.contingentAePerMonth = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.itflowClientId = const Value.absent(),
    this.contingentAePerMonth = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<int>? color,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<int>? itflowClientId,
    Expression<int>? contingentAePerMonth,
    Expression<bool>? isFavorite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (itflowClientId != null) 'itflow_client_id': itflowClientId,
      if (contingentAePerMonth != null)
        'contingent_ae_per_month': contingentAePerMonth,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<int?>? color,
    Value<String?>? address,
    Value<String?>? notes,
    Value<int?>? itflowClientId,
    Value<int?>? contingentAePerMonth,
    Value<bool>? isFavorite,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      color: color ?? this.color,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      itflowClientId: itflowClientId ?? this.itflowClientId,
      contingentAePerMonth: contingentAePerMonth ?? this.contingentAePerMonth,
      isFavorite: isFavorite ?? this.isFavorite,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (itflowClientId.present) {
      map['itflow_client_id'] = Variable<int>(itflowClientId.value);
    }
    if (contingentAePerMonth.present) {
      map['contingent_ae_per_month'] = Variable<int>(
        contingentAePerMonth.value,
      );
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('itflowClientId: $itflowClientId, ')
          ..write('contingentAePerMonth: $contingentAePerMonth, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContactsTable extends Contacts with TableInfo<$ContactsTable, Contact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    customerId,
    name,
    role,
    phone,
    email,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contact(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }
}

class Contact extends DataClass implements Insertable<Contact> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String customerId;
  final String name;
  final String? role;
  final String? phone;
  final String? email;
  const Contact({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.customerId,
    required this.name,
    this.role,
    this.phone,
    this.email,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['customer_id'] = Variable<String>(customerId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      customerId: Value(customerId),
      name: Value(name),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
    );
  }

  factory Contact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contact(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      customerId: serializer.fromJson<String>(json['customerId']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String?>(json['role']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'customerId': serializer.toJson<String>(customerId),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String?>(role),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
    };
  }

  Contact copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? customerId,
    String? name,
    Value<String?> role = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
  }) => Contact(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    customerId: customerId ?? this.customerId,
    name: name ?? this.name,
    role: role.present ? role.value : this.role,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
  );
  Contact copyWithCompanion(ContactsCompanion data) {
    return Contact(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contact(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('customerId: $customerId, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('email: $email')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    customerId,
    name,
    role,
    phone,
    email,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.customerId == this.customerId &&
          other.name == this.name &&
          other.role == this.role &&
          other.phone == this.phone &&
          other.email == this.email);
}

class ContactsCompanion extends UpdateCompanion<Contact> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> customerId;
  final Value<String> name;
  final Value<String?> role;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<int> rowid;
  const ContactsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.customerId = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContactsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String customerId,
    required String name,
    this.role = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : customerId = Value(customerId),
       name = Value(name);
  static Insertable<Contact> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? customerId,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (customerId != null) 'customer_id': customerId,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContactsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? customerId,
    Value<String>? name,
    Value<String?>? role,
    Value<String?>? phone,
    Value<String?>? email,
    Value<int>? rowid,
  }) {
    return ContactsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('customerId: $customerId, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ProjectStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(ProjectStatus.planned.name),
      ).withConverter<ProjectStatus>($ProjectsTable.$converterstatus);
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
    'start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<DateTime> due = GeneratedColumn<DateTime>(
    'due',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _budgetAeMeta = const VerificationMeta(
    'budgetAe',
  );
  @override
  late final GeneratedColumn<int> budgetAe = GeneratedColumn<int>(
    'budget_ae',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _warnPercentMeta = const VerificationMeta(
    'warnPercent',
  );
  @override
  late final GeneratedColumn<int> warnPercent = GeneratedColumn<int>(
    'warn_percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(80),
  );
  static const VerificationMeta _itflowProjectIdMeta = const VerificationMeta(
    'itflowProjectId',
  );
  @override
  late final GeneratedColumn<int> itflowProjectId = GeneratedColumn<int>(
    'itflow_project_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    customerId,
    name,
    color,
    status,
    start,
    due,
    budgetAe,
    warnPercent,
    itflowProjectId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('start')) {
      context.handle(
        _startMeta,
        start.isAcceptableOrUnknown(data['start']!, _startMeta),
      );
    }
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    }
    if (data.containsKey('budget_ae')) {
      context.handle(
        _budgetAeMeta,
        budgetAe.isAcceptableOrUnknown(data['budget_ae']!, _budgetAeMeta),
      );
    }
    if (data.containsKey('warn_percent')) {
      context.handle(
        _warnPercentMeta,
        warnPercent.isAcceptableOrUnknown(
          data['warn_percent']!,
          _warnPercentMeta,
        ),
      );
    }
    if (data.containsKey('itflow_project_id')) {
      context.handle(
        _itflowProjectIdMeta,
        itflowProjectId.isAcceptableOrUnknown(
          data['itflow_project_id']!,
          _itflowProjectIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      ),
      status: $ProjectsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      start: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start'],
      ),
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due'],
      ),
      budgetAe: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_ae'],
      ),
      warnPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}warn_percent'],
      )!,
      itflowProjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}itflow_project_id'],
      ),
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ProjectStatus, String, String> $converterstatus =
      const EnumNameConverter<ProjectStatus>(ProjectStatus.values);
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  /// Null means an internal project.
  final String? customerId;
  final String name;

  /// Null means the colour is inherited from the customer.
  final int? color;
  final ProjectStatus status;
  final DateTime? start;
  final DateTime? due;
  final int? budgetAe;
  final int warnPercent;
  final int? itflowProjectId;
  const Project({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.customerId,
    required this.name,
    this.color,
    required this.status,
    this.start,
    this.due,
    this.budgetAe,
    required this.warnPercent,
    this.itflowProjectId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    {
      map['status'] = Variable<String>(
        $ProjectsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || start != null) {
      map['start'] = Variable<DateTime>(start);
    }
    if (!nullToAbsent || due != null) {
      map['due'] = Variable<DateTime>(due);
    }
    if (!nullToAbsent || budgetAe != null) {
      map['budget_ae'] = Variable<int>(budgetAe);
    }
    map['warn_percent'] = Variable<int>(warnPercent);
    if (!nullToAbsent || itflowProjectId != null) {
      map['itflow_project_id'] = Variable<int>(itflowProjectId);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      status: Value(status),
      start: start == null && nullToAbsent
          ? const Value.absent()
          : Value(start),
      due: due == null && nullToAbsent ? const Value.absent() : Value(due),
      budgetAe: budgetAe == null && nullToAbsent
          ? const Value.absent()
          : Value(budgetAe),
      warnPercent: Value(warnPercent),
      itflowProjectId: itflowProjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(itflowProjectId),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int?>(json['color']),
      status: $ProjectsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      start: serializer.fromJson<DateTime?>(json['start']),
      due: serializer.fromJson<DateTime?>(json['due']),
      budgetAe: serializer.fromJson<int?>(json['budgetAe']),
      warnPercent: serializer.fromJson<int>(json['warnPercent']),
      itflowProjectId: serializer.fromJson<int?>(json['itflowProjectId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'customerId': serializer.toJson<String?>(customerId),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int?>(color),
      'status': serializer.toJson<String>(
        $ProjectsTable.$converterstatus.toJson(status),
      ),
      'start': serializer.toJson<DateTime?>(start),
      'due': serializer.toJson<DateTime?>(due),
      'budgetAe': serializer.toJson<int?>(budgetAe),
      'warnPercent': serializer.toJson<int>(warnPercent),
      'itflowProjectId': serializer.toJson<int?>(itflowProjectId),
    };
  }

  Project copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> customerId = const Value.absent(),
    String? name,
    Value<int?> color = const Value.absent(),
    ProjectStatus? status,
    Value<DateTime?> start = const Value.absent(),
    Value<DateTime?> due = const Value.absent(),
    Value<int?> budgetAe = const Value.absent(),
    int? warnPercent,
    Value<int?> itflowProjectId = const Value.absent(),
  }) => Project(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    customerId: customerId.present ? customerId.value : this.customerId,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
    status: status ?? this.status,
    start: start.present ? start.value : this.start,
    due: due.present ? due.value : this.due,
    budgetAe: budgetAe.present ? budgetAe.value : this.budgetAe,
    warnPercent: warnPercent ?? this.warnPercent,
    itflowProjectId: itflowProjectId.present
        ? itflowProjectId.value
        : this.itflowProjectId,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      status: data.status.present ? data.status.value : this.status,
      start: data.start.present ? data.start.value : this.start,
      due: data.due.present ? data.due.value : this.due,
      budgetAe: data.budgetAe.present ? data.budgetAe.value : this.budgetAe,
      warnPercent: data.warnPercent.present
          ? data.warnPercent.value
          : this.warnPercent,
      itflowProjectId: data.itflowProjectId.present
          ? data.itflowProjectId.value
          : this.itflowProjectId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('customerId: $customerId, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('status: $status, ')
          ..write('start: $start, ')
          ..write('due: $due, ')
          ..write('budgetAe: $budgetAe, ')
          ..write('warnPercent: $warnPercent, ')
          ..write('itflowProjectId: $itflowProjectId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    customerId,
    name,
    color,
    status,
    start,
    due,
    budgetAe,
    warnPercent,
    itflowProjectId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.customerId == this.customerId &&
          other.name == this.name &&
          other.color == this.color &&
          other.status == this.status &&
          other.start == this.start &&
          other.due == this.due &&
          other.budgetAe == this.budgetAe &&
          other.warnPercent == this.warnPercent &&
          other.itflowProjectId == this.itflowProjectId);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> customerId;
  final Value<String> name;
  final Value<int?> color;
  final Value<ProjectStatus> status;
  final Value<DateTime?> start;
  final Value<DateTime?> due;
  final Value<int?> budgetAe;
  final Value<int> warnPercent;
  final Value<int?> itflowProjectId;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.customerId = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.status = const Value.absent(),
    this.start = const Value.absent(),
    this.due = const Value.absent(),
    this.budgetAe = const Value.absent(),
    this.warnPercent = const Value.absent(),
    this.itflowProjectId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.customerId = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.status = const Value.absent(),
    this.start = const Value.absent(),
    this.due = const Value.absent(),
    this.budgetAe = const Value.absent(),
    this.warnPercent = const Value.absent(),
    this.itflowProjectId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? customerId,
    Expression<String>? name,
    Expression<int>? color,
    Expression<String>? status,
    Expression<DateTime>? start,
    Expression<DateTime>? due,
    Expression<int>? budgetAe,
    Expression<int>? warnPercent,
    Expression<int>? itflowProjectId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (customerId != null) 'customer_id': customerId,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (status != null) 'status': status,
      if (start != null) 'start': start,
      if (due != null) 'due': due,
      if (budgetAe != null) 'budget_ae': budgetAe,
      if (warnPercent != null) 'warn_percent': warnPercent,
      if (itflowProjectId != null) 'itflow_project_id': itflowProjectId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? customerId,
    Value<String>? name,
    Value<int?>? color,
    Value<ProjectStatus>? status,
    Value<DateTime?>? start,
    Value<DateTime?>? due,
    Value<int?>? budgetAe,
    Value<int>? warnPercent,
    Value<int?>? itflowProjectId,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      color: color ?? this.color,
      status: status ?? this.status,
      start: start ?? this.start,
      due: due ?? this.due,
      budgetAe: budgetAe ?? this.budgetAe,
      warnPercent: warnPercent ?? this.warnPercent,
      itflowProjectId: itflowProjectId ?? this.itflowProjectId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ProjectsTable.$converterstatus.toSql(status.value),
      );
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (due.present) {
      map['due'] = Variable<DateTime>(due.value);
    }
    if (budgetAe.present) {
      map['budget_ae'] = Variable<int>(budgetAe.value);
    }
    if (warnPercent.present) {
      map['warn_percent'] = Variable<int>(warnPercent.value);
    }
    if (itflowProjectId.present) {
      map['itflow_project_id'] = Variable<int>(itflowProjectId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('customerId: $customerId, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('status: $status, ')
          ..write('start: $start, ')
          ..write('due: $due, ')
          ..write('budgetAe: $budgetAe, ')
          ..write('warnPercent: $warnPercent, ')
          ..write('itflowProjectId: $itflowProjectId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MilestonesTable extends Milestones
    with TableInfo<$MilestonesTable, Milestone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MilestonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MilestoneStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(MilestoneStatus.open.name),
      ).withConverter<MilestoneStatus>($MilestonesTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    projectId,
    title,
    order,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'milestones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Milestone> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Milestone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Milestone(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      status: $MilestonesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $MilestonesTable createAlias(String alias) {
    return $MilestonesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MilestoneStatus, String, String> $converterstatus =
      const EnumNameConverter<MilestoneStatus>(MilestoneStatus.values);
}

class Milestone extends DataClass implements Insertable<Milestone> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String projectId;
  final String title;
  final int order;
  final MilestoneStatus status;
  const Milestone({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.projectId,
    required this.title,
    required this.order,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['project_id'] = Variable<String>(projectId);
    map['title'] = Variable<String>(title);
    map['order'] = Variable<int>(order);
    {
      map['status'] = Variable<String>(
        $MilestonesTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  MilestonesCompanion toCompanion(bool nullToAbsent) {
    return MilestonesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      projectId: Value(projectId),
      title: Value(title),
      order: Value(order),
      status: Value(status),
    );
  }

  factory Milestone.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Milestone(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      projectId: serializer.fromJson<String>(json['projectId']),
      title: serializer.fromJson<String>(json['title']),
      order: serializer.fromJson<int>(json['order']),
      status: $MilestonesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'projectId': serializer.toJson<String>(projectId),
      'title': serializer.toJson<String>(title),
      'order': serializer.toJson<int>(order),
      'status': serializer.toJson<String>(
        $MilestonesTable.$converterstatus.toJson(status),
      ),
    };
  }

  Milestone copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? projectId,
    String? title,
    int? order,
    MilestoneStatus? status,
  }) => Milestone(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    projectId: projectId ?? this.projectId,
    title: title ?? this.title,
    order: order ?? this.order,
    status: status ?? this.status,
  );
  Milestone copyWithCompanion(MilestonesCompanion data) {
    return Milestone(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      title: data.title.present ? data.title.value : this.title,
      order: data.order.present ? data.order.value : this.order,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Milestone(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('order: $order, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    projectId,
    title,
    order,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Milestone &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.projectId == this.projectId &&
          other.title == this.title &&
          other.order == this.order &&
          other.status == this.status);
}

class MilestonesCompanion extends UpdateCompanion<Milestone> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> projectId;
  final Value<String> title;
  final Value<int> order;
  final Value<MilestoneStatus> status;
  final Value<int> rowid;
  const MilestonesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.order = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MilestonesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String projectId,
    required String title,
    this.order = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : projectId = Value(projectId),
       title = Value(title);
  static Insertable<Milestone> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? projectId,
    Expression<String>? title,
    Expression<int>? order,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (projectId != null) 'project_id': projectId,
      if (title != null) 'title': title,
      if (order != null) 'order': order,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MilestonesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? projectId,
    Value<String>? title,
    Value<int>? order,
    Value<MilestoneStatus>? status,
    Value<int>? rowid,
  }) {
    return MilestonesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      order: order ?? this.order,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $MilestonesTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MilestonesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('order: $order, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CriteriaTable extends Criteria
    with TableInfo<$CriteriaTable, Criterion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CriteriaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    projectId,
    label,
    done,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'criteria';
  @override
  VerificationContext validateIntegrity(
    Insertable<Criterion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Criterion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Criterion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
    );
  }

  @override
  $CriteriaTable createAlias(String alias) {
    return $CriteriaTable(attachedDatabase, alias);
  }
}

class Criterion extends DataClass implements Insertable<Criterion> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String projectId;
  final String label;
  final bool done;
  const Criterion({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.projectId,
    required this.label,
    required this.done,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['project_id'] = Variable<String>(projectId);
    map['label'] = Variable<String>(label);
    map['done'] = Variable<bool>(done);
    return map;
  }

  CriteriaCompanion toCompanion(bool nullToAbsent) {
    return CriteriaCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      projectId: Value(projectId),
      label: Value(label),
      done: Value(done),
    );
  }

  factory Criterion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Criterion(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      projectId: serializer.fromJson<String>(json['projectId']),
      label: serializer.fromJson<String>(json['label']),
      done: serializer.fromJson<bool>(json['done']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'projectId': serializer.toJson<String>(projectId),
      'label': serializer.toJson<String>(label),
      'done': serializer.toJson<bool>(done),
    };
  }

  Criterion copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? projectId,
    String? label,
    bool? done,
  }) => Criterion(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    projectId: projectId ?? this.projectId,
    label: label ?? this.label,
    done: done ?? this.done,
  );
  Criterion copyWithCompanion(CriteriaCompanion data) {
    return Criterion(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      label: data.label.present ? data.label.value : this.label,
      done: data.done.present ? data.done.value : this.done,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Criterion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('projectId: $projectId, ')
          ..write('label: $label, ')
          ..write('done: $done')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, deletedAt, projectId, label, done);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Criterion &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.projectId == this.projectId &&
          other.label == this.label &&
          other.done == this.done);
}

class CriteriaCompanion extends UpdateCompanion<Criterion> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> projectId;
  final Value<String> label;
  final Value<bool> done;
  final Value<int> rowid;
  const CriteriaCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.projectId = const Value.absent(),
    this.label = const Value.absent(),
    this.done = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CriteriaCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String projectId,
    required String label,
    this.done = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : projectId = Value(projectId),
       label = Value(label);
  static Insertable<Criterion> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? projectId,
    Expression<String>? label,
    Expression<bool>? done,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (projectId != null) 'project_id': projectId,
      if (label != null) 'label': label,
      if (done != null) 'done': done,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CriteriaCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? projectId,
    Value<String>? label,
    Value<bool>? done,
    Value<int>? rowid,
  }) {
    return CriteriaCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      projectId: projectId ?? this.projectId,
      label: label ?? this.label,
      done: done ?? this.done,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CriteriaCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('projectId: $projectId, ')
          ..write('label: $label, ')
          ..write('done: $done, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weeklyInputTargetMeta = const VerificationMeta(
    'weeklyInputTarget',
  );
  @override
  late final GeneratedColumn<int> weeklyInputTarget = GeneratedColumn<int>(
    'weekly_input_target',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<GoalStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(GoalStatus.active.name),
      ).withConverter<GoalStatus>($GoalsTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    title,
    area,
    weeklyInputTarget,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    }
    if (data.containsKey('weekly_input_target')) {
      context.handle(
        _weeklyInputTargetMeta,
        weeklyInputTarget.isAcceptableOrUnknown(
          data['weekly_input_target']!,
          _weeklyInputTargetMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area'],
      ),
      weeklyInputTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_input_target'],
      ),
      status: $GoalsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GoalStatus, String, String> $converterstatus =
      const EnumNameConverter<GoalStatus>(GoalStatus.values);
}

class Goal extends DataClass implements Insertable<Goal> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String title;
  final String? area;
  final int? weeklyInputTarget;
  final GoalStatus status;
  const Goal({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.title,
    this.area,
    this.weeklyInputTarget,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || area != null) {
      map['area'] = Variable<String>(area);
    }
    if (!nullToAbsent || weeklyInputTarget != null) {
      map['weekly_input_target'] = Variable<int>(weeklyInputTarget);
    }
    {
      map['status'] = Variable<String>(
        $GoalsTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      title: Value(title),
      area: area == null && nullToAbsent ? const Value.absent() : Value(area),
      weeklyInputTarget: weeklyInputTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(weeklyInputTarget),
      status: Value(status),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      title: serializer.fromJson<String>(json['title']),
      area: serializer.fromJson<String?>(json['area']),
      weeklyInputTarget: serializer.fromJson<int?>(json['weeklyInputTarget']),
      status: $GoalsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'title': serializer.toJson<String>(title),
      'area': serializer.toJson<String?>(area),
      'weeklyInputTarget': serializer.toJson<int?>(weeklyInputTarget),
      'status': serializer.toJson<String>(
        $GoalsTable.$converterstatus.toJson(status),
      ),
    };
  }

  Goal copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? title,
    Value<String?> area = const Value.absent(),
    Value<int?> weeklyInputTarget = const Value.absent(),
    GoalStatus? status,
  }) => Goal(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    title: title ?? this.title,
    area: area.present ? area.value : this.area,
    weeklyInputTarget: weeklyInputTarget.present
        ? weeklyInputTarget.value
        : this.weeklyInputTarget,
    status: status ?? this.status,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      title: data.title.present ? data.title.value : this.title,
      area: data.area.present ? data.area.value : this.area,
      weeklyInputTarget: data.weeklyInputTarget.present
          ? data.weeklyInputTarget.value
          : this.weeklyInputTarget,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('title: $title, ')
          ..write('area: $area, ')
          ..write('weeklyInputTarget: $weeklyInputTarget, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    title,
    area,
    weeklyInputTarget,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.title == this.title &&
          other.area == this.area &&
          other.weeklyInputTarget == this.weeklyInputTarget &&
          other.status == this.status);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> title;
  final Value<String?> area;
  final Value<int?> weeklyInputTarget;
  final Value<GoalStatus> status;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.area = const Value.absent(),
    this.weeklyInputTarget = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String title,
    this.area = const Value.absent(),
    this.weeklyInputTarget = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : title = Value(title);
  static Insertable<Goal> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? title,
    Expression<String>? area,
    Expression<int>? weeklyInputTarget,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (title != null) 'title': title,
      if (area != null) 'area': area,
      if (weeklyInputTarget != null) 'weekly_input_target': weeklyInputTarget,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? title,
    Value<String?>? area,
    Value<int?>? weeklyInputTarget,
    Value<GoalStatus>? status,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      title: title ?? this.title,
      area: area ?? this.area,
      weeklyInputTarget: weeklyInputTarget ?? this.weeklyInputTarget,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (weeklyInputTarget.present) {
      map['weekly_input_target'] = Variable<int>(weeklyInputTarget.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $GoalsTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('title: $title, ')
          ..write('area: $area, ')
          ..write('weeklyInputTarget: $weeklyInputTarget, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timesPerWeekMeta = const VerificationMeta(
    'timesPerWeek',
  );
  @override
  late final GeneratedColumn<int> timesPerWeek = GeneratedColumn<int>(
    'times_per_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    title,
    timesPerWeek,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Habit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('times_per_week')) {
      context.handle(
        _timesPerWeekMeta,
        timesPerWeek.isAcceptableOrUnknown(
          data['times_per_week']!,
          _timesPerWeekMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      timesPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_per_week'],
      )!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String title;
  final int timesPerWeek;
  const Habit({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.title,
    required this.timesPerWeek,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['title'] = Variable<String>(title);
    map['times_per_week'] = Variable<int>(timesPerWeek);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      title: Value(title),
      timesPerWeek: Value(timesPerWeek),
    );
  }

  factory Habit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      title: serializer.fromJson<String>(json['title']),
      timesPerWeek: serializer.fromJson<int>(json['timesPerWeek']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'title': serializer.toJson<String>(title),
      'timesPerWeek': serializer.toJson<int>(timesPerWeek),
    };
  }

  Habit copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? title,
    int? timesPerWeek,
  }) => Habit(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    title: title ?? this.title,
    timesPerWeek: timesPerWeek ?? this.timesPerWeek,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      title: data.title.present ? data.title.value : this.title,
      timesPerWeek: data.timesPerWeek.present
          ? data.timesPerWeek.value
          : this.timesPerWeek,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('title: $title, ')
          ..write('timesPerWeek: $timesPerWeek')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, deletedAt, title, timesPerWeek);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.title == this.title &&
          other.timesPerWeek == this.timesPerWeek);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> title;
  final Value<int> timesPerWeek;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.timesPerWeek = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String title,
    this.timesPerWeek = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : title = Value(title);
  static Insertable<Habit> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? title,
    Expression<int>? timesPerWeek,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (title != null) 'title': title,
      if (timesPerWeek != null) 'times_per_week': timesPerWeek,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? title,
    Value<int>? timesPerWeek,
    Value<int>? rowid,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      title: title ?? this.title,
      timesPerWeek: timesPerWeek ?? this.timesPerWeek,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (timesPerWeek.present) {
      map['times_per_week'] = Variable<int>(timesPerWeek.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('title: $title, ')
          ..write('timesPerWeek: $timesPerWeek, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TemplatesTable extends Templates
    with TableInfo<$TemplatesTable, Template> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titlePatternMeta = const VerificationMeta(
    'titlePattern',
  );
  @override
  late final GeneratedColumn<String> titlePattern = GeneratedColumn<String>(
    'title_pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldsMeta = const VerificationMeta('fields');
  @override
  late final GeneratedColumn<String> fields = GeneratedColumn<String>(
    'fields',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checklistMeta = const VerificationMeta(
    'checklist',
  );
  @override
  late final GeneratedColumn<String> checklist = GeneratedColumn<String>(
    'checklist',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultCustomerIdMeta = const VerificationMeta(
    'defaultCustomerId',
  );
  @override
  late final GeneratedColumn<String> defaultCustomerId =
      GeneratedColumn<String>(
        'default_customer_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES customers (id)',
        ),
      );
  static const VerificationMeta _estimateMeta = const VerificationMeta(
    'estimate',
  );
  @override
  late final GeneratedColumn<int> estimate = GeneratedColumn<int>(
    'estimate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flatRateAeMeta = const VerificationMeta(
    'flatRateAe',
  );
  @override
  late final GeneratedColumn<int> flatRateAe = GeneratedColumn<int>(
    'flat_rate_ae',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetMinutesMeta = const VerificationMeta(
    'targetMinutes',
  );
  @override
  late final GeneratedColumn<int> targetMinutes = GeneratedColumn<int>(
    'target_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    titlePattern,
    fields,
    checklist,
    defaultCustomerId,
    estimate,
    flatRateAe,
    targetMinutes,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<Template> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('title_pattern')) {
      context.handle(
        _titlePatternMeta,
        titlePattern.isAcceptableOrUnknown(
          data['title_pattern']!,
          _titlePatternMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_titlePatternMeta);
    }
    if (data.containsKey('fields')) {
      context.handle(
        _fieldsMeta,
        fields.isAcceptableOrUnknown(data['fields']!, _fieldsMeta),
      );
    }
    if (data.containsKey('checklist')) {
      context.handle(
        _checklistMeta,
        checklist.isAcceptableOrUnknown(data['checklist']!, _checklistMeta),
      );
    }
    if (data.containsKey('default_customer_id')) {
      context.handle(
        _defaultCustomerIdMeta,
        defaultCustomerId.isAcceptableOrUnknown(
          data['default_customer_id']!,
          _defaultCustomerIdMeta,
        ),
      );
    }
    if (data.containsKey('estimate')) {
      context.handle(
        _estimateMeta,
        estimate.isAcceptableOrUnknown(data['estimate']!, _estimateMeta),
      );
    }
    if (data.containsKey('flat_rate_ae')) {
      context.handle(
        _flatRateAeMeta,
        flatRateAe.isAcceptableOrUnknown(
          data['flat_rate_ae']!,
          _flatRateAeMeta,
        ),
      );
    }
    if (data.containsKey('target_minutes')) {
      context.handle(
        _targetMinutesMeta,
        targetMinutes.isAcceptableOrUnknown(
          data['target_minutes']!,
          _targetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Template map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Template(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      titlePattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_pattern'],
      )!,
      fields: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fields'],
      ),
      checklist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checklist'],
      ),
      defaultCustomerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_customer_id'],
      ),
      estimate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimate'],
      ),
      flatRateAe: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flat_rate_ae'],
      ),
      targetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_minutes'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
    );
  }

  @override
  $TemplatesTable createAlias(String alias) {
    return $TemplatesTable(attachedDatabase, alias);
  }
}

class Template extends DataClass implements Insertable<Template> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String titlePattern;

  /// JSON-encoded list of capture field definitions.
  final String? fields;

  /// JSON-encoded ordered checklist definition.
  final String? checklist;
  final String? defaultCustomerId;
  final int? estimate;
  final int? flatRateAe;
  final int? targetMinutes;
  final bool isFavorite;
  const Template({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.titlePattern,
    this.fields,
    this.checklist,
    this.defaultCustomerId,
    this.estimate,
    this.flatRateAe,
    this.targetMinutes,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    map['title_pattern'] = Variable<String>(titlePattern);
    if (!nullToAbsent || fields != null) {
      map['fields'] = Variable<String>(fields);
    }
    if (!nullToAbsent || checklist != null) {
      map['checklist'] = Variable<String>(checklist);
    }
    if (!nullToAbsent || defaultCustomerId != null) {
      map['default_customer_id'] = Variable<String>(defaultCustomerId);
    }
    if (!nullToAbsent || estimate != null) {
      map['estimate'] = Variable<int>(estimate);
    }
    if (!nullToAbsent || flatRateAe != null) {
      map['flat_rate_ae'] = Variable<int>(flatRateAe);
    }
    if (!nullToAbsent || targetMinutes != null) {
      map['target_minutes'] = Variable<int>(targetMinutes);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  TemplatesCompanion toCompanion(bool nullToAbsent) {
    return TemplatesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      titlePattern: Value(titlePattern),
      fields: fields == null && nullToAbsent
          ? const Value.absent()
          : Value(fields),
      checklist: checklist == null && nullToAbsent
          ? const Value.absent()
          : Value(checklist),
      defaultCustomerId: defaultCustomerId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultCustomerId),
      estimate: estimate == null && nullToAbsent
          ? const Value.absent()
          : Value(estimate),
      flatRateAe: flatRateAe == null && nullToAbsent
          ? const Value.absent()
          : Value(flatRateAe),
      targetMinutes: targetMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(targetMinutes),
      isFavorite: Value(isFavorite),
    );
  }

  factory Template.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Template(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      titlePattern: serializer.fromJson<String>(json['titlePattern']),
      fields: serializer.fromJson<String?>(json['fields']),
      checklist: serializer.fromJson<String?>(json['checklist']),
      defaultCustomerId: serializer.fromJson<String?>(
        json['defaultCustomerId'],
      ),
      estimate: serializer.fromJson<int?>(json['estimate']),
      flatRateAe: serializer.fromJson<int?>(json['flatRateAe']),
      targetMinutes: serializer.fromJson<int?>(json['targetMinutes']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'titlePattern': serializer.toJson<String>(titlePattern),
      'fields': serializer.toJson<String?>(fields),
      'checklist': serializer.toJson<String?>(checklist),
      'defaultCustomerId': serializer.toJson<String?>(defaultCustomerId),
      'estimate': serializer.toJson<int?>(estimate),
      'flatRateAe': serializer.toJson<int?>(flatRateAe),
      'targetMinutes': serializer.toJson<int?>(targetMinutes),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  Template copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    String? titlePattern,
    Value<String?> fields = const Value.absent(),
    Value<String?> checklist = const Value.absent(),
    Value<String?> defaultCustomerId = const Value.absent(),
    Value<int?> estimate = const Value.absent(),
    Value<int?> flatRateAe = const Value.absent(),
    Value<int?> targetMinutes = const Value.absent(),
    bool? isFavorite,
  }) => Template(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    titlePattern: titlePattern ?? this.titlePattern,
    fields: fields.present ? fields.value : this.fields,
    checklist: checklist.present ? checklist.value : this.checklist,
    defaultCustomerId: defaultCustomerId.present
        ? defaultCustomerId.value
        : this.defaultCustomerId,
    estimate: estimate.present ? estimate.value : this.estimate,
    flatRateAe: flatRateAe.present ? flatRateAe.value : this.flatRateAe,
    targetMinutes: targetMinutes.present
        ? targetMinutes.value
        : this.targetMinutes,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  Template copyWithCompanion(TemplatesCompanion data) {
    return Template(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      titlePattern: data.titlePattern.present
          ? data.titlePattern.value
          : this.titlePattern,
      fields: data.fields.present ? data.fields.value : this.fields,
      checklist: data.checklist.present ? data.checklist.value : this.checklist,
      defaultCustomerId: data.defaultCustomerId.present
          ? data.defaultCustomerId.value
          : this.defaultCustomerId,
      estimate: data.estimate.present ? data.estimate.value : this.estimate,
      flatRateAe: data.flatRateAe.present
          ? data.flatRateAe.value
          : this.flatRateAe,
      targetMinutes: data.targetMinutes.present
          ? data.targetMinutes.value
          : this.targetMinutes,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Template(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('titlePattern: $titlePattern, ')
          ..write('fields: $fields, ')
          ..write('checklist: $checklist, ')
          ..write('defaultCustomerId: $defaultCustomerId, ')
          ..write('estimate: $estimate, ')
          ..write('flatRateAe: $flatRateAe, ')
          ..write('targetMinutes: $targetMinutes, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    titlePattern,
    fields,
    checklist,
    defaultCustomerId,
    estimate,
    flatRateAe,
    targetMinutes,
    isFavorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Template &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.titlePattern == this.titlePattern &&
          other.fields == this.fields &&
          other.checklist == this.checklist &&
          other.defaultCustomerId == this.defaultCustomerId &&
          other.estimate == this.estimate &&
          other.flatRateAe == this.flatRateAe &&
          other.targetMinutes == this.targetMinutes &&
          other.isFavorite == this.isFavorite);
}

class TemplatesCompanion extends UpdateCompanion<Template> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String> titlePattern;
  final Value<String?> fields;
  final Value<String?> checklist;
  final Value<String?> defaultCustomerId;
  final Value<int?> estimate;
  final Value<int?> flatRateAe;
  final Value<int?> targetMinutes;
  final Value<bool> isFavorite;
  final Value<int> rowid;
  const TemplatesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.titlePattern = const Value.absent(),
    this.fields = const Value.absent(),
    this.checklist = const Value.absent(),
    this.defaultCustomerId = const Value.absent(),
    this.estimate = const Value.absent(),
    this.flatRateAe = const Value.absent(),
    this.targetMinutes = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TemplatesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    required String titlePattern,
    this.fields = const Value.absent(),
    this.checklist = const Value.absent(),
    this.defaultCustomerId = const Value.absent(),
    this.estimate = const Value.absent(),
    this.flatRateAe = const Value.absent(),
    this.targetMinutes = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       titlePattern = Value(titlePattern);
  static Insertable<Template> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? titlePattern,
    Expression<String>? fields,
    Expression<String>? checklist,
    Expression<String>? defaultCustomerId,
    Expression<int>? estimate,
    Expression<int>? flatRateAe,
    Expression<int>? targetMinutes,
    Expression<bool>? isFavorite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (titlePattern != null) 'title_pattern': titlePattern,
      if (fields != null) 'fields': fields,
      if (checklist != null) 'checklist': checklist,
      if (defaultCustomerId != null) 'default_customer_id': defaultCustomerId,
      if (estimate != null) 'estimate': estimate,
      if (flatRateAe != null) 'flat_rate_ae': flatRateAe,
      if (targetMinutes != null) 'target_minutes': targetMinutes,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TemplatesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String>? titlePattern,
    Value<String?>? fields,
    Value<String?>? checklist,
    Value<String?>? defaultCustomerId,
    Value<int?>? estimate,
    Value<int?>? flatRateAe,
    Value<int?>? targetMinutes,
    Value<bool>? isFavorite,
    Value<int>? rowid,
  }) {
    return TemplatesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      titlePattern: titlePattern ?? this.titlePattern,
      fields: fields ?? this.fields,
      checklist: checklist ?? this.checklist,
      defaultCustomerId: defaultCustomerId ?? this.defaultCustomerId,
      estimate: estimate ?? this.estimate,
      flatRateAe: flatRateAe ?? this.flatRateAe,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      isFavorite: isFavorite ?? this.isFavorite,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (titlePattern.present) {
      map['title_pattern'] = Variable<String>(titlePattern.value);
    }
    if (fields.present) {
      map['fields'] = Variable<String>(fields.value);
    }
    if (checklist.present) {
      map['checklist'] = Variable<String>(checklist.value);
    }
    if (defaultCustomerId.present) {
      map['default_customer_id'] = Variable<String>(defaultCustomerId.value);
    }
    if (estimate.present) {
      map['estimate'] = Variable<int>(estimate.value);
    }
    if (flatRateAe.present) {
      map['flat_rate_ae'] = Variable<int>(flatRateAe.value);
    }
    if (targetMinutes.present) {
      map['target_minutes'] = Variable<int>(targetMinutes.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplatesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('titlePattern: $titlePattern, ')
          ..write('fields: $fields, ')
          ..write('checklist: $checklist, ')
          ..write('defaultCustomerId: $defaultCustomerId, ')
          ..write('estimate: $estimate, ')
          ..write('flatRateAe: $flatRateAe, ')
          ..write('targetMinutes: $targetMinutes, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(TaskStatus.inbox.name),
      ).withConverter<TaskStatus>($TasksTable.$converterstatus);
  static const VerificationMeta _plannedDayMeta = const VerificationMeta(
    'plannedDay',
  );
  @override
  late final GeneratedColumn<DateTime> plannedDay = GeneratedColumn<DateTime>(
    'planned_day',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<DateTime> due = GeneratedColumn<DateTime>(
    'due',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importantMeta = const VerificationMeta(
    'important',
  );
  @override
  late final GeneratedColumn<bool> important = GeneratedColumn<bool>(
    'important',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("important" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _estimateMinMeta = const VerificationMeta(
    'estimateMin',
  );
  @override
  late final GeneratedColumn<int> estimateMin = GeneratedColumn<int>(
    'estimate_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskSource?, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<TaskSource?>($TasksTable.$convertersourcen);
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _milestoneIdMeta = const VerificationMeta(
    'milestoneId',
  );
  @override
  late final GeneratedColumn<String> milestoneId = GeneratedColumn<String>(
    'milestone_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES milestones (id)',
    ),
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goals (id)',
    ),
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES templates (id)',
    ),
  );
  static const VerificationMeta _itflowTicketIdMeta = const VerificationMeta(
    'itflowTicketId',
  );
  @override
  late final GeneratedColumn<int> itflowTicketId = GeneratedColumn<int>(
    'itflow_ticket_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waitingForMeta = const VerificationMeta(
    'waitingFor',
  );
  @override
  late final GeneratedColumn<String> waitingFor = GeneratedColumn<String>(
    'waiting_for',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waitingSinceMeta = const VerificationMeta(
    'waitingSince',
  );
  @override
  late final GeneratedColumn<DateTime> waitingSince = GeneratedColumn<DateTime>(
    'waiting_since',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _followUpDateMeta = const VerificationMeta(
    'followUpDate',
  );
  @override
  late final GeneratedColumn<DateTime> followUpDate = GeneratedColumn<DateTime>(
    'follow_up_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurrenceMeta = const VerificationMeta(
    'recurrence',
  );
  @override
  late final GeneratedColumn<String> recurrence = GeneratedColumn<String>(
    'recurrence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    title,
    status,
    plannedDay,
    order,
    due,
    important,
    estimateMin,
    source,
    customerId,
    projectId,
    milestoneId,
    goalId,
    templateId,
    itflowTicketId,
    waitingFor,
    waitingSince,
    followUpDate,
    recurrence,
    tags,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('planned_day')) {
      context.handle(
        _plannedDayMeta,
        plannedDay.isAcceptableOrUnknown(data['planned_day']!, _plannedDayMeta),
      );
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    }
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    }
    if (data.containsKey('important')) {
      context.handle(
        _importantMeta,
        important.isAcceptableOrUnknown(data['important']!, _importantMeta),
      );
    }
    if (data.containsKey('estimate_min')) {
      context.handle(
        _estimateMinMeta,
        estimateMin.isAcceptableOrUnknown(
          data['estimate_min']!,
          _estimateMinMeta,
        ),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('milestone_id')) {
      context.handle(
        _milestoneIdMeta,
        milestoneId.isAcceptableOrUnknown(
          data['milestone_id']!,
          _milestoneIdMeta,
        ),
      );
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    if (data.containsKey('itflow_ticket_id')) {
      context.handle(
        _itflowTicketIdMeta,
        itflowTicketId.isAcceptableOrUnknown(
          data['itflow_ticket_id']!,
          _itflowTicketIdMeta,
        ),
      );
    }
    if (data.containsKey('waiting_for')) {
      context.handle(
        _waitingForMeta,
        waitingFor.isAcceptableOrUnknown(data['waiting_for']!, _waitingForMeta),
      );
    }
    if (data.containsKey('waiting_since')) {
      context.handle(
        _waitingSinceMeta,
        waitingSince.isAcceptableOrUnknown(
          data['waiting_since']!,
          _waitingSinceMeta,
        ),
      );
    }
    if (data.containsKey('follow_up_date')) {
      context.handle(
        _followUpDateMeta,
        followUpDate.isAcceptableOrUnknown(
          data['follow_up_date']!,
          _followUpDateMeta,
        ),
      );
    }
    if (data.containsKey('recurrence')) {
      context.handle(
        _recurrenceMeta,
        recurrence.isAcceptableOrUnknown(data['recurrence']!, _recurrenceMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      status: $TasksTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      plannedDay: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planned_day'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due'],
      ),
      important: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}important'],
      )!,
      estimateMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimate_min'],
      ),
      source: $TasksTable.$convertersourcen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        ),
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      ),
      milestoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}milestone_id'],
      ),
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      ),
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      ),
      itflowTicketId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}itflow_ticket_id'],
      ),
      waitingFor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}waiting_for'],
      ),
      waitingSince: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}waiting_since'],
      ),
      followUpDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}follow_up_date'],
      ),
      recurrence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskStatus, String, String> $converterstatus =
      const EnumNameConverter<TaskStatus>(TaskStatus.values);
  static JsonTypeConverter2<TaskSource, String, String> $convertersource =
      const EnumNameConverter<TaskSource>(TaskSource.values);
  static JsonTypeConverter2<TaskSource?, String?, String?> $convertersourcen =
      JsonTypeConverter2.asNullable($convertersource);
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String title;
  final TaskStatus status;
  final DateTime? plannedDay;
  final int order;
  final DateTime? due;
  final bool important;
  final int? estimateMin;
  final TaskSource? source;
  final String? customerId;
  final String? projectId;
  final String? milestoneId;
  final String? goalId;
  final String? templateId;
  final int? itflowTicketId;
  final String? waitingFor;
  final DateTime? waitingSince;
  final DateTime? followUpDate;

  /// Recurrence rule, stored as text.
  final String? recurrence;

  /// JSON-encoded list of tags.
  final String? tags;
  const Task({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.title,
    required this.status,
    this.plannedDay,
    required this.order,
    this.due,
    required this.important,
    this.estimateMin,
    this.source,
    this.customerId,
    this.projectId,
    this.milestoneId,
    this.goalId,
    this.templateId,
    this.itflowTicketId,
    this.waitingFor,
    this.waitingSince,
    this.followUpDate,
    this.recurrence,
    this.tags,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['title'] = Variable<String>(title);
    {
      map['status'] = Variable<String>(
        $TasksTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || plannedDay != null) {
      map['planned_day'] = Variable<DateTime>(plannedDay);
    }
    map['order'] = Variable<int>(order);
    if (!nullToAbsent || due != null) {
      map['due'] = Variable<DateTime>(due);
    }
    map['important'] = Variable<bool>(important);
    if (!nullToAbsent || estimateMin != null) {
      map['estimate_min'] = Variable<int>(estimateMin);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(
        $TasksTable.$convertersourcen.toSql(source),
      );
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    if (!nullToAbsent || milestoneId != null) {
      map['milestone_id'] = Variable<String>(milestoneId);
    }
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<String>(goalId);
    }
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<String>(templateId);
    }
    if (!nullToAbsent || itflowTicketId != null) {
      map['itflow_ticket_id'] = Variable<int>(itflowTicketId);
    }
    if (!nullToAbsent || waitingFor != null) {
      map['waiting_for'] = Variable<String>(waitingFor);
    }
    if (!nullToAbsent || waitingSince != null) {
      map['waiting_since'] = Variable<DateTime>(waitingSince);
    }
    if (!nullToAbsent || followUpDate != null) {
      map['follow_up_date'] = Variable<DateTime>(followUpDate);
    }
    if (!nullToAbsent || recurrence != null) {
      map['recurrence'] = Variable<String>(recurrence);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      title: Value(title),
      status: Value(status),
      plannedDay: plannedDay == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedDay),
      order: Value(order),
      due: due == null && nullToAbsent ? const Value.absent() : Value(due),
      important: Value(important),
      estimateMin: estimateMin == null && nullToAbsent
          ? const Value.absent()
          : Value(estimateMin),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      milestoneId: milestoneId == null && nullToAbsent
          ? const Value.absent()
          : Value(milestoneId),
      goalId: goalId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalId),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      itflowTicketId: itflowTicketId == null && nullToAbsent
          ? const Value.absent()
          : Value(itflowTicketId),
      waitingFor: waitingFor == null && nullToAbsent
          ? const Value.absent()
          : Value(waitingFor),
      waitingSince: waitingSince == null && nullToAbsent
          ? const Value.absent()
          : Value(waitingSince),
      followUpDate: followUpDate == null && nullToAbsent
          ? const Value.absent()
          : Value(followUpDate),
      recurrence: recurrence == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrence),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      title: serializer.fromJson<String>(json['title']),
      status: $TasksTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      plannedDay: serializer.fromJson<DateTime?>(json['plannedDay']),
      order: serializer.fromJson<int>(json['order']),
      due: serializer.fromJson<DateTime?>(json['due']),
      important: serializer.fromJson<bool>(json['important']),
      estimateMin: serializer.fromJson<int?>(json['estimateMin']),
      source: $TasksTable.$convertersourcen.fromJson(
        serializer.fromJson<String?>(json['source']),
      ),
      customerId: serializer.fromJson<String?>(json['customerId']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      milestoneId: serializer.fromJson<String?>(json['milestoneId']),
      goalId: serializer.fromJson<String?>(json['goalId']),
      templateId: serializer.fromJson<String?>(json['templateId']),
      itflowTicketId: serializer.fromJson<int?>(json['itflowTicketId']),
      waitingFor: serializer.fromJson<String?>(json['waitingFor']),
      waitingSince: serializer.fromJson<DateTime?>(json['waitingSince']),
      followUpDate: serializer.fromJson<DateTime?>(json['followUpDate']),
      recurrence: serializer.fromJson<String?>(json['recurrence']),
      tags: serializer.fromJson<String?>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'title': serializer.toJson<String>(title),
      'status': serializer.toJson<String>(
        $TasksTable.$converterstatus.toJson(status),
      ),
      'plannedDay': serializer.toJson<DateTime?>(plannedDay),
      'order': serializer.toJson<int>(order),
      'due': serializer.toJson<DateTime?>(due),
      'important': serializer.toJson<bool>(important),
      'estimateMin': serializer.toJson<int?>(estimateMin),
      'source': serializer.toJson<String?>(
        $TasksTable.$convertersourcen.toJson(source),
      ),
      'customerId': serializer.toJson<String?>(customerId),
      'projectId': serializer.toJson<String?>(projectId),
      'milestoneId': serializer.toJson<String?>(milestoneId),
      'goalId': serializer.toJson<String?>(goalId),
      'templateId': serializer.toJson<String?>(templateId),
      'itflowTicketId': serializer.toJson<int?>(itflowTicketId),
      'waitingFor': serializer.toJson<String?>(waitingFor),
      'waitingSince': serializer.toJson<DateTime?>(waitingSince),
      'followUpDate': serializer.toJson<DateTime?>(followUpDate),
      'recurrence': serializer.toJson<String?>(recurrence),
      'tags': serializer.toJson<String?>(tags),
    };
  }

  Task copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? title,
    TaskStatus? status,
    Value<DateTime?> plannedDay = const Value.absent(),
    int? order,
    Value<DateTime?> due = const Value.absent(),
    bool? important,
    Value<int?> estimateMin = const Value.absent(),
    Value<TaskSource?> source = const Value.absent(),
    Value<String?> customerId = const Value.absent(),
    Value<String?> projectId = const Value.absent(),
    Value<String?> milestoneId = const Value.absent(),
    Value<String?> goalId = const Value.absent(),
    Value<String?> templateId = const Value.absent(),
    Value<int?> itflowTicketId = const Value.absent(),
    Value<String?> waitingFor = const Value.absent(),
    Value<DateTime?> waitingSince = const Value.absent(),
    Value<DateTime?> followUpDate = const Value.absent(),
    Value<String?> recurrence = const Value.absent(),
    Value<String?> tags = const Value.absent(),
  }) => Task(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    title: title ?? this.title,
    status: status ?? this.status,
    plannedDay: plannedDay.present ? plannedDay.value : this.plannedDay,
    order: order ?? this.order,
    due: due.present ? due.value : this.due,
    important: important ?? this.important,
    estimateMin: estimateMin.present ? estimateMin.value : this.estimateMin,
    source: source.present ? source.value : this.source,
    customerId: customerId.present ? customerId.value : this.customerId,
    projectId: projectId.present ? projectId.value : this.projectId,
    milestoneId: milestoneId.present ? milestoneId.value : this.milestoneId,
    goalId: goalId.present ? goalId.value : this.goalId,
    templateId: templateId.present ? templateId.value : this.templateId,
    itflowTicketId: itflowTicketId.present
        ? itflowTicketId.value
        : this.itflowTicketId,
    waitingFor: waitingFor.present ? waitingFor.value : this.waitingFor,
    waitingSince: waitingSince.present ? waitingSince.value : this.waitingSince,
    followUpDate: followUpDate.present ? followUpDate.value : this.followUpDate,
    recurrence: recurrence.present ? recurrence.value : this.recurrence,
    tags: tags.present ? tags.value : this.tags,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
      plannedDay: data.plannedDay.present
          ? data.plannedDay.value
          : this.plannedDay,
      order: data.order.present ? data.order.value : this.order,
      due: data.due.present ? data.due.value : this.due,
      important: data.important.present ? data.important.value : this.important,
      estimateMin: data.estimateMin.present
          ? data.estimateMin.value
          : this.estimateMin,
      source: data.source.present ? data.source.value : this.source,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      milestoneId: data.milestoneId.present
          ? data.milestoneId.value
          : this.milestoneId,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      itflowTicketId: data.itflowTicketId.present
          ? data.itflowTicketId.value
          : this.itflowTicketId,
      waitingFor: data.waitingFor.present
          ? data.waitingFor.value
          : this.waitingFor,
      waitingSince: data.waitingSince.present
          ? data.waitingSince.value
          : this.waitingSince,
      followUpDate: data.followUpDate.present
          ? data.followUpDate.value
          : this.followUpDate,
      recurrence: data.recurrence.present
          ? data.recurrence.value
          : this.recurrence,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('plannedDay: $plannedDay, ')
          ..write('order: $order, ')
          ..write('due: $due, ')
          ..write('important: $important, ')
          ..write('estimateMin: $estimateMin, ')
          ..write('source: $source, ')
          ..write('customerId: $customerId, ')
          ..write('projectId: $projectId, ')
          ..write('milestoneId: $milestoneId, ')
          ..write('goalId: $goalId, ')
          ..write('templateId: $templateId, ')
          ..write('itflowTicketId: $itflowTicketId, ')
          ..write('waitingFor: $waitingFor, ')
          ..write('waitingSince: $waitingSince, ')
          ..write('followUpDate: $followUpDate, ')
          ..write('recurrence: $recurrence, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    createdAt,
    updatedAt,
    deletedAt,
    title,
    status,
    plannedDay,
    order,
    due,
    important,
    estimateMin,
    source,
    customerId,
    projectId,
    milestoneId,
    goalId,
    templateId,
    itflowTicketId,
    waitingFor,
    waitingSince,
    followUpDate,
    recurrence,
    tags,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.title == this.title &&
          other.status == this.status &&
          other.plannedDay == this.plannedDay &&
          other.order == this.order &&
          other.due == this.due &&
          other.important == this.important &&
          other.estimateMin == this.estimateMin &&
          other.source == this.source &&
          other.customerId == this.customerId &&
          other.projectId == this.projectId &&
          other.milestoneId == this.milestoneId &&
          other.goalId == this.goalId &&
          other.templateId == this.templateId &&
          other.itflowTicketId == this.itflowTicketId &&
          other.waitingFor == this.waitingFor &&
          other.waitingSince == this.waitingSince &&
          other.followUpDate == this.followUpDate &&
          other.recurrence == this.recurrence &&
          other.tags == this.tags);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> title;
  final Value<TaskStatus> status;
  final Value<DateTime?> plannedDay;
  final Value<int> order;
  final Value<DateTime?> due;
  final Value<bool> important;
  final Value<int?> estimateMin;
  final Value<TaskSource?> source;
  final Value<String?> customerId;
  final Value<String?> projectId;
  final Value<String?> milestoneId;
  final Value<String?> goalId;
  final Value<String?> templateId;
  final Value<int?> itflowTicketId;
  final Value<String?> waitingFor;
  final Value<DateTime?> waitingSince;
  final Value<DateTime?> followUpDate;
  final Value<String?> recurrence;
  final Value<String?> tags;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.plannedDay = const Value.absent(),
    this.order = const Value.absent(),
    this.due = const Value.absent(),
    this.important = const Value.absent(),
    this.estimateMin = const Value.absent(),
    this.source = const Value.absent(),
    this.customerId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.milestoneId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.itflowTicketId = const Value.absent(),
    this.waitingFor = const Value.absent(),
    this.waitingSince = const Value.absent(),
    this.followUpDate = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String title,
    this.status = const Value.absent(),
    this.plannedDay = const Value.absent(),
    this.order = const Value.absent(),
    this.due = const Value.absent(),
    this.important = const Value.absent(),
    this.estimateMin = const Value.absent(),
    this.source = const Value.absent(),
    this.customerId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.milestoneId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.itflowTicketId = const Value.absent(),
    this.waitingFor = const Value.absent(),
    this.waitingSince = const Value.absent(),
    this.followUpDate = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : title = Value(title);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? title,
    Expression<String>? status,
    Expression<DateTime>? plannedDay,
    Expression<int>? order,
    Expression<DateTime>? due,
    Expression<bool>? important,
    Expression<int>? estimateMin,
    Expression<String>? source,
    Expression<String>? customerId,
    Expression<String>? projectId,
    Expression<String>? milestoneId,
    Expression<String>? goalId,
    Expression<String>? templateId,
    Expression<int>? itflowTicketId,
    Expression<String>? waitingFor,
    Expression<DateTime>? waitingSince,
    Expression<DateTime>? followUpDate,
    Expression<String>? recurrence,
    Expression<String>? tags,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (plannedDay != null) 'planned_day': plannedDay,
      if (order != null) 'order': order,
      if (due != null) 'due': due,
      if (important != null) 'important': important,
      if (estimateMin != null) 'estimate_min': estimateMin,
      if (source != null) 'source': source,
      if (customerId != null) 'customer_id': customerId,
      if (projectId != null) 'project_id': projectId,
      if (milestoneId != null) 'milestone_id': milestoneId,
      if (goalId != null) 'goal_id': goalId,
      if (templateId != null) 'template_id': templateId,
      if (itflowTicketId != null) 'itflow_ticket_id': itflowTicketId,
      if (waitingFor != null) 'waiting_for': waitingFor,
      if (waitingSince != null) 'waiting_since': waitingSince,
      if (followUpDate != null) 'follow_up_date': followUpDate,
      if (recurrence != null) 'recurrence': recurrence,
      if (tags != null) 'tags': tags,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? title,
    Value<TaskStatus>? status,
    Value<DateTime?>? plannedDay,
    Value<int>? order,
    Value<DateTime?>? due,
    Value<bool>? important,
    Value<int?>? estimateMin,
    Value<TaskSource?>? source,
    Value<String?>? customerId,
    Value<String?>? projectId,
    Value<String?>? milestoneId,
    Value<String?>? goalId,
    Value<String?>? templateId,
    Value<int?>? itflowTicketId,
    Value<String?>? waitingFor,
    Value<DateTime?>? waitingSince,
    Value<DateTime?>? followUpDate,
    Value<String?>? recurrence,
    Value<String?>? tags,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      title: title ?? this.title,
      status: status ?? this.status,
      plannedDay: plannedDay ?? this.plannedDay,
      order: order ?? this.order,
      due: due ?? this.due,
      important: important ?? this.important,
      estimateMin: estimateMin ?? this.estimateMin,
      source: source ?? this.source,
      customerId: customerId ?? this.customerId,
      projectId: projectId ?? this.projectId,
      milestoneId: milestoneId ?? this.milestoneId,
      goalId: goalId ?? this.goalId,
      templateId: templateId ?? this.templateId,
      itflowTicketId: itflowTicketId ?? this.itflowTicketId,
      waitingFor: waitingFor ?? this.waitingFor,
      waitingSince: waitingSince ?? this.waitingSince,
      followUpDate: followUpDate ?? this.followUpDate,
      recurrence: recurrence ?? this.recurrence,
      tags: tags ?? this.tags,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $TasksTable.$converterstatus.toSql(status.value),
      );
    }
    if (plannedDay.present) {
      map['planned_day'] = Variable<DateTime>(plannedDay.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (due.present) {
      map['due'] = Variable<DateTime>(due.value);
    }
    if (important.present) {
      map['important'] = Variable<bool>(important.value);
    }
    if (estimateMin.present) {
      map['estimate_min'] = Variable<int>(estimateMin.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $TasksTable.$convertersourcen.toSql(source.value),
      );
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (milestoneId.present) {
      map['milestone_id'] = Variable<String>(milestoneId.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (itflowTicketId.present) {
      map['itflow_ticket_id'] = Variable<int>(itflowTicketId.value);
    }
    if (waitingFor.present) {
      map['waiting_for'] = Variable<String>(waitingFor.value);
    }
    if (waitingSince.present) {
      map['waiting_since'] = Variable<DateTime>(waitingSince.value);
    }
    if (followUpDate.present) {
      map['follow_up_date'] = Variable<DateTime>(followUpDate.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(recurrence.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('plannedDay: $plannedDay, ')
          ..write('order: $order, ')
          ..write('due: $due, ')
          ..write('important: $important, ')
          ..write('estimateMin: $estimateMin, ')
          ..write('source: $source, ')
          ..write('customerId: $customerId, ')
          ..write('projectId: $projectId, ')
          ..write('milestoneId: $milestoneId, ')
          ..write('goalId: $goalId, ')
          ..write('templateId: $templateId, ')
          ..write('itflowTicketId: $itflowTicketId, ')
          ..write('waitingFor: $waitingFor, ')
          ..write('waitingSince: $waitingSince, ')
          ..write('followUpDate: $followUpDate, ')
          ..write('recurrence: $recurrence, ')
          ..write('tags: $tags, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChecklistItemsTable extends ChecklistItems
    with TableInfo<$ChecklistItemsTable, ChecklistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _requiredMeta = const VerificationMeta(
    'required',
  );
  @override
  late final GeneratedColumn<bool> required = GeneratedColumn<bool>(
    'required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("required" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<DateTime> doneAt = GeneratedColumn<DateTime>(
    'done_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    taskId,
    label,
    order,
    required,
    done,
    doneAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChecklistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    }
    if (data.containsKey('required')) {
      context.handle(
        _requiredMeta,
        required.isAcceptableOrUnknown(data['required']!, _requiredMeta),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      required: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}required'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}done_at'],
      ),
    );
  }

  @override
  $ChecklistItemsTable createAlias(String alias) {
    return $ChecklistItemsTable(attachedDatabase, alias);
  }
}

class ChecklistItem extends DataClass implements Insertable<ChecklistItem> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String taskId;
  final String label;
  final int order;
  final bool required;
  final bool done;
  final DateTime? doneAt;
  const ChecklistItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.taskId,
    required this.label,
    required this.order,
    required this.required,
    required this.done,
    this.doneAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['task_id'] = Variable<String>(taskId);
    map['label'] = Variable<String>(label);
    map['order'] = Variable<int>(order);
    map['required'] = Variable<bool>(required);
    map['done'] = Variable<bool>(done);
    if (!nullToAbsent || doneAt != null) {
      map['done_at'] = Variable<DateTime>(doneAt);
    }
    return map;
  }

  ChecklistItemsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistItemsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      taskId: Value(taskId),
      label: Value(label),
      order: Value(order),
      required: Value(required),
      done: Value(done),
      doneAt: doneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(doneAt),
    );
  }

  factory ChecklistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistItem(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      taskId: serializer.fromJson<String>(json['taskId']),
      label: serializer.fromJson<String>(json['label']),
      order: serializer.fromJson<int>(json['order']),
      required: serializer.fromJson<bool>(json['required']),
      done: serializer.fromJson<bool>(json['done']),
      doneAt: serializer.fromJson<DateTime?>(json['doneAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'taskId': serializer.toJson<String>(taskId),
      'label': serializer.toJson<String>(label),
      'order': serializer.toJson<int>(order),
      'required': serializer.toJson<bool>(required),
      'done': serializer.toJson<bool>(done),
      'doneAt': serializer.toJson<DateTime?>(doneAt),
    };
  }

  ChecklistItem copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? taskId,
    String? label,
    int? order,
    bool? required,
    bool? done,
    Value<DateTime?> doneAt = const Value.absent(),
  }) => ChecklistItem(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    taskId: taskId ?? this.taskId,
    label: label ?? this.label,
    order: order ?? this.order,
    required: required ?? this.required,
    done: done ?? this.done,
    doneAt: doneAt.present ? doneAt.value : this.doneAt,
  );
  ChecklistItem copyWithCompanion(ChecklistItemsCompanion data) {
    return ChecklistItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      label: data.label.present ? data.label.value : this.label,
      order: data.order.present ? data.order.value : this.order,
      required: data.required.present ? data.required.value : this.required,
      done: data.done.present ? data.done.value : this.done,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItem(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('taskId: $taskId, ')
          ..write('label: $label, ')
          ..write('order: $order, ')
          ..write('required: $required, ')
          ..write('done: $done, ')
          ..write('doneAt: $doneAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    taskId,
    label,
    order,
    required,
    done,
    doneAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.taskId == this.taskId &&
          other.label == this.label &&
          other.order == this.order &&
          other.required == this.required &&
          other.done == this.done &&
          other.doneAt == this.doneAt);
}

class ChecklistItemsCompanion extends UpdateCompanion<ChecklistItem> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> taskId;
  final Value<String> label;
  final Value<int> order;
  final Value<bool> required;
  final Value<bool> done;
  final Value<DateTime?> doneAt;
  final Value<int> rowid;
  const ChecklistItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.taskId = const Value.absent(),
    this.label = const Value.absent(),
    this.order = const Value.absent(),
    this.required = const Value.absent(),
    this.done = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChecklistItemsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String taskId,
    required String label,
    this.order = const Value.absent(),
    this.required = const Value.absent(),
    this.done = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       label = Value(label);
  static Insertable<ChecklistItem> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? taskId,
    Expression<String>? label,
    Expression<int>? order,
    Expression<bool>? required,
    Expression<bool>? done,
    Expression<DateTime>? doneAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (taskId != null) 'task_id': taskId,
      if (label != null) 'label': label,
      if (order != null) 'order': order,
      if (required != null) 'required': required,
      if (done != null) 'done': done,
      if (doneAt != null) 'done_at': doneAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChecklistItemsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? taskId,
    Value<String>? label,
    Value<int>? order,
    Value<bool>? required,
    Value<bool>? done,
    Value<DateTime?>? doneAt,
    Value<int>? rowid,
  }) {
    return ChecklistItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      taskId: taskId ?? this.taskId,
      label: label ?? this.label,
      order: order ?? this.order,
      required: required ?? this.required,
      done: done ?? this.done,
      doneAt: doneAt ?? this.doneAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (required.present) {
      map['required'] = Variable<bool>(required.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<DateTime>(doneAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('taskId: $taskId, ')
          ..write('label: $label, ')
          ..write('order: $order, ')
          ..write('required: $required, ')
          ..write('done: $done, ')
          ..write('doneAt: $doneAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimeEntriesTable extends TimeEntries
    with TableInfo<$TimeEntriesTable, TimeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
    'start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<DateTime> end = GeneratedColumn<DateTime>(
    'end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TimeEntryKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(TimeEntryKind.active.name),
      ).withConverter<TimeEntryKind>($TimeEntriesTable.$converterkind);
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goals (id)',
    ),
  );
  static const VerificationMeta _billableMeta = const VerificationMeta(
    'billable',
  );
  @override
  late final GeneratedColumn<bool> billable = GeneratedColumn<bool>(
    'billable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("billable" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ticketIdMeta = const VerificationMeta(
    'ticketId',
  );
  @override
  late final GeneratedColumn<int> ticketId = GeneratedColumn<int>(
    'ticket_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedToItflowMeta = const VerificationMeta(
    'syncedToItflow',
  );
  @override
  late final GeneratedColumn<bool> syncedToItflow = GeneratedColumn<bool>(
    'synced_to_itflow',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced_to_itflow" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    start,
    end,
    kind,
    category,
    customerId,
    taskId,
    projectId,
    goalId,
    billable,
    note,
    ticketId,
    syncedToItflow,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('start')) {
      context.handle(
        _startMeta,
        start.isAcceptableOrUnknown(data['start']!, _startMeta),
      );
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
        _endMeta,
        end.isAcceptableOrUnknown(data['end']!, _endMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    }
    if (data.containsKey('billable')) {
      context.handle(
        _billableMeta,
        billable.isAcceptableOrUnknown(data['billable']!, _billableMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('ticket_id')) {
      context.handle(
        _ticketIdMeta,
        ticketId.isAcceptableOrUnknown(data['ticket_id']!, _ticketIdMeta),
      );
    }
    if (data.containsKey('synced_to_itflow')) {
      context.handle(
        _syncedToItflowMeta,
        syncedToItflow.isAcceptableOrUnknown(
          data['synced_to_itflow']!,
          _syncedToItflowMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      start: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start'],
      )!,
      end: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end'],
      ),
      kind: $TimeEntriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      ),
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      ),
      billable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}billable'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      ticketId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ticket_id'],
      ),
      syncedToItflow: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced_to_itflow'],
      )!,
    );
  }

  @override
  $TimeEntriesTable createAlias(String alias) {
    return $TimeEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TimeEntryKind, String, String> $converterkind =
      const EnumNameConverter<TimeEntryKind>(TimeEntryKind.values);
}

class TimeEntry extends DataClass implements Insertable<TimeEntry> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime start;

  /// Null while the timer is still running.
  final DateTime? end;
  final TimeEntryKind kind;
  final String? category;
  final String? customerId;
  final String? taskId;
  final String? projectId;
  final String? goalId;
  final bool billable;
  final String? note;
  final int? ticketId;
  final bool syncedToItflow;
  const TimeEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.start,
    this.end,
    required this.kind,
    this.category,
    this.customerId,
    this.taskId,
    this.projectId,
    this.goalId,
    required this.billable,
    this.note,
    this.ticketId,
    required this.syncedToItflow,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['start'] = Variable<DateTime>(start);
    if (!nullToAbsent || end != null) {
      map['end'] = Variable<DateTime>(end);
    }
    {
      map['kind'] = Variable<String>(
        $TimeEntriesTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<String>(goalId);
    }
    map['billable'] = Variable<bool>(billable);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || ticketId != null) {
      map['ticket_id'] = Variable<int>(ticketId);
    }
    map['synced_to_itflow'] = Variable<bool>(syncedToItflow);
    return map;
  }

  TimeEntriesCompanion toCompanion(bool nullToAbsent) {
    return TimeEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      start: Value(start),
      end: end == null && nullToAbsent ? const Value.absent() : Value(end),
      kind: Value(kind),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      goalId: goalId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalId),
      billable: Value(billable),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      ticketId: ticketId == null && nullToAbsent
          ? const Value.absent()
          : Value(ticketId),
      syncedToItflow: Value(syncedToItflow),
    );
  }

  factory TimeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimeEntry(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      start: serializer.fromJson<DateTime>(json['start']),
      end: serializer.fromJson<DateTime?>(json['end']),
      kind: $TimeEntriesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      category: serializer.fromJson<String?>(json['category']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      goalId: serializer.fromJson<String?>(json['goalId']),
      billable: serializer.fromJson<bool>(json['billable']),
      note: serializer.fromJson<String?>(json['note']),
      ticketId: serializer.fromJson<int?>(json['ticketId']),
      syncedToItflow: serializer.fromJson<bool>(json['syncedToItflow']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'start': serializer.toJson<DateTime>(start),
      'end': serializer.toJson<DateTime?>(end),
      'kind': serializer.toJson<String>(
        $TimeEntriesTable.$converterkind.toJson(kind),
      ),
      'category': serializer.toJson<String?>(category),
      'customerId': serializer.toJson<String?>(customerId),
      'taskId': serializer.toJson<String?>(taskId),
      'projectId': serializer.toJson<String?>(projectId),
      'goalId': serializer.toJson<String?>(goalId),
      'billable': serializer.toJson<bool>(billable),
      'note': serializer.toJson<String?>(note),
      'ticketId': serializer.toJson<int?>(ticketId),
      'syncedToItflow': serializer.toJson<bool>(syncedToItflow),
    };
  }

  TimeEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? start,
    Value<DateTime?> end = const Value.absent(),
    TimeEntryKind? kind,
    Value<String?> category = const Value.absent(),
    Value<String?> customerId = const Value.absent(),
    Value<String?> taskId = const Value.absent(),
    Value<String?> projectId = const Value.absent(),
    Value<String?> goalId = const Value.absent(),
    bool? billable,
    Value<String?> note = const Value.absent(),
    Value<int?> ticketId = const Value.absent(),
    bool? syncedToItflow,
  }) => TimeEntry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    start: start ?? this.start,
    end: end.present ? end.value : this.end,
    kind: kind ?? this.kind,
    category: category.present ? category.value : this.category,
    customerId: customerId.present ? customerId.value : this.customerId,
    taskId: taskId.present ? taskId.value : this.taskId,
    projectId: projectId.present ? projectId.value : this.projectId,
    goalId: goalId.present ? goalId.value : this.goalId,
    billable: billable ?? this.billable,
    note: note.present ? note.value : this.note,
    ticketId: ticketId.present ? ticketId.value : this.ticketId,
    syncedToItflow: syncedToItflow ?? this.syncedToItflow,
  );
  TimeEntry copyWithCompanion(TimeEntriesCompanion data) {
    return TimeEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      start: data.start.present ? data.start.value : this.start,
      end: data.end.present ? data.end.value : this.end,
      kind: data.kind.present ? data.kind.value : this.kind,
      category: data.category.present ? data.category.value : this.category,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      billable: data.billable.present ? data.billable.value : this.billable,
      note: data.note.present ? data.note.value : this.note,
      ticketId: data.ticketId.present ? data.ticketId.value : this.ticketId,
      syncedToItflow: data.syncedToItflow.present
          ? data.syncedToItflow.value
          : this.syncedToItflow,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimeEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('kind: $kind, ')
          ..write('category: $category, ')
          ..write('customerId: $customerId, ')
          ..write('taskId: $taskId, ')
          ..write('projectId: $projectId, ')
          ..write('goalId: $goalId, ')
          ..write('billable: $billable, ')
          ..write('note: $note, ')
          ..write('ticketId: $ticketId, ')
          ..write('syncedToItflow: $syncedToItflow')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    start,
    end,
    kind,
    category,
    customerId,
    taskId,
    projectId,
    goalId,
    billable,
    note,
    ticketId,
    syncedToItflow,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.start == this.start &&
          other.end == this.end &&
          other.kind == this.kind &&
          other.category == this.category &&
          other.customerId == this.customerId &&
          other.taskId == this.taskId &&
          other.projectId == this.projectId &&
          other.goalId == this.goalId &&
          other.billable == this.billable &&
          other.note == this.note &&
          other.ticketId == this.ticketId &&
          other.syncedToItflow == this.syncedToItflow);
}

class TimeEntriesCompanion extends UpdateCompanion<TimeEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> start;
  final Value<DateTime?> end;
  final Value<TimeEntryKind> kind;
  final Value<String?> category;
  final Value<String?> customerId;
  final Value<String?> taskId;
  final Value<String?> projectId;
  final Value<String?> goalId;
  final Value<bool> billable;
  final Value<String?> note;
  final Value<int?> ticketId;
  final Value<bool> syncedToItflow;
  final Value<int> rowid;
  const TimeEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.kind = const Value.absent(),
    this.category = const Value.absent(),
    this.customerId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.billable = const Value.absent(),
    this.note = const Value.absent(),
    this.ticketId = const Value.absent(),
    this.syncedToItflow = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimeEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime start,
    this.end = const Value.absent(),
    this.kind = const Value.absent(),
    this.category = const Value.absent(),
    this.customerId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.billable = const Value.absent(),
    this.note = const Value.absent(),
    this.ticketId = const Value.absent(),
    this.syncedToItflow = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : start = Value(start);
  static Insertable<TimeEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? start,
    Expression<DateTime>? end,
    Expression<String>? kind,
    Expression<String>? category,
    Expression<String>? customerId,
    Expression<String>? taskId,
    Expression<String>? projectId,
    Expression<String>? goalId,
    Expression<bool>? billable,
    Expression<String>? note,
    Expression<int>? ticketId,
    Expression<bool>? syncedToItflow,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (kind != null) 'kind': kind,
      if (category != null) 'category': category,
      if (customerId != null) 'customer_id': customerId,
      if (taskId != null) 'task_id': taskId,
      if (projectId != null) 'project_id': projectId,
      if (goalId != null) 'goal_id': goalId,
      if (billable != null) 'billable': billable,
      if (note != null) 'note': note,
      if (ticketId != null) 'ticket_id': ticketId,
      if (syncedToItflow != null) 'synced_to_itflow': syncedToItflow,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimeEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? start,
    Value<DateTime?>? end,
    Value<TimeEntryKind>? kind,
    Value<String?>? category,
    Value<String?>? customerId,
    Value<String?>? taskId,
    Value<String?>? projectId,
    Value<String?>? goalId,
    Value<bool>? billable,
    Value<String?>? note,
    Value<int?>? ticketId,
    Value<bool>? syncedToItflow,
    Value<int>? rowid,
  }) {
    return TimeEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      start: start ?? this.start,
      end: end ?? this.end,
      kind: kind ?? this.kind,
      category: category ?? this.category,
      customerId: customerId ?? this.customerId,
      taskId: taskId ?? this.taskId,
      projectId: projectId ?? this.projectId,
      goalId: goalId ?? this.goalId,
      billable: billable ?? this.billable,
      note: note ?? this.note,
      ticketId: ticketId ?? this.ticketId,
      syncedToItflow: syncedToItflow ?? this.syncedToItflow,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $TimeEntriesTable.$converterkind.toSql(kind.value),
      );
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (billable.present) {
      map['billable'] = Variable<bool>(billable.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (ticketId.present) {
      map['ticket_id'] = Variable<int>(ticketId.value);
    }
    if (syncedToItflow.present) {
      map['synced_to_itflow'] = Variable<bool>(syncedToItflow.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('kind: $kind, ')
          ..write('category: $category, ')
          ..write('customerId: $customerId, ')
          ..write('taskId: $taskId, ')
          ..write('projectId: $projectId, ')
          ..write('goalId: $goalId, ')
          ..write('billable: $billable, ')
          ..write('note: $note, ')
          ..write('ticketId: $ticketId, ')
          ..write('syncedToItflow: $syncedToItflow, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimeEntryColleaguesTable extends TimeEntryColleagues
    with TableInfo<$TimeEntryColleaguesTable, TimeEntryColleague> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeEntryColleaguesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeEntryIdMeta = const VerificationMeta(
    'timeEntryId',
  );
  @override
  late final GeneratedColumn<String> timeEntryId = GeneratedColumn<String>(
    'time_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES time_entries (id)',
    ),
  );
  static const VerificationMeta _colleagueNameMeta = const VerificationMeta(
    'colleagueName',
  );
  @override
  late final GeneratedColumn<String> colleagueName = GeneratedColumn<String>(
    'colleague_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    timeEntryId,
    colleagueName,
    minutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_entry_colleagues';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimeEntryColleague> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('time_entry_id')) {
      context.handle(
        _timeEntryIdMeta,
        timeEntryId.isAcceptableOrUnknown(
          data['time_entry_id']!,
          _timeEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeEntryIdMeta);
    }
    if (data.containsKey('colleague_name')) {
      context.handle(
        _colleagueNameMeta,
        colleagueName.isAcceptableOrUnknown(
          data['colleague_name']!,
          _colleagueNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_colleagueNameMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    } else if (isInserting) {
      context.missing(_minutesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimeEntryColleague map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimeEntryColleague(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      timeEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_entry_id'],
      )!,
      colleagueName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}colleague_name'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
    );
  }

  @override
  $TimeEntryColleaguesTable createAlias(String alias) {
    return $TimeEntryColleaguesTable(attachedDatabase, alias);
  }
}

class TimeEntryColleague extends DataClass
    implements Insertable<TimeEntryColleague> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String timeEntryId;
  final String colleagueName;
  final int minutes;
  const TimeEntryColleague({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.timeEntryId,
    required this.colleagueName,
    required this.minutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['time_entry_id'] = Variable<String>(timeEntryId);
    map['colleague_name'] = Variable<String>(colleagueName);
    map['minutes'] = Variable<int>(minutes);
    return map;
  }

  TimeEntryColleaguesCompanion toCompanion(bool nullToAbsent) {
    return TimeEntryColleaguesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      timeEntryId: Value(timeEntryId),
      colleagueName: Value(colleagueName),
      minutes: Value(minutes),
    );
  }

  factory TimeEntryColleague.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimeEntryColleague(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      timeEntryId: serializer.fromJson<String>(json['timeEntryId']),
      colleagueName: serializer.fromJson<String>(json['colleagueName']),
      minutes: serializer.fromJson<int>(json['minutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'timeEntryId': serializer.toJson<String>(timeEntryId),
      'colleagueName': serializer.toJson<String>(colleagueName),
      'minutes': serializer.toJson<int>(minutes),
    };
  }

  TimeEntryColleague copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? timeEntryId,
    String? colleagueName,
    int? minutes,
  }) => TimeEntryColleague(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    timeEntryId: timeEntryId ?? this.timeEntryId,
    colleagueName: colleagueName ?? this.colleagueName,
    minutes: minutes ?? this.minutes,
  );
  TimeEntryColleague copyWithCompanion(TimeEntryColleaguesCompanion data) {
    return TimeEntryColleague(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      timeEntryId: data.timeEntryId.present
          ? data.timeEntryId.value
          : this.timeEntryId,
      colleagueName: data.colleagueName.present
          ? data.colleagueName.value
          : this.colleagueName,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimeEntryColleague(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('timeEntryId: $timeEntryId, ')
          ..write('colleagueName: $colleagueName, ')
          ..write('minutes: $minutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    timeEntryId,
    colleagueName,
    minutes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeEntryColleague &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.timeEntryId == this.timeEntryId &&
          other.colleagueName == this.colleagueName &&
          other.minutes == this.minutes);
}

class TimeEntryColleaguesCompanion extends UpdateCompanion<TimeEntryColleague> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> timeEntryId;
  final Value<String> colleagueName;
  final Value<int> minutes;
  final Value<int> rowid;
  const TimeEntryColleaguesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.timeEntryId = const Value.absent(),
    this.colleagueName = const Value.absent(),
    this.minutes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimeEntryColleaguesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String timeEntryId,
    required String colleagueName,
    required int minutes,
    this.rowid = const Value.absent(),
  }) : timeEntryId = Value(timeEntryId),
       colleagueName = Value(colleagueName),
       minutes = Value(minutes);
  static Insertable<TimeEntryColleague> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? timeEntryId,
    Expression<String>? colleagueName,
    Expression<int>? minutes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (timeEntryId != null) 'time_entry_id': timeEntryId,
      if (colleagueName != null) 'colleague_name': colleagueName,
      if (minutes != null) 'minutes': minutes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimeEntryColleaguesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? timeEntryId,
    Value<String>? colleagueName,
    Value<int>? minutes,
    Value<int>? rowid,
  }) {
    return TimeEntryColleaguesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      timeEntryId: timeEntryId ?? this.timeEntryId,
      colleagueName: colleagueName ?? this.colleagueName,
      minutes: minutes ?? this.minutes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (timeEntryId.present) {
      map['time_entry_id'] = Variable<String>(timeEntryId.value);
    }
    if (colleagueName.present) {
      map['colleague_name'] = Variable<String>(colleagueName.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeEntryColleaguesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('timeEntryId: $timeEntryId, ')
          ..write('colleagueName: $colleagueName, ')
          ..write('minutes: $minutes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkClocksTable extends WorkClocks
    with TableInfo<$WorkClocksTable, WorkClock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkClocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<DateTime> day = GeneratedColumn<DateTime>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
    'start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pausesMeta = const VerificationMeta('pauses');
  @override
  late final GeneratedColumn<String> pauses = GeneratedColumn<String>(
    'pauses',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<DateTime> end = GeneratedColumn<DateTime>(
    'end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    day,
    start,
    pauses,
    end,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_clocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkClock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('start')) {
      context.handle(
        _startMeta,
        start.isAcceptableOrUnknown(data['start']!, _startMeta),
      );
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('pauses')) {
      context.handle(
        _pausesMeta,
        pauses.isAcceptableOrUnknown(data['pauses']!, _pausesMeta),
      );
    }
    if (data.containsKey('end')) {
      context.handle(
        _endMeta,
        end.isAcceptableOrUnknown(data['end']!, _endMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkClock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkClock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}day'],
      )!,
      start: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start'],
      )!,
      pauses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pauses'],
      ),
      end: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end'],
      ),
    );
  }

  @override
  $WorkClocksTable createAlias(String alias) {
    return $WorkClocksTable(attachedDatabase, alias);
  }
}

class WorkClock extends DataClass implements Insertable<WorkClock> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime day;
  final DateTime start;

  /// JSON-encoded list of pause intervals.
  final String? pauses;
  final DateTime? end;
  const WorkClock({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.day,
    required this.start,
    this.pauses,
    this.end,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['day'] = Variable<DateTime>(day);
    map['start'] = Variable<DateTime>(start);
    if (!nullToAbsent || pauses != null) {
      map['pauses'] = Variable<String>(pauses);
    }
    if (!nullToAbsent || end != null) {
      map['end'] = Variable<DateTime>(end);
    }
    return map;
  }

  WorkClocksCompanion toCompanion(bool nullToAbsent) {
    return WorkClocksCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      day: Value(day),
      start: Value(start),
      pauses: pauses == null && nullToAbsent
          ? const Value.absent()
          : Value(pauses),
      end: end == null && nullToAbsent ? const Value.absent() : Value(end),
    );
  }

  factory WorkClock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkClock(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      day: serializer.fromJson<DateTime>(json['day']),
      start: serializer.fromJson<DateTime>(json['start']),
      pauses: serializer.fromJson<String?>(json['pauses']),
      end: serializer.fromJson<DateTime?>(json['end']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'day': serializer.toJson<DateTime>(day),
      'start': serializer.toJson<DateTime>(start),
      'pauses': serializer.toJson<String?>(pauses),
      'end': serializer.toJson<DateTime?>(end),
    };
  }

  WorkClock copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? day,
    DateTime? start,
    Value<String?> pauses = const Value.absent(),
    Value<DateTime?> end = const Value.absent(),
  }) => WorkClock(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    day: day ?? this.day,
    start: start ?? this.start,
    pauses: pauses.present ? pauses.value : this.pauses,
    end: end.present ? end.value : this.end,
  );
  WorkClock copyWithCompanion(WorkClocksCompanion data) {
    return WorkClock(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      day: data.day.present ? data.day.value : this.day,
      start: data.start.present ? data.start.value : this.start,
      pauses: data.pauses.present ? data.pauses.value : this.pauses,
      end: data.end.present ? data.end.value : this.end,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkClock(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('day: $day, ')
          ..write('start: $start, ')
          ..write('pauses: $pauses, ')
          ..write('end: $end')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, deletedAt, day, start, pauses, end);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkClock &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.day == this.day &&
          other.start == this.start &&
          other.pauses == this.pauses &&
          other.end == this.end);
}

class WorkClocksCompanion extends UpdateCompanion<WorkClock> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> day;
  final Value<DateTime> start;
  final Value<String?> pauses;
  final Value<DateTime?> end;
  final Value<int> rowid;
  const WorkClocksCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.day = const Value.absent(),
    this.start = const Value.absent(),
    this.pauses = const Value.absent(),
    this.end = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkClocksCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime day,
    required DateTime start,
    this.pauses = const Value.absent(),
    this.end = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : day = Value(day),
       start = Value(start);
  static Insertable<WorkClock> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? day,
    Expression<DateTime>? start,
    Expression<String>? pauses,
    Expression<DateTime>? end,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (day != null) 'day': day,
      if (start != null) 'start': start,
      if (pauses != null) 'pauses': pauses,
      if (end != null) 'end': end,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkClocksCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? day,
    Value<DateTime>? start,
    Value<String?>? pauses,
    Value<DateTime?>? end,
    Value<int>? rowid,
  }) {
    return WorkClocksCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      day: day ?? this.day,
      start: start ?? this.start,
      pauses: pauses ?? this.pauses,
      end: end ?? this.end,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (day.present) {
      map['day'] = Variable<DateTime>(day.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (pauses.present) {
      map['pauses'] = Variable<String>(pauses.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkClocksCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('day: $day, ')
          ..write('start: $start, ')
          ..write('pauses: $pauses, ')
          ..write('end: $end, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<NoteParentType, String>
  parentType = GeneratedColumn<String>(
    'parent_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<NoteParentType>($NotesTable.$converterparentType);
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<NoteType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(NoteType.text.name),
      ).withConverter<NoteType>($NotesTable.$convertertype);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaPathMeta = const VerificationMeta(
    'mediaPath',
  );
  @override
  late final GeneratedColumn<String> mediaPath = GeneratedColumn<String>(
    'media_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transcriptMeta = const VerificationMeta(
    'transcript',
  );
  @override
  late final GeneratedColumn<String> transcript = GeneratedColumn<String>(
    'transcript',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSolutionMeta = const VerificationMeta(
    'isSolution',
  );
  @override
  late final GeneratedColumn<bool> isSolution = GeneratedColumn<bool>(
    'is_solution',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_solution" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    parentType,
    parentId,
    type,
    body,
    mediaPath,
    transcript,
    isSolution,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('media_path')) {
      context.handle(
        _mediaPathMeta,
        mediaPath.isAcceptableOrUnknown(data['media_path']!, _mediaPathMeta),
      );
    }
    if (data.containsKey('transcript')) {
      context.handle(
        _transcriptMeta,
        transcript.isAcceptableOrUnknown(data['transcript']!, _transcriptMeta),
      );
    }
    if (data.containsKey('is_solution')) {
      context.handle(
        _isSolutionMeta,
        isSolution.isAcceptableOrUnknown(data['is_solution']!, _isSolutionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      parentType: $NotesTable.$converterparentType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}parent_type'],
        )!,
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      )!,
      type: $NotesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      ),
      mediaPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_path'],
      ),
      transcript: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transcript'],
      ),
      isSolution: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_solution'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NoteParentType, String, String>
  $converterparentType = const EnumNameConverter<NoteParentType>(
    NoteParentType.values,
  );
  static JsonTypeConverter2<NoteType, String, String> $convertertype =
      const EnumNameConverter<NoteType>(NoteType.values);
}

class Note extends DataClass implements Insertable<Note> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final NoteParentType parentType;
  final String parentId;
  final NoteType type;
  final String? body;
  final String? mediaPath;
  final String? transcript;
  final bool isSolution;
  const Note({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.parentType,
    required this.parentId,
    required this.type,
    this.body,
    this.mediaPath,
    this.transcript,
    required this.isSolution,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['parent_type'] = Variable<String>(
        $NotesTable.$converterparentType.toSql(parentType),
      );
    }
    map['parent_id'] = Variable<String>(parentId);
    {
      map['type'] = Variable<String>($NotesTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || mediaPath != null) {
      map['media_path'] = Variable<String>(mediaPath);
    }
    if (!nullToAbsent || transcript != null) {
      map['transcript'] = Variable<String>(transcript);
    }
    map['is_solution'] = Variable<bool>(isSolution);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      parentType: Value(parentType),
      parentId: Value(parentId),
      type: Value(type),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      mediaPath: mediaPath == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaPath),
      transcript: transcript == null && nullToAbsent
          ? const Value.absent()
          : Value(transcript),
      isSolution: Value(isSolution),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      parentType: $NotesTable.$converterparentType.fromJson(
        serializer.fromJson<String>(json['parentType']),
      ),
      parentId: serializer.fromJson<String>(json['parentId']),
      type: $NotesTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      body: serializer.fromJson<String?>(json['body']),
      mediaPath: serializer.fromJson<String?>(json['mediaPath']),
      transcript: serializer.fromJson<String?>(json['transcript']),
      isSolution: serializer.fromJson<bool>(json['isSolution']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'parentType': serializer.toJson<String>(
        $NotesTable.$converterparentType.toJson(parentType),
      ),
      'parentId': serializer.toJson<String>(parentId),
      'type': serializer.toJson<String>(
        $NotesTable.$convertertype.toJson(type),
      ),
      'body': serializer.toJson<String?>(body),
      'mediaPath': serializer.toJson<String?>(mediaPath),
      'transcript': serializer.toJson<String?>(transcript),
      'isSolution': serializer.toJson<bool>(isSolution),
    };
  }

  Note copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    NoteParentType? parentType,
    String? parentId,
    NoteType? type,
    Value<String?> body = const Value.absent(),
    Value<String?> mediaPath = const Value.absent(),
    Value<String?> transcript = const Value.absent(),
    bool? isSolution,
  }) => Note(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    parentType: parentType ?? this.parentType,
    parentId: parentId ?? this.parentId,
    type: type ?? this.type,
    body: body.present ? body.value : this.body,
    mediaPath: mediaPath.present ? mediaPath.value : this.mediaPath,
    transcript: transcript.present ? transcript.value : this.transcript,
    isSolution: isSolution ?? this.isSolution,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      parentType: data.parentType.present
          ? data.parentType.value
          : this.parentType,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      type: data.type.present ? data.type.value : this.type,
      body: data.body.present ? data.body.value : this.body,
      mediaPath: data.mediaPath.present ? data.mediaPath.value : this.mediaPath,
      transcript: data.transcript.present
          ? data.transcript.value
          : this.transcript,
      isSolution: data.isSolution.present
          ? data.isSolution.value
          : this.isSolution,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('parentType: $parentType, ')
          ..write('parentId: $parentId, ')
          ..write('type: $type, ')
          ..write('body: $body, ')
          ..write('mediaPath: $mediaPath, ')
          ..write('transcript: $transcript, ')
          ..write('isSolution: $isSolution')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    parentType,
    parentId,
    type,
    body,
    mediaPath,
    transcript,
    isSolution,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.parentType == this.parentType &&
          other.parentId == this.parentId &&
          other.type == this.type &&
          other.body == this.body &&
          other.mediaPath == this.mediaPath &&
          other.transcript == this.transcript &&
          other.isSolution == this.isSolution);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<NoteParentType> parentType;
  final Value<String> parentId;
  final Value<NoteType> type;
  final Value<String?> body;
  final Value<String?> mediaPath;
  final Value<String?> transcript;
  final Value<bool> isSolution;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.parentType = const Value.absent(),
    this.parentId = const Value.absent(),
    this.type = const Value.absent(),
    this.body = const Value.absent(),
    this.mediaPath = const Value.absent(),
    this.transcript = const Value.absent(),
    this.isSolution = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required NoteParentType parentType,
    required String parentId,
    this.type = const Value.absent(),
    this.body = const Value.absent(),
    this.mediaPath = const Value.absent(),
    this.transcript = const Value.absent(),
    this.isSolution = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : parentType = Value(parentType),
       parentId = Value(parentId);
  static Insertable<Note> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? parentType,
    Expression<String>? parentId,
    Expression<String>? type,
    Expression<String>? body,
    Expression<String>? mediaPath,
    Expression<String>? transcript,
    Expression<bool>? isSolution,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (parentType != null) 'parent_type': parentType,
      if (parentId != null) 'parent_id': parentId,
      if (type != null) 'type': type,
      if (body != null) 'body': body,
      if (mediaPath != null) 'media_path': mediaPath,
      if (transcript != null) 'transcript': transcript,
      if (isSolution != null) 'is_solution': isSolution,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<NoteParentType>? parentType,
    Value<String>? parentId,
    Value<NoteType>? type,
    Value<String?>? body,
    Value<String?>? mediaPath,
    Value<String?>? transcript,
    Value<bool>? isSolution,
    Value<int>? rowid,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      parentType: parentType ?? this.parentType,
      parentId: parentId ?? this.parentId,
      type: type ?? this.type,
      body: body ?? this.body,
      mediaPath: mediaPath ?? this.mediaPath,
      transcript: transcript ?? this.transcript,
      isSolution: isSolution ?? this.isSolution,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (parentType.present) {
      map['parent_type'] = Variable<String>(
        $NotesTable.$converterparentType.toSql(parentType.value),
      );
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $NotesTable.$convertertype.toSql(type.value),
      );
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (mediaPath.present) {
      map['media_path'] = Variable<String>(mediaPath.value);
    }
    if (transcript.present) {
      map['transcript'] = Variable<String>(transcript.value);
    }
    if (isSolution.present) {
      map['is_solution'] = Variable<bool>(isSolution.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('parentType: $parentType, ')
          ..write('parentId: $parentId, ')
          ..write('type: $type, ')
          ..write('body: $body, ')
          ..write('mediaPath: $mediaPath, ')
          ..write('transcript: $transcript, ')
          ..write('isSolution: $isSolution, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MaterialsTable extends Materials
    with TableInfo<$MaterialsTable, MaterialItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaterialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _eanMeta = const VerificationMeta('ean');
  @override
  late final GeneratedColumn<String> ean = GeneratedColumn<String>(
    'ean',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    taskId,
    quantity,
    ean,
    name,
    photoPath,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'materials';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaterialItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('ean')) {
      context.handle(
        _eanMeta,
        ean.isAcceptableOrUnknown(data['ean']!, _eanMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaterialItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaterialItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      ean: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ean'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $MaterialsTable createAlias(String alias) {
    return $MaterialsTable(attachedDatabase, alias);
  }
}

class MaterialItem extends DataClass implements Insertable<MaterialItem> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String taskId;
  final int quantity;
  final String? ean;
  final String? name;
  final String? photoPath;
  final String? note;
  const MaterialItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.taskId,
    required this.quantity,
    this.ean,
    this.name,
    this.photoPath,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['task_id'] = Variable<String>(taskId);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || ean != null) {
      map['ean'] = Variable<String>(ean);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  MaterialsCompanion toCompanion(bool nullToAbsent) {
    return MaterialsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      taskId: Value(taskId),
      quantity: Value(quantity),
      ean: ean == null && nullToAbsent ? const Value.absent() : Value(ean),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory MaterialItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaterialItem(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      taskId: serializer.fromJson<String>(json['taskId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      ean: serializer.fromJson<String?>(json['ean']),
      name: serializer.fromJson<String?>(json['name']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'taskId': serializer.toJson<String>(taskId),
      'quantity': serializer.toJson<int>(quantity),
      'ean': serializer.toJson<String?>(ean),
      'name': serializer.toJson<String?>(name),
      'photoPath': serializer.toJson<String?>(photoPath),
      'note': serializer.toJson<String?>(note),
    };
  }

  MaterialItem copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? taskId,
    int? quantity,
    Value<String?> ean = const Value.absent(),
    Value<String?> name = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => MaterialItem(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    taskId: taskId ?? this.taskId,
    quantity: quantity ?? this.quantity,
    ean: ean.present ? ean.value : this.ean,
    name: name.present ? name.value : this.name,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    note: note.present ? note.value : this.note,
  );
  MaterialItem copyWithCompanion(MaterialsCompanion data) {
    return MaterialItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      ean: data.ean.present ? data.ean.value : this.ean,
      name: data.name.present ? data.name.value : this.name,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaterialItem(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('taskId: $taskId, ')
          ..write('quantity: $quantity, ')
          ..write('ean: $ean, ')
          ..write('name: $name, ')
          ..write('photoPath: $photoPath, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    taskId,
    quantity,
    ean,
    name,
    photoPath,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaterialItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.taskId == this.taskId &&
          other.quantity == this.quantity &&
          other.ean == this.ean &&
          other.name == this.name &&
          other.photoPath == this.photoPath &&
          other.note == this.note);
}

class MaterialsCompanion extends UpdateCompanion<MaterialItem> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> taskId;
  final Value<int> quantity;
  final Value<String?> ean;
  final Value<String?> name;
  final Value<String?> photoPath;
  final Value<String?> note;
  final Value<int> rowid;
  const MaterialsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.taskId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.ean = const Value.absent(),
    this.name = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaterialsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String taskId,
    this.quantity = const Value.absent(),
    this.ean = const Value.absent(),
    this.name = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId);
  static Insertable<MaterialItem> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? taskId,
    Expression<int>? quantity,
    Expression<String>? ean,
    Expression<String>? name,
    Expression<String>? photoPath,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (taskId != null) 'task_id': taskId,
      if (quantity != null) 'quantity': quantity,
      if (ean != null) 'ean': ean,
      if (name != null) 'name': name,
      if (photoPath != null) 'photo_path': photoPath,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaterialsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? taskId,
    Value<int>? quantity,
    Value<String?>? ean,
    Value<String?>? name,
    Value<String?>? photoPath,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return MaterialsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      taskId: taskId ?? this.taskId,
      quantity: quantity ?? this.quantity,
      ean: ean ?? this.ean,
      name: name ?? this.name,
      photoPath: photoPath ?? this.photoPath,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (ean.present) {
      map['ean'] = Variable<String>(ean.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaterialsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('taskId: $taskId, ')
          ..write('quantity: $quantity, ')
          ..write('ean: $ean, ')
          ..write('name: $name, ')
          ..write('photoPath: $photoPath, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckRoundsTable extends CheckRounds
    with TableInfo<$CheckRoundsTable, CheckRound> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckRoundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES templates (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    weekday,
    templateId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'check_rounds';
  @override
  VerificationContext validateIntegrity(
    Insertable<CheckRound> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CheckRound map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckRound(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      ),
    );
  }

  @override
  $CheckRoundsTable createAlias(String alias) {
    return $CheckRoundsTable(attachedDatabase, alias);
  }
}

class CheckRound extends DataClass implements Insertable<CheckRound> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final int weekday;
  final String? templateId;
  const CheckRound({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.weekday,
    this.templateId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    map['weekday'] = Variable<int>(weekday);
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<String>(templateId);
    }
    return map;
  }

  CheckRoundsCompanion toCompanion(bool nullToAbsent) {
    return CheckRoundsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      weekday: Value(weekday),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
    );
  }

  factory CheckRound.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckRound(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      weekday: serializer.fromJson<int>(json['weekday']),
      templateId: serializer.fromJson<String?>(json['templateId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'weekday': serializer.toJson<int>(weekday),
      'templateId': serializer.toJson<String?>(templateId),
    };
  }

  CheckRound copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    int? weekday,
    Value<String?> templateId = const Value.absent(),
  }) => CheckRound(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    weekday: weekday ?? this.weekday,
    templateId: templateId.present ? templateId.value : this.templateId,
  );
  CheckRound copyWithCompanion(CheckRoundsCompanion data) {
    return CheckRound(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckRound(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('weekday: $weekday, ')
          ..write('templateId: $templateId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    weekday,
    templateId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckRound &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.weekday == this.weekday &&
          other.templateId == this.templateId);
}

class CheckRoundsCompanion extends UpdateCompanion<CheckRound> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<int> weekday;
  final Value<String?> templateId;
  final Value<int> rowid;
  const CheckRoundsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.weekday = const Value.absent(),
    this.templateId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CheckRoundsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    required int weekday,
    this.templateId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       weekday = Value(weekday);
  static Insertable<CheckRound> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<int>? weekday,
    Expression<String>? templateId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (weekday != null) 'weekday': weekday,
      if (templateId != null) 'template_id': templateId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CheckRoundsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<int>? weekday,
    Value<String?>? templateId,
    Value<int>? rowid,
  }) {
    return CheckRoundsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      weekday: weekday ?? this.weekday,
      templateId: templateId ?? this.templateId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckRoundsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('weekday: $weekday, ')
          ..write('templateId: $templateId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckRoundResultsTable extends CheckRoundResults
    with TableInfo<$CheckRoundResultsTable, CheckRoundResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckRoundResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newUuid,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checkRoundIdMeta = const VerificationMeta(
    'checkRoundId',
  );
  @override
  late final GeneratedColumn<String> checkRoundId = GeneratedColumn<String>(
    'check_round_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES check_rounds (id)',
    ),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CheckResult, String> result =
      GeneratedColumn<String>(
        'result',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CheckResult>($CheckRoundResultsTable.$converterresult);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    checkRoundId,
    customerId,
    result,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'check_round_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<CheckRoundResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('check_round_id')) {
      context.handle(
        _checkRoundIdMeta,
        checkRoundId.isAcceptableOrUnknown(
          data['check_round_id']!,
          _checkRoundIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checkRoundIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CheckRoundResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckRoundResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      checkRoundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_round_id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      result: $CheckRoundResultsTable.$converterresult.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}result'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $CheckRoundResultsTable createAlias(String alias) {
    return $CheckRoundResultsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CheckResult, String, String> $converterresult =
      const EnumNameConverter<CheckResult>(CheckResult.values);
}

class CheckRoundResult extends DataClass
    implements Insertable<CheckRoundResult> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String checkRoundId;
  final String customerId;
  final CheckResult result;
  final String? note;
  const CheckRoundResult({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.checkRoundId,
    required this.customerId,
    required this.result,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['check_round_id'] = Variable<String>(checkRoundId);
    map['customer_id'] = Variable<String>(customerId);
    {
      map['result'] = Variable<String>(
        $CheckRoundResultsTable.$converterresult.toSql(result),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  CheckRoundResultsCompanion toCompanion(bool nullToAbsent) {
    return CheckRoundResultsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      checkRoundId: Value(checkRoundId),
      customerId: Value(customerId),
      result: Value(result),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory CheckRoundResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckRoundResult(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      checkRoundId: serializer.fromJson<String>(json['checkRoundId']),
      customerId: serializer.fromJson<String>(json['customerId']),
      result: $CheckRoundResultsTable.$converterresult.fromJson(
        serializer.fromJson<String>(json['result']),
      ),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'checkRoundId': serializer.toJson<String>(checkRoundId),
      'customerId': serializer.toJson<String>(customerId),
      'result': serializer.toJson<String>(
        $CheckRoundResultsTable.$converterresult.toJson(result),
      ),
      'note': serializer.toJson<String?>(note),
    };
  }

  CheckRoundResult copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? checkRoundId,
    String? customerId,
    CheckResult? result,
    Value<String?> note = const Value.absent(),
  }) => CheckRoundResult(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    checkRoundId: checkRoundId ?? this.checkRoundId,
    customerId: customerId ?? this.customerId,
    result: result ?? this.result,
    note: note.present ? note.value : this.note,
  );
  CheckRoundResult copyWithCompanion(CheckRoundResultsCompanion data) {
    return CheckRoundResult(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      checkRoundId: data.checkRoundId.present
          ? data.checkRoundId.value
          : this.checkRoundId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      result: data.result.present ? data.result.value : this.result,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckRoundResult(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('checkRoundId: $checkRoundId, ')
          ..write('customerId: $customerId, ')
          ..write('result: $result, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    checkRoundId,
    customerId,
    result,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckRoundResult &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.checkRoundId == this.checkRoundId &&
          other.customerId == this.customerId &&
          other.result == this.result &&
          other.note == this.note);
}

class CheckRoundResultsCompanion extends UpdateCompanion<CheckRoundResult> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> checkRoundId;
  final Value<String> customerId;
  final Value<CheckResult> result;
  final Value<String?> note;
  final Value<int> rowid;
  const CheckRoundResultsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.checkRoundId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.result = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CheckRoundResultsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String checkRoundId,
    required String customerId,
    required CheckResult result,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : checkRoundId = Value(checkRoundId),
       customerId = Value(customerId),
       result = Value(result);
  static Insertable<CheckRoundResult> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? checkRoundId,
    Expression<String>? customerId,
    Expression<String>? result,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (checkRoundId != null) 'check_round_id': checkRoundId,
      if (customerId != null) 'customer_id': customerId,
      if (result != null) 'result': result,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CheckRoundResultsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? checkRoundId,
    Value<String>? customerId,
    Value<CheckResult>? result,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return CheckRoundResultsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      checkRoundId: checkRoundId ?? this.checkRoundId,
      customerId: customerId ?? this.customerId,
      result: result ?? this.result,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (checkRoundId.present) {
      map['check_round_id'] = Variable<String>(checkRoundId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(
        $CheckRoundResultsTable.$converterresult.toSql(result.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckRoundResultsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('checkRoundId: $checkRoundId, ')
          ..write('customerId: $customerId, ')
          ..write('result: $result, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $WorkspacesTable workspaces = $WorkspacesTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $MilestonesTable milestones = $MilestonesTable(this);
  late final $CriteriaTable criteria = $CriteriaTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $TemplatesTable templates = $TemplatesTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $ChecklistItemsTable checklistItems = $ChecklistItemsTable(this);
  late final $TimeEntriesTable timeEntries = $TimeEntriesTable(this);
  late final $TimeEntryColleaguesTable timeEntryColleagues =
      $TimeEntryColleaguesTable(this);
  late final $WorkClocksTable workClocks = $WorkClocksTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $MaterialsTable materials = $MaterialsTable(this);
  late final $CheckRoundsTable checkRounds = $CheckRoundsTable(this);
  late final $CheckRoundResultsTable checkRoundResults =
      $CheckRoundResultsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettings,
    workspaces,
    customers,
    contacts,
    projects,
    milestones,
    criteria,
    goals,
    habits,
    templates,
    tasks,
    checklistItems,
    timeEntries,
    timeEntryColleagues,
    workClocks,
    notes,
    materials,
    checkRounds,
    checkRoundResults,
  ];
}

typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$WorkspacesTableCreateCompanionBuilder = WorkspacesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String name,
  Value<int> rowid,
});
typedef $$WorkspacesTableUpdateCompanionBuilder = WorkspacesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> name,
  Value<int> rowid,
});

class $$WorkspacesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkspacesTable> {
  $$WorkspacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkspacesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkspacesTable> {
  $$WorkspacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkspacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkspacesTable> {
  $$WorkspacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$WorkspacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkspacesTable,
          Workspace,
          $$WorkspacesTableFilterComposer,
          $$WorkspacesTableOrderingComposer,
          $$WorkspacesTableAnnotationComposer,
          $$WorkspacesTableCreateCompanionBuilder,
          $$WorkspacesTableUpdateCompanionBuilder,
          (
            Workspace,
            BaseReferences<_$AppDatabase, $WorkspacesTable, Workspace>,
          ),
          Workspace,
          PrefetchHooks Function()
        > {
  $$WorkspacesTableTableManager(_$AppDatabase db, $WorkspacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkspacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkspacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkspacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkspacesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => WorkspacesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkspacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkspacesTable,
      Workspace,
      $$WorkspacesTableFilterComposer,
      $$WorkspacesTableOrderingComposer,
      $$WorkspacesTableAnnotationComposer,
      $$WorkspacesTableCreateCompanionBuilder,
      $$WorkspacesTableUpdateCompanionBuilder,
      (Workspace, BaseReferences<_$AppDatabase, $WorkspacesTable, Workspace>),
      Workspace,
      PrefetchHooks Function()
    >;
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String name,
  Value<int?> color,
  Value<String?> address,
  Value<String?> notes,
  Value<int?> itflowClientId,
  Value<int?> contingentAePerMonth,
  Value<bool> isFavorite,
  Value<int> rowid,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> name,
  Value<int?> color,
  Value<String?> address,
  Value<String?> notes,
  Value<int?> itflowClientId,
  Value<int?> contingentAePerMonth,
  Value<bool> isFavorite,
  Value<int> rowid,
});

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ContactsTable, List<Contact>> _contactsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.contacts,
    aliasName: 'customers__id__contacts__customer_id',
  );

  $$ContactsTableProcessedTableManager get contactsRefs {
    final manager = $$ContactsTableTableManager(
      $_db,
      $_db.contacts,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_contactsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectsTable, List<Project>> _projectsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.projects,
    aliasName: 'customers__id__projects__customer_id',
  );

  $$ProjectsTableProcessedTableManager get projectsRefs {
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TemplatesTable, List<Template>>
  _templatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.templates,
    aliasName: 'customers__id__templates__default_customer_id',
  );

  $$TemplatesTableProcessedTableManager get templatesRefs {
    final manager = $$TemplatesTableTableManager($_db, $_db.templates).filter(
      (f) => f.defaultCustomerId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_templatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'customers__id__tasks__customer_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<TimeEntry>>
  _timeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: 'customers__id__time_entries__customer_id',
  );

  $$TimeEntriesTableProcessedTableManager get timeEntriesRefs {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CheckRoundResultsTable, List<CheckRoundResult>>
  _checkRoundResultsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.checkRoundResults,
        aliasName: 'customers__id__check_round_results__customer_id',
      );

  $$CheckRoundResultsTableProcessedTableManager get checkRoundResultsRefs {
    final manager = $$CheckRoundResultsTableTableManager(
      $_db,
      $_db.checkRoundResults,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _checkRoundResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itflowClientId => $composableBuilder(
    column: $table.itflowClientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contingentAePerMonth => $composableBuilder(
    column: $table.contingentAePerMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> contactsRefs(
    Expression<bool> Function($$ContactsTableFilterComposer f) f,
  ) {
    final $$ContactsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contacts,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactsTableFilterComposer(
            $db: $db,
            $table: $db.contacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectsRefs(
    Expression<bool> Function($$ProjectsTableFilterComposer f) f,
  ) {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> templatesRefs(
    Expression<bool> Function($$TemplatesTableFilterComposer f) f,
  ) {
    final $$TemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.defaultCustomerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableFilterComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timeEntriesRefs(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> checkRoundResultsRefs(
    Expression<bool> Function($$CheckRoundResultsTableFilterComposer f) f,
  ) {
    final $$CheckRoundResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checkRoundResults,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckRoundResultsTableFilterComposer(
            $db: $db,
            $table: $db.checkRoundResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itflowClientId => $composableBuilder(
    column: $table.itflowClientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contingentAePerMonth => $composableBuilder(
    column: $table.contingentAePerMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get itflowClientId => $composableBuilder(
    column: $table.itflowClientId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get contingentAePerMonth => $composableBuilder(
    column: $table.contingentAePerMonth,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  Expression<T> contactsRefs<T extends Object>(
    Expression<T> Function($$ContactsTableAnnotationComposer a) f,
  ) {
    final $$ContactsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contacts,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactsTableAnnotationComposer(
            $db: $db,
            $table: $db.contacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectsRefs<T extends Object>(
    Expression<T> Function($$ProjectsTableAnnotationComposer a) f,
  ) {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> templatesRefs<T extends Object>(
    Expression<T> Function($$TemplatesTableAnnotationComposer a) f,
  ) {
    final $$TemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.defaultCustomerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timeEntriesRefs<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> checkRoundResultsRefs<T extends Object>(
    Expression<T> Function($$CheckRoundResultsTableAnnotationComposer a) f,
  ) {
    final $$CheckRoundResultsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.checkRoundResults,
          getReferencedColumn: (t) => t.customerId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CheckRoundResultsTableAnnotationComposer(
                $db: $db,
                $table: $db.checkRoundResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, $$CustomersTableReferences),
          Customer,
          PrefetchHooks Function({
            bool contactsRefs,
            bool projectsRefs,
            bool templatesRefs,
            bool tasksRefs,
            bool timeEntriesRefs,
            bool checkRoundResultsRefs,
          })
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> color = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> itflowClientId = const Value.absent(),
                Value<int?> contingentAePerMonth = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                color: color,
                address: address,
                notes: notes,
                itflowClientId: itflowClientId,
                contingentAePerMonth: contingentAePerMonth,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                Value<int?> color = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> itflowClientId = const Value.absent(),
                Value<int?> contingentAePerMonth = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                color: color,
                address: address,
                notes: notes,
                itflowClientId: itflowClientId,
                contingentAePerMonth: contingentAePerMonth,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                contactsRefs = false,
                projectsRefs = false,
                templatesRefs = false,
                tasksRefs = false,
                timeEntriesRefs = false,
                checkRoundResultsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (contactsRefs) db.contacts,
                    if (projectsRefs) db.projects,
                    if (templatesRefs) db.templates,
                    if (tasksRefs) db.tasks,
                    if (timeEntriesRefs) db.timeEntries,
                    if (checkRoundResultsRefs) db.checkRoundResults,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (contactsRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Contact
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._contactsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).contactsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectsRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Project
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._projectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).projectsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (templatesRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Template
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._templatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).templatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.defaultCustomerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tasksRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Task
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (timeEntriesRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          TimeEntry
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._timeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).timeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (checkRoundResultsRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          CheckRoundResult
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._checkRoundResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).checkRoundResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, $$CustomersTableReferences),
      Customer,
      PrefetchHooks Function({
        bool contactsRefs,
        bool projectsRefs,
        bool templatesRefs,
        bool tasksRefs,
        bool timeEntriesRefs,
        bool checkRoundResultsRefs,
      })
    >;
typedef $$ContactsTableCreateCompanionBuilder = ContactsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String customerId,
  required String name,
  Value<String?> role,
  Value<String?> phone,
  Value<String?> email,
  Value<int> rowid,
});
typedef $$ContactsTableUpdateCompanionBuilder = ContactsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> customerId,
  Value<String> name,
  Value<String?> role,
  Value<String?> phone,
  Value<String?> email,
  Value<int> rowid,
});

final class $$ContactsTableReferences
    extends BaseReferences<_$AppDatabase, $ContactsTable, Contact> {
  $$ContactsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('contacts__customer_id__customers__id');

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<String>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContactsTableFilterComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContactsTable,
          Contact,
          $$ContactsTableFilterComposer,
          $$ContactsTableOrderingComposer,
          $$ContactsTableAnnotationComposer,
          $$ContactsTableCreateCompanionBuilder,
          $$ContactsTableUpdateCompanionBuilder,
          (Contact, $$ContactsTableReferences),
          Contact,
          PrefetchHooks Function({bool customerId})
        > {
  $$ContactsTableTableManager(_$AppDatabase db, $ContactsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> role = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                customerId: customerId,
                name: name,
                role: role,
                phone: phone,
                email: email,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String customerId,
                required String name,
                Value<String?> role = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                customerId: customerId,
                name: name,
                role: role,
                phone: phone,
                email: email,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContactsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({customerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (customerId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.customerId,
                        referencedTable: $$ContactsTableReferences
                            ._customerIdTable(db),
                        referencedColumn: $$ContactsTableReferences
                            ._customerIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContactsTable,
      Contact,
      $$ContactsTableFilterComposer,
      $$ContactsTableOrderingComposer,
      $$ContactsTableAnnotationComposer,
      $$ContactsTableCreateCompanionBuilder,
      $$ContactsTableUpdateCompanionBuilder,
      (Contact, $$ContactsTableReferences),
      Contact,
      PrefetchHooks Function({bool customerId})
    >;
typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> customerId,
  required String name,
  Value<int?> color,
  Value<ProjectStatus> status,
  Value<DateTime?> start,
  Value<DateTime?> due,
  Value<int?> budgetAe,
  Value<int> warnPercent,
  Value<int?> itflowProjectId,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> customerId,
  Value<String> name,
  Value<int?> color,
  Value<ProjectStatus> status,
  Value<DateTime?> start,
  Value<DateTime?> due,
  Value<int?> budgetAe,
  Value<int> warnPercent,
  Value<int?> itflowProjectId,
  Value<int> rowid,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('projects__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<String>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MilestonesTable, List<Milestone>>
  _milestonesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.milestones,
    aliasName: 'projects__id__milestones__project_id',
  );

  $$MilestonesTableProcessedTableManager get milestonesRefs {
    final manager = $$MilestonesTableTableManager(
      $_db,
      $_db.milestones,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_milestonesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CriteriaTable, List<Criterion>>
  _criteriaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.criteria,
    aliasName: 'projects__id__criteria__project_id',
  );

  $$CriteriaTableProcessedTableManager get criteriaRefs {
    final manager = $$CriteriaTableTableManager(
      $_db,
      $_db.criteria,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_criteriaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'projects__id__tasks__project_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<TimeEntry>>
  _timeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: 'projects__id__time_entries__project_id',
  );

  $$TimeEntriesTableProcessedTableManager get timeEntriesRefs {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ProjectStatus, ProjectStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetAe => $composableBuilder(
    column: $table.budgetAe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get warnPercent => $composableBuilder(
    column: $table.warnPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itflowProjectId => $composableBuilder(
    column: $table.itflowProjectId,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> milestonesRefs(
    Expression<bool> Function($$MilestonesTableFilterComposer f) f,
  ) {
    final $$MilestonesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.milestones,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilestonesTableFilterComposer(
            $db: $db,
            $table: $db.milestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> criteriaRefs(
    Expression<bool> Function($$CriteriaTableFilterComposer f) f,
  ) {
    final $$CriteriaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.criteria,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CriteriaTableFilterComposer(
            $db: $db,
            $table: $db.criteria,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timeEntriesRefs(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetAe => $composableBuilder(
    column: $table.budgetAe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get warnPercent => $composableBuilder(
    column: $table.warnPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itflowProjectId => $composableBuilder(
    column: $table.itflowProjectId,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ProjectStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<DateTime> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<int> get budgetAe =>
      $composableBuilder(column: $table.budgetAe, builder: (column) => column);

  GeneratedColumn<int> get warnPercent => $composableBuilder(
    column: $table.warnPercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get itflowProjectId => $composableBuilder(
    column: $table.itflowProjectId,
    builder: (column) => column,
  );

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> milestonesRefs<T extends Object>(
    Expression<T> Function($$MilestonesTableAnnotationComposer a) f,
  ) {
    final $$MilestonesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.milestones,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilestonesTableAnnotationComposer(
            $db: $db,
            $table: $db.milestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> criteriaRefs<T extends Object>(
    Expression<T> Function($$CriteriaTableAnnotationComposer a) f,
  ) {
    final $$CriteriaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.criteria,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CriteriaTableAnnotationComposer(
            $db: $db,
            $table: $db.criteria,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timeEntriesRefs<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({
            bool customerId,
            bool milestonesRefs,
            bool criteriaRefs,
            bool tasksRefs,
            bool timeEntriesRefs,
          })
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> color = const Value.absent(),
                Value<ProjectStatus> status = const Value.absent(),
                Value<DateTime?> start = const Value.absent(),
                Value<DateTime?> due = const Value.absent(),
                Value<int?> budgetAe = const Value.absent(),
                Value<int> warnPercent = const Value.absent(),
                Value<int?> itflowProjectId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                customerId: customerId,
                name: name,
                color: color,
                status: status,
                start: start,
                due: due,
                budgetAe: budgetAe,
                warnPercent: warnPercent,
                itflowProjectId: itflowProjectId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                required String name,
                Value<int?> color = const Value.absent(),
                Value<ProjectStatus> status = const Value.absent(),
                Value<DateTime?> start = const Value.absent(),
                Value<DateTime?> due = const Value.absent(),
                Value<int?> budgetAe = const Value.absent(),
                Value<int> warnPercent = const Value.absent(),
                Value<int?> itflowProjectId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                customerId: customerId,
                name: name,
                color: color,
                status: status,
                start: start,
                due: due,
                budgetAe: budgetAe,
                warnPercent: warnPercent,
                itflowProjectId: itflowProjectId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                milestonesRefs = false,
                criteriaRefs = false,
                tasksRefs = false,
                timeEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (milestonesRefs) db.milestones,
                    if (criteriaRefs) db.criteria,
                    if (tasksRefs) db.tasks,
                    if (timeEntriesRefs) db.timeEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.customerId,
                            referencedTable: $$ProjectsTableReferences
                                ._customerIdTable(db),
                            referencedColumn: $$ProjectsTableReferences
                                ._customerIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (milestonesRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          Milestone
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._milestonesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).milestonesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (criteriaRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          Criterion
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._criteriaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).criteriaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tasksRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          Task
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (timeEntriesRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          TimeEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._timeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).timeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({
        bool customerId,
        bool milestonesRefs,
        bool criteriaRefs,
        bool tasksRefs,
        bool timeEntriesRefs,
      })
    >;
typedef $$MilestonesTableCreateCompanionBuilder = MilestonesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String projectId,
  required String title,
  Value<int> order,
  Value<MilestoneStatus> status,
  Value<int> rowid,
});
typedef $$MilestonesTableUpdateCompanionBuilder = MilestonesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> projectId,
  Value<String> title,
  Value<int> order,
  Value<MilestoneStatus> status,
  Value<int> rowid,
});

final class $$MilestonesTableReferences
    extends BaseReferences<_$AppDatabase, $MilestonesTable, Milestone> {
  $$MilestonesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('milestones__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'milestones__id__tasks__milestone_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.milestoneId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MilestonesTableFilterComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MilestoneStatus, MilestoneStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.milestoneId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MilestonesTableOrderingComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MilestonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MilestoneStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.milestoneId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MilestonesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MilestonesTable,
          Milestone,
          $$MilestonesTableFilterComposer,
          $$MilestonesTableOrderingComposer,
          $$MilestonesTableAnnotationComposer,
          $$MilestonesTableCreateCompanionBuilder,
          $$MilestonesTableUpdateCompanionBuilder,
          (Milestone, $$MilestonesTableReferences),
          Milestone,
          PrefetchHooks Function({bool projectId, bool tasksRefs})
        > {
  $$MilestonesTableTableManager(_$AppDatabase db, $MilestonesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MilestonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MilestonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MilestonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<MilestoneStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MilestonesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                projectId: projectId,
                title: title,
                order: order,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String projectId,
                required String title,
                Value<int> order = const Value.absent(),
                Value<MilestoneStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MilestonesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                projectId: projectId,
                title: title,
                order: order,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MilestonesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false, tasksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tasksRefs) db.tasks],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projectId,
                        referencedTable: $$MilestonesTableReferences
                            ._projectIdTable(db),
                        referencedColumn: $$MilestonesTableReferences
                            ._projectIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tasksRefs)
                    await $_getPrefetchedData<
                      Milestone,
                      $MilestonesTable,
                      Task
                    >(
                      currentTable: table,
                      referencedTable: $$MilestonesTableReferences
                          ._tasksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MilestonesTableReferences(db, table, p0).tasksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.milestoneId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MilestonesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MilestonesTable,
      Milestone,
      $$MilestonesTableFilterComposer,
      $$MilestonesTableOrderingComposer,
      $$MilestonesTableAnnotationComposer,
      $$MilestonesTableCreateCompanionBuilder,
      $$MilestonesTableUpdateCompanionBuilder,
      (Milestone, $$MilestonesTableReferences),
      Milestone,
      PrefetchHooks Function({bool projectId, bool tasksRefs})
    >;
typedef $$CriteriaTableCreateCompanionBuilder = CriteriaCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String projectId,
  required String label,
  Value<bool> done,
  Value<int> rowid,
});
typedef $$CriteriaTableUpdateCompanionBuilder = CriteriaCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> projectId,
  Value<String> label,
  Value<bool> done,
  Value<int> rowid,
});

final class $$CriteriaTableReferences
    extends BaseReferences<_$AppDatabase, $CriteriaTable, Criterion> {
  $$CriteriaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('criteria__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CriteriaTableFilterComposer
    extends Composer<_$AppDatabase, $CriteriaTable> {
  $$CriteriaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CriteriaTableOrderingComposer
    extends Composer<_$AppDatabase, $CriteriaTable> {
  $$CriteriaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CriteriaTableAnnotationComposer
    extends Composer<_$AppDatabase, $CriteriaTable> {
  $$CriteriaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CriteriaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CriteriaTable,
          Criterion,
          $$CriteriaTableFilterComposer,
          $$CriteriaTableOrderingComposer,
          $$CriteriaTableAnnotationComposer,
          $$CriteriaTableCreateCompanionBuilder,
          $$CriteriaTableUpdateCompanionBuilder,
          (Criterion, $$CriteriaTableReferences),
          Criterion,
          PrefetchHooks Function({bool projectId})
        > {
  $$CriteriaTableTableManager(_$AppDatabase db, $CriteriaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CriteriaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CriteriaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CriteriaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CriteriaCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                projectId: projectId,
                label: label,
                done: done,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String projectId,
                required String label,
                Value<bool> done = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CriteriaCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                projectId: projectId,
                label: label,
                done: done,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CriteriaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projectId,
                        referencedTable: $$CriteriaTableReferences
                            ._projectIdTable(db),
                        referencedColumn: $$CriteriaTableReferences
                            ._projectIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CriteriaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CriteriaTable,
      Criterion,
      $$CriteriaTableFilterComposer,
      $$CriteriaTableOrderingComposer,
      $$CriteriaTableAnnotationComposer,
      $$CriteriaTableCreateCompanionBuilder,
      $$CriteriaTableUpdateCompanionBuilder,
      (Criterion, $$CriteriaTableReferences),
      Criterion,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String title,
  Value<String?> area,
  Value<int?> weeklyInputTarget,
  Value<GoalStatus> status,
  Value<int> rowid,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> title,
  Value<String?> area,
  Value<int?> weeklyInputTarget,
  Value<GoalStatus> status,
  Value<int> rowid,
});

final class $$GoalsTableReferences
    extends BaseReferences<_$AppDatabase, $GoalsTable, Goal> {
  $$GoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'goals__id__tasks__goal_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<TimeEntry>>
  _timeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: 'goals__id__time_entries__goal_id',
  );

  $$TimeEntriesTableProcessedTableManager get timeEntriesRefs {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyInputTarget => $composableBuilder(
    column: $table.weeklyInputTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GoalStatus, GoalStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timeEntriesRefs(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyInputTarget => $composableBuilder(
    column: $table.weeklyInputTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<int> get weeklyInputTarget => $composableBuilder(
    column: $table.weeklyInputTarget,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<GoalStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timeEntriesRefs<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          Goal,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (Goal, $$GoalsTableReferences),
          Goal,
          PrefetchHooks Function({bool tasksRefs, bool timeEntriesRefs})
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> area = const Value.absent(),
                Value<int?> weeklyInputTarget = const Value.absent(),
                Value<GoalStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                title: title,
                area: area,
                weeklyInputTarget: weeklyInputTarget,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String title,
                Value<String?> area = const Value.absent(),
                Value<int?> weeklyInputTarget = const Value.absent(),
                Value<GoalStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                title: title,
                area: area,
                weeklyInputTarget: weeklyInputTarget,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GoalsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({tasksRefs = false, timeEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tasksRefs) db.tasks,
                    if (timeEntriesRefs) db.timeEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tasksRefs)
                        await $_getPrefetchedData<Goal, $GoalsTable, Task>(
                          currentTable: table,
                          referencedTable: $$GoalsTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalsTableReferences(db, table, p0).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (timeEntriesRefs)
                        await $_getPrefetchedData<Goal, $GoalsTable, TimeEntry>(
                          currentTable: table,
                          referencedTable: $$GoalsTableReferences
                              ._timeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalsTableReferences(
                                db,
                                table,
                                p0,
                              ).timeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      Goal,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (Goal, $$GoalsTableReferences),
      Goal,
      PrefetchHooks Function({bool tasksRefs, bool timeEntriesRefs})
    >;
typedef $$HabitsTableCreateCompanionBuilder = HabitsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String title,
  Value<int> timesPerWeek,
  Value<int> rowid,
});
typedef $$HabitsTableUpdateCompanionBuilder = HabitsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> title,
  Value<int> timesPerWeek,
  Value<int> rowid,
});

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesPerWeek => $composableBuilder(
    column: $table.timesPerWeek,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesPerWeek => $composableBuilder(
    column: $table.timesPerWeek,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get timesPerWeek => $composableBuilder(
    column: $table.timesPerWeek,
    builder: (column) => column,
  );
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          Habit,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
          Habit,
          PrefetchHooks Function()
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> timesPerWeek = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                title: title,
                timesPerWeek: timesPerWeek,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String title,
                Value<int> timesPerWeek = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                title: title,
                timesPerWeek: timesPerWeek,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      Habit,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
      Habit,
      PrefetchHooks Function()
    >;
typedef $$TemplatesTableCreateCompanionBuilder = TemplatesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String name,
  required String titlePattern,
  Value<String?> fields,
  Value<String?> checklist,
  Value<String?> defaultCustomerId,
  Value<int?> estimate,
  Value<int?> flatRateAe,
  Value<int?> targetMinutes,
  Value<bool> isFavorite,
  Value<int> rowid,
});
typedef $$TemplatesTableUpdateCompanionBuilder = TemplatesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> name,
  Value<String> titlePattern,
  Value<String?> fields,
  Value<String?> checklist,
  Value<String?> defaultCustomerId,
  Value<int?> estimate,
  Value<int?> flatRateAe,
  Value<int?> targetMinutes,
  Value<bool> isFavorite,
  Value<int> rowid,
});

final class $$TemplatesTableReferences
    extends BaseReferences<_$AppDatabase, $TemplatesTable, Template> {
  $$TemplatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _defaultCustomerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('templates__default_customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get defaultCustomerId {
    final $_column = $_itemColumn<String>('default_customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_defaultCustomerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'templates__id__tasks__template_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CheckRoundsTable, List<CheckRound>>
  _checkRoundsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.checkRounds,
    aliasName: 'templates__id__check_rounds__template_id',
  );

  $$CheckRoundsTableProcessedTableManager get checkRoundsRefs {
    final manager = $$CheckRoundsTableTableManager(
      $_db,
      $_db.checkRounds,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_checkRoundsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titlePattern => $composableBuilder(
    column: $table.titlePattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fields => $composableBuilder(
    column: $table.fields,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checklist => $composableBuilder(
    column: $table.checklist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimate => $composableBuilder(
    column: $table.estimate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get flatRateAe => $composableBuilder(
    column: $table.flatRateAe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get defaultCustomerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultCustomerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> checkRoundsRefs(
    Expression<bool> Function($$CheckRoundsTableFilterComposer f) f,
  ) {
    final $$CheckRoundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checkRounds,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckRoundsTableFilterComposer(
            $db: $db,
            $table: $db.checkRounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titlePattern => $composableBuilder(
    column: $table.titlePattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fields => $composableBuilder(
    column: $table.fields,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checklist => $composableBuilder(
    column: $table.checklist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimate => $composableBuilder(
    column: $table.estimate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flatRateAe => $composableBuilder(
    column: $table.flatRateAe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get defaultCustomerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultCustomerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get titlePattern => $composableBuilder(
    column: $table.titlePattern,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fields =>
      $composableBuilder(column: $table.fields, builder: (column) => column);

  GeneratedColumn<String> get checklist =>
      $composableBuilder(column: $table.checklist, builder: (column) => column);

  GeneratedColumn<int> get estimate =>
      $composableBuilder(column: $table.estimate, builder: (column) => column);

  GeneratedColumn<int> get flatRateAe => $composableBuilder(
    column: $table.flatRateAe,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  $$CustomersTableAnnotationComposer get defaultCustomerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultCustomerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> checkRoundsRefs<T extends Object>(
    Expression<T> Function($$CheckRoundsTableAnnotationComposer a) f,
  ) {
    final $$CheckRoundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checkRounds,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckRoundsTableAnnotationComposer(
            $db: $db,
            $table: $db.checkRounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemplatesTable,
          Template,
          $$TemplatesTableFilterComposer,
          $$TemplatesTableOrderingComposer,
          $$TemplatesTableAnnotationComposer,
          $$TemplatesTableCreateCompanionBuilder,
          $$TemplatesTableUpdateCompanionBuilder,
          (Template, $$TemplatesTableReferences),
          Template,
          PrefetchHooks Function({
            bool defaultCustomerId,
            bool tasksRefs,
            bool checkRoundsRefs,
          })
        > {
  $$TemplatesTableTableManager(_$AppDatabase db, $TemplatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> titlePattern = const Value.absent(),
                Value<String?> fields = const Value.absent(),
                Value<String?> checklist = const Value.absent(),
                Value<String?> defaultCustomerId = const Value.absent(),
                Value<int?> estimate = const Value.absent(),
                Value<int?> flatRateAe = const Value.absent(),
                Value<int?> targetMinutes = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplatesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                titlePattern: titlePattern,
                fields: fields,
                checklist: checklist,
                defaultCustomerId: defaultCustomerId,
                estimate: estimate,
                flatRateAe: flatRateAe,
                targetMinutes: targetMinutes,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                required String titlePattern,
                Value<String?> fields = const Value.absent(),
                Value<String?> checklist = const Value.absent(),
                Value<String?> defaultCustomerId = const Value.absent(),
                Value<int?> estimate = const Value.absent(),
                Value<int?> flatRateAe = const Value.absent(),
                Value<int?> targetMinutes = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplatesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                titlePattern: titlePattern,
                fields: fields,
                checklist: checklist,
                defaultCustomerId: defaultCustomerId,
                estimate: estimate,
                flatRateAe: flatRateAe,
                targetMinutes: targetMinutes,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                defaultCustomerId = false,
                tasksRefs = false,
                checkRoundsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tasksRefs) db.tasks,
                    if (checkRoundsRefs) db.checkRounds,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (defaultCustomerId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.defaultCustomerId,
                            referencedTable: $$TemplatesTableReferences
                                ._defaultCustomerIdTable(db),
                            referencedColumn: $$TemplatesTableReferences
                                ._defaultCustomerIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tasksRefs)
                        await $_getPrefetchedData<
                          Template,
                          $TemplatesTable,
                          Task
                        >(
                          currentTable: table,
                          referencedTable: $$TemplatesTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TemplatesTableReferences(
                                db,
                                table,
                                p0,
                              ).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.templateId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (checkRoundsRefs)
                        await $_getPrefetchedData<
                          Template,
                          $TemplatesTable,
                          CheckRound
                        >(
                          currentTable: table,
                          referencedTable: $$TemplatesTableReferences
                              ._checkRoundsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TemplatesTableReferences(
                                db,
                                table,
                                p0,
                              ).checkRoundsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.templateId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemplatesTable,
      Template,
      $$TemplatesTableFilterComposer,
      $$TemplatesTableOrderingComposer,
      $$TemplatesTableAnnotationComposer,
      $$TemplatesTableCreateCompanionBuilder,
      $$TemplatesTableUpdateCompanionBuilder,
      (Template, $$TemplatesTableReferences),
      Template,
      PrefetchHooks Function({
        bool defaultCustomerId,
        bool tasksRefs,
        bool checkRoundsRefs,
      })
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String title,
  Value<TaskStatus> status,
  Value<DateTime?> plannedDay,
  Value<int> order,
  Value<DateTime?> due,
  Value<bool> important,
  Value<int?> estimateMin,
  Value<TaskSource?> source,
  Value<String?> customerId,
  Value<String?> projectId,
  Value<String?> milestoneId,
  Value<String?> goalId,
  Value<String?> templateId,
  Value<int?> itflowTicketId,
  Value<String?> waitingFor,
  Value<DateTime?> waitingSince,
  Value<DateTime?> followUpDate,
  Value<String?> recurrence,
  Value<String?> tags,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> title,
  Value<TaskStatus> status,
  Value<DateTime?> plannedDay,
  Value<int> order,
  Value<DateTime?> due,
  Value<bool> important,
  Value<int?> estimateMin,
  Value<TaskSource?> source,
  Value<String?> customerId,
  Value<String?> projectId,
  Value<String?> milestoneId,
  Value<String?> goalId,
  Value<String?> templateId,
  Value<int?> itflowTicketId,
  Value<String?> waitingFor,
  Value<DateTime?> waitingSince,
  Value<DateTime?> followUpDate,
  Value<String?> recurrence,
  Value<String?> tags,
  Value<int> rowid,
});

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, Task> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('tasks__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<String>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('tasks__project_id__projects__id');

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MilestonesTable _milestoneIdTable(_$AppDatabase db) =>
      db.milestones.createAlias('tasks__milestone_id__milestones__id');

  $$MilestonesTableProcessedTableManager? get milestoneId {
    final $_column = $_itemColumn<String>('milestone_id');
    if ($_column == null) return null;
    final manager = $$MilestonesTableTableManager(
      $_db,
      $_db.milestones,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_milestoneIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GoalsTable _goalIdTable(_$AppDatabase db) =>
      db.goals.createAlias('tasks__goal_id__goals__id');

  $$GoalsTableProcessedTableManager? get goalId {
    final $_column = $_itemColumn<String>('goal_id');
    if ($_column == null) return null;
    final manager = $$GoalsTableTableManager(
      $_db,
      $_db.goals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.templates.createAlias('tasks__template_id__templates__id');

  $$TemplatesTableProcessedTableManager? get templateId {
    final $_column = $_itemColumn<String>('template_id');
    if ($_column == null) return null;
    final manager = $$TemplatesTableTableManager(
      $_db,
      $_db.templates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ChecklistItemsTable, List<ChecklistItem>>
  _checklistItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.checklistItems,
    aliasName: 'tasks__id__checklist_items__task_id',
  );

  $$ChecklistItemsTableProcessedTableManager get checklistItemsRefs {
    final manager = $$ChecklistItemsTableTableManager(
      $_db,
      $_db.checklistItems,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_checklistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<TimeEntry>>
  _timeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: 'tasks__id__time_entries__task_id',
  );

  $$TimeEntriesTableProcessedTableManager get timeEntriesRefs {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MaterialsTable, List<MaterialItem>>
  _materialsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.materials,
    aliasName: 'tasks__id__materials__task_id',
  );

  $$MaterialsTableProcessedTableManager get materialsRefs {
    final manager = $$MaterialsTableTableManager(
      $_db,
      $_db.materials,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_materialsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskStatus, TaskStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get plannedDay => $composableBuilder(
    column: $table.plannedDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get important => $composableBuilder(
    column: $table.important,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimateMin => $composableBuilder(
    column: $table.estimateMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskSource?, TaskSource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get itflowTicketId => $composableBuilder(
    column: $table.itflowTicketId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get waitingFor => $composableBuilder(
    column: $table.waitingFor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get waitingSince => $composableBuilder(
    column: $table.waitingSince,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get followUpDate => $composableBuilder(
    column: $table.followUpDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MilestonesTableFilterComposer get milestoneId {
    final $$MilestonesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.milestoneId,
      referencedTable: $db.milestones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilestonesTableFilterComposer(
            $db: $db,
            $table: $db.milestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalsTableFilterComposer get goalId {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableFilterComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TemplatesTableFilterComposer get templateId {
    final $$TemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableFilterComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> checklistItemsRefs(
    Expression<bool> Function($$ChecklistItemsTableFilterComposer f) f,
  ) {
    final $$ChecklistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableFilterComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timeEntriesRefs(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> materialsRefs(
    Expression<bool> Function($$MaterialsTableFilterComposer f) f,
  ) {
    final $$MaterialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materials,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableFilterComposer(
            $db: $db,
            $table: $db.materials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plannedDay => $composableBuilder(
    column: $table.plannedDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get important => $composableBuilder(
    column: $table.important,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimateMin => $composableBuilder(
    column: $table.estimateMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itflowTicketId => $composableBuilder(
    column: $table.itflowTicketId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get waitingFor => $composableBuilder(
    column: $table.waitingFor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get waitingSince => $composableBuilder(
    column: $table.waitingSince,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get followUpDate => $composableBuilder(
    column: $table.followUpDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MilestonesTableOrderingComposer get milestoneId {
    final $$MilestonesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.milestoneId,
      referencedTable: $db.milestones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilestonesTableOrderingComposer(
            $db: $db,
            $table: $db.milestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalsTableOrderingComposer get goalId {
    final $$GoalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableOrderingComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TemplatesTableOrderingComposer get templateId {
    final $$TemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get plannedDay => $composableBuilder(
    column: $table.plannedDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<DateTime> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<bool> get important =>
      $composableBuilder(column: $table.important, builder: (column) => column);

  GeneratedColumn<int> get estimateMin => $composableBuilder(
    column: $table.estimateMin,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TaskSource?, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get itflowTicketId => $composableBuilder(
    column: $table.itflowTicketId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get waitingFor => $composableBuilder(
    column: $table.waitingFor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get waitingSince => $composableBuilder(
    column: $table.waitingSince,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get followUpDate => $composableBuilder(
    column: $table.followUpDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MilestonesTableAnnotationComposer get milestoneId {
    final $$MilestonesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.milestoneId,
      referencedTable: $db.milestones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilestonesTableAnnotationComposer(
            $db: $db,
            $table: $db.milestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalsTableAnnotationComposer get goalId {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TemplatesTableAnnotationComposer get templateId {
    final $$TemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> checklistItemsRefs<T extends Object>(
    Expression<T> Function($$ChecklistItemsTableAnnotationComposer a) f,
  ) {
    final $$ChecklistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timeEntriesRefs<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> materialsRefs<T extends Object>(
    Expression<T> Function($$MaterialsTableAnnotationComposer a) f,
  ) {
    final $$MaterialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materials,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableAnnotationComposer(
            $db: $db,
            $table: $db.materials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, $$TasksTableReferences),
          Task,
          PrefetchHooks Function({
            bool customerId,
            bool projectId,
            bool milestoneId,
            bool goalId,
            bool templateId,
            bool checklistItemsRefs,
            bool timeEntriesRefs,
            bool materialsRefs,
          })
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<TaskStatus> status = const Value.absent(),
                Value<DateTime?> plannedDay = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<DateTime?> due = const Value.absent(),
                Value<bool> important = const Value.absent(),
                Value<int?> estimateMin = const Value.absent(),
                Value<TaskSource?> source = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<String?> milestoneId = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<String?> templateId = const Value.absent(),
                Value<int?> itflowTicketId = const Value.absent(),
                Value<String?> waitingFor = const Value.absent(),
                Value<DateTime?> waitingSince = const Value.absent(),
                Value<DateTime?> followUpDate = const Value.absent(),
                Value<String?> recurrence = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                title: title,
                status: status,
                plannedDay: plannedDay,
                order: order,
                due: due,
                important: important,
                estimateMin: estimateMin,
                source: source,
                customerId: customerId,
                projectId: projectId,
                milestoneId: milestoneId,
                goalId: goalId,
                templateId: templateId,
                itflowTicketId: itflowTicketId,
                waitingFor: waitingFor,
                waitingSince: waitingSince,
                followUpDate: followUpDate,
                recurrence: recurrence,
                tags: tags,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String title,
                Value<TaskStatus> status = const Value.absent(),
                Value<DateTime?> plannedDay = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<DateTime?> due = const Value.absent(),
                Value<bool> important = const Value.absent(),
                Value<int?> estimateMin = const Value.absent(),
                Value<TaskSource?> source = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<String?> milestoneId = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<String?> templateId = const Value.absent(),
                Value<int?> itflowTicketId = const Value.absent(),
                Value<String?> waitingFor = const Value.absent(),
                Value<DateTime?> waitingSince = const Value.absent(),
                Value<DateTime?> followUpDate = const Value.absent(),
                Value<String?> recurrence = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                title: title,
                status: status,
                plannedDay: plannedDay,
                order: order,
                due: due,
                important: important,
                estimateMin: estimateMin,
                source: source,
                customerId: customerId,
                projectId: projectId,
                milestoneId: milestoneId,
                goalId: goalId,
                templateId: templateId,
                itflowTicketId: itflowTicketId,
                waitingFor: waitingFor,
                waitingSince: waitingSince,
                followUpDate: followUpDate,
                recurrence: recurrence,
                tags: tags,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TasksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                projectId = false,
                milestoneId = false,
                goalId = false,
                templateId = false,
                checklistItemsRefs = false,
                timeEntriesRefs = false,
                materialsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (checklistItemsRefs) db.checklistItems,
                    if (timeEntriesRefs) db.timeEntries,
                    if (materialsRefs) db.materials,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.customerId,
                            referencedTable: $$TasksTableReferences
                                ._customerIdTable(db),
                            referencedColumn: $$TasksTableReferences
                                ._customerIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (projectId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.projectId,
                            referencedTable: $$TasksTableReferences
                                ._projectIdTable(db),
                            referencedColumn: $$TasksTableReferences
                                ._projectIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (milestoneId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.milestoneId,
                            referencedTable: $$TasksTableReferences
                                ._milestoneIdTable(db),
                            referencedColumn: $$TasksTableReferences
                                ._milestoneIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (goalId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.goalId,
                            referencedTable: $$TasksTableReferences
                                ._goalIdTable(db),
                            referencedColumn: $$TasksTableReferences
                                ._goalIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (templateId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.templateId,
                            referencedTable: $$TasksTableReferences
                                ._templateIdTable(db),
                            referencedColumn: $$TasksTableReferences
                                ._templateIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (checklistItemsRefs)
                        await $_getPrefetchedData<
                          Task,
                          $TasksTable,
                          ChecklistItem
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._checklistItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).checklistItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (timeEntriesRefs)
                        await $_getPrefetchedData<Task, $TasksTable, TimeEntry>(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._timeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).timeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (materialsRefs)
                        await $_getPrefetchedData<
                          Task,
                          $TasksTable,
                          MaterialItem
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._materialsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).materialsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, $$TasksTableReferences),
      Task,
      PrefetchHooks Function({
        bool customerId,
        bool projectId,
        bool milestoneId,
        bool goalId,
        bool templateId,
        bool checklistItemsRefs,
        bool timeEntriesRefs,
        bool materialsRefs,
      })
    >;
typedef $$ChecklistItemsTableCreateCompanionBuilder =
    ChecklistItemsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String taskId,
      required String label,
      Value<int> order,
      Value<bool> required,
      Value<bool> done,
      Value<DateTime?> doneAt,
      Value<int> rowid,
    });
typedef $$ChecklistItemsTableUpdateCompanionBuilder =
    ChecklistItemsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> taskId,
      Value<String> label,
      Value<int> order,
      Value<bool> required,
      Value<bool> done,
      Value<DateTime?> doneAt,
      Value<int> rowid,
    });

final class $$ChecklistItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ChecklistItemsTable, ChecklistItem> {
  $$ChecklistItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('checklist_items__task_id__tasks__id');

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChecklistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get required => $composableBuilder(
    column: $table.required,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get required => $composableBuilder(
    column: $table.required,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<bool> get required =>
      $composableBuilder(column: $table.required, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<DateTime> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChecklistItemsTable,
          ChecklistItem,
          $$ChecklistItemsTableFilterComposer,
          $$ChecklistItemsTableOrderingComposer,
          $$ChecklistItemsTableAnnotationComposer,
          $$ChecklistItemsTableCreateCompanionBuilder,
          $$ChecklistItemsTableUpdateCompanionBuilder,
          (ChecklistItem, $$ChecklistItemsTableReferences),
          ChecklistItem,
          PrefetchHooks Function({bool taskId})
        > {
  $$ChecklistItemsTableTableManager(
    _$AppDatabase db,
    $ChecklistItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<bool> required = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistItemsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                taskId: taskId,
                label: label,
                order: order,
                required: required,
                done: done,
                doneAt: doneAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String taskId,
                required String label,
                Value<int> order = const Value.absent(),
                Value<bool> required = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistItemsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                taskId: taskId,
                label: label,
                order: order,
                required: required,
                done: done,
                doneAt: doneAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChecklistItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$ChecklistItemsTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$ChecklistItemsTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChecklistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChecklistItemsTable,
      ChecklistItem,
      $$ChecklistItemsTableFilterComposer,
      $$ChecklistItemsTableOrderingComposer,
      $$ChecklistItemsTableAnnotationComposer,
      $$ChecklistItemsTableCreateCompanionBuilder,
      $$ChecklistItemsTableUpdateCompanionBuilder,
      (ChecklistItem, $$ChecklistItemsTableReferences),
      ChecklistItem,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$TimeEntriesTableCreateCompanionBuilder =
    TimeEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required DateTime start,
      Value<DateTime?> end,
      Value<TimeEntryKind> kind,
      Value<String?> category,
      Value<String?> customerId,
      Value<String?> taskId,
      Value<String?> projectId,
      Value<String?> goalId,
      Value<bool> billable,
      Value<String?> note,
      Value<int?> ticketId,
      Value<bool> syncedToItflow,
      Value<int> rowid,
    });
typedef $$TimeEntriesTableUpdateCompanionBuilder =
    TimeEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> start,
      Value<DateTime?> end,
      Value<TimeEntryKind> kind,
      Value<String?> category,
      Value<String?> customerId,
      Value<String?> taskId,
      Value<String?> projectId,
      Value<String?> goalId,
      Value<bool> billable,
      Value<String?> note,
      Value<int?> ticketId,
      Value<bool> syncedToItflow,
      Value<int> rowid,
    });

final class $$TimeEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $TimeEntriesTable, TimeEntry> {
  $$TimeEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('time_entries__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<String>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('time_entries__task_id__tasks__id');

  $$TasksTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<String>('task_id');
    if ($_column == null) return null;
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('time_entries__project_id__projects__id');

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GoalsTable _goalIdTable(_$AppDatabase db) =>
      db.goals.createAlias('time_entries__goal_id__goals__id');

  $$GoalsTableProcessedTableManager? get goalId {
    final $_column = $_itemColumn<String>('goal_id');
    if ($_column == null) return null;
    final manager = $$GoalsTableTableManager(
      $_db,
      $_db.goals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TimeEntryColleaguesTable,
    List<TimeEntryColleague>
  >
  _timeEntryColleaguesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.timeEntryColleagues,
        aliasName: 'time_entries__id__time_entry_colleagues__time_entry_id',
      );

  $$TimeEntryColleaguesTableProcessedTableManager get timeEntryColleaguesRefs {
    final manager = $$TimeEntryColleaguesTableTableManager(
      $_db,
      $_db.timeEntryColleagues,
    ).filter((f) => f.timeEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _timeEntryColleaguesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TimeEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TimeEntryKind, TimeEntryKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get billable => $composableBuilder(
    column: $table.billable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ticketId => $composableBuilder(
    column: $table.ticketId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncedToItflow => $composableBuilder(
    column: $table.syncedToItflow,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalsTableFilterComposer get goalId {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableFilterComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> timeEntryColleaguesRefs(
    Expression<bool> Function($$TimeEntryColleaguesTableFilterComposer f) f,
  ) {
    final $$TimeEntryColleaguesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntryColleagues,
      getReferencedColumn: (t) => t.timeEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntryColleaguesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntryColleagues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TimeEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get billable => $composableBuilder(
    column: $table.billable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ticketId => $composableBuilder(
    column: $table.ticketId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncedToItflow => $composableBuilder(
    column: $table.syncedToItflow,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalsTableOrderingComposer get goalId {
    final $$GoalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableOrderingComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<DateTime> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TimeEntryKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get billable =>
      $composableBuilder(column: $table.billable, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get ticketId =>
      $composableBuilder(column: $table.ticketId, builder: (column) => column);

  GeneratedColumn<bool> get syncedToItflow => $composableBuilder(
    column: $table.syncedToItflow,
    builder: (column) => column,
  );

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalsTableAnnotationComposer get goalId {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> timeEntryColleaguesRefs<T extends Object>(
    Expression<T> Function($$TimeEntryColleaguesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntryColleaguesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.timeEntryColleagues,
          getReferencedColumn: (t) => t.timeEntryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TimeEntryColleaguesTableAnnotationComposer(
                $db: $db,
                $table: $db.timeEntryColleagues,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TimeEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimeEntriesTable,
          TimeEntry,
          $$TimeEntriesTableFilterComposer,
          $$TimeEntriesTableOrderingComposer,
          $$TimeEntriesTableAnnotationComposer,
          $$TimeEntriesTableCreateCompanionBuilder,
          $$TimeEntriesTableUpdateCompanionBuilder,
          (TimeEntry, $$TimeEntriesTableReferences),
          TimeEntry,
          PrefetchHooks Function({
            bool customerId,
            bool taskId,
            bool projectId,
            bool goalId,
            bool timeEntryColleaguesRefs,
          })
        > {
  $$TimeEntriesTableTableManager(_$AppDatabase db, $TimeEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimeEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> start = const Value.absent(),
                Value<DateTime?> end = const Value.absent(),
                Value<TimeEntryKind> kind = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<bool> billable = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> ticketId = const Value.absent(),
                Value<bool> syncedToItflow = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimeEntriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                start: start,
                end: end,
                kind: kind,
                category: category,
                customerId: customerId,
                taskId: taskId,
                projectId: projectId,
                goalId: goalId,
                billable: billable,
                note: note,
                ticketId: ticketId,
                syncedToItflow: syncedToItflow,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required DateTime start,
                Value<DateTime?> end = const Value.absent(),
                Value<TimeEntryKind> kind = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<bool> billable = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> ticketId = const Value.absent(),
                Value<bool> syncedToItflow = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimeEntriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                start: start,
                end: end,
                kind: kind,
                category: category,
                customerId: customerId,
                taskId: taskId,
                projectId: projectId,
                goalId: goalId,
                billable: billable,
                note: note,
                ticketId: ticketId,
                syncedToItflow: syncedToItflow,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimeEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                taskId = false,
                projectId = false,
                goalId = false,
                timeEntryColleaguesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (timeEntryColleaguesRefs) db.timeEntryColleagues,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.customerId,
                            referencedTable: $$TimeEntriesTableReferences
                                ._customerIdTable(db),
                            referencedColumn: $$TimeEntriesTableReferences
                                ._customerIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (taskId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.taskId,
                            referencedTable: $$TimeEntriesTableReferences
                                ._taskIdTable(db),
                            referencedColumn: $$TimeEntriesTableReferences
                                ._taskIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (projectId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.projectId,
                            referencedTable: $$TimeEntriesTableReferences
                                ._projectIdTable(db),
                            referencedColumn: $$TimeEntriesTableReferences
                                ._projectIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (goalId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.goalId,
                            referencedTable: $$TimeEntriesTableReferences
                                ._goalIdTable(db),
                            referencedColumn: $$TimeEntriesTableReferences
                                ._goalIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (timeEntryColleaguesRefs)
                        await $_getPrefetchedData<
                          TimeEntry,
                          $TimeEntriesTable,
                          TimeEntryColleague
                        >(
                          currentTable: table,
                          referencedTable: $$TimeEntriesTableReferences
                              ._timeEntryColleaguesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TimeEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).timeEntryColleaguesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.timeEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TimeEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimeEntriesTable,
      TimeEntry,
      $$TimeEntriesTableFilterComposer,
      $$TimeEntriesTableOrderingComposer,
      $$TimeEntriesTableAnnotationComposer,
      $$TimeEntriesTableCreateCompanionBuilder,
      $$TimeEntriesTableUpdateCompanionBuilder,
      (TimeEntry, $$TimeEntriesTableReferences),
      TimeEntry,
      PrefetchHooks Function({
        bool customerId,
        bool taskId,
        bool projectId,
        bool goalId,
        bool timeEntryColleaguesRefs,
      })
    >;
typedef $$TimeEntryColleaguesTableCreateCompanionBuilder =
    TimeEntryColleaguesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String timeEntryId,
      required String colleagueName,
      required int minutes,
      Value<int> rowid,
    });
typedef $$TimeEntryColleaguesTableUpdateCompanionBuilder =
    TimeEntryColleaguesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> timeEntryId,
      Value<String> colleagueName,
      Value<int> minutes,
      Value<int> rowid,
    });

final class $$TimeEntryColleaguesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TimeEntryColleaguesTable,
          TimeEntryColleague
        > {
  $$TimeEntryColleaguesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TimeEntriesTable _timeEntryIdTable(_$AppDatabase db) => db.timeEntries
      .createAlias('time_entry_colleagues__time_entry_id__time_entries__id');

  $$TimeEntriesTableProcessedTableManager get timeEntryId {
    final $_column = $_itemColumn<String>('time_entry_id')!;

    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_timeEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TimeEntryColleaguesTableFilterComposer
    extends Composer<_$AppDatabase, $TimeEntryColleaguesTable> {
  $$TimeEntryColleaguesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colleagueName => $composableBuilder(
    column: $table.colleagueName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  $$TimeEntriesTableFilterComposer get timeEntryId {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.timeEntryId,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeEntryColleaguesTableOrderingComposer
    extends Composer<_$AppDatabase, $TimeEntryColleaguesTable> {
  $$TimeEntryColleaguesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colleagueName => $composableBuilder(
    column: $table.colleagueName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  $$TimeEntriesTableOrderingComposer get timeEntryId {
    final $$TimeEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.timeEntryId,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeEntryColleaguesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimeEntryColleaguesTable> {
  $$TimeEntryColleaguesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get colleagueName => $composableBuilder(
    column: $table.colleagueName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  $$TimeEntriesTableAnnotationComposer get timeEntryId {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.timeEntryId,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeEntryColleaguesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimeEntryColleaguesTable,
          TimeEntryColleague,
          $$TimeEntryColleaguesTableFilterComposer,
          $$TimeEntryColleaguesTableOrderingComposer,
          $$TimeEntryColleaguesTableAnnotationComposer,
          $$TimeEntryColleaguesTableCreateCompanionBuilder,
          $$TimeEntryColleaguesTableUpdateCompanionBuilder,
          (TimeEntryColleague, $$TimeEntryColleaguesTableReferences),
          TimeEntryColleague,
          PrefetchHooks Function({bool timeEntryId})
        > {
  $$TimeEntryColleaguesTableTableManager(
    _$AppDatabase db,
    $TimeEntryColleaguesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeEntryColleaguesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeEntryColleaguesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TimeEntryColleaguesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> timeEntryId = const Value.absent(),
                Value<String> colleagueName = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimeEntryColleaguesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                timeEntryId: timeEntryId,
                colleagueName: colleagueName,
                minutes: minutes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String timeEntryId,
                required String colleagueName,
                required int minutes,
                Value<int> rowid = const Value.absent(),
              }) => TimeEntryColleaguesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                timeEntryId: timeEntryId,
                colleagueName: colleagueName,
                minutes: minutes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimeEntryColleaguesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({timeEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (timeEntryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.timeEntryId,
                        referencedTable: $$TimeEntryColleaguesTableReferences
                            ._timeEntryIdTable(db),
                        referencedColumn: $$TimeEntryColleaguesTableReferences
                            ._timeEntryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TimeEntryColleaguesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimeEntryColleaguesTable,
      TimeEntryColleague,
      $$TimeEntryColleaguesTableFilterComposer,
      $$TimeEntryColleaguesTableOrderingComposer,
      $$TimeEntryColleaguesTableAnnotationComposer,
      $$TimeEntryColleaguesTableCreateCompanionBuilder,
      $$TimeEntryColleaguesTableUpdateCompanionBuilder,
      (TimeEntryColleague, $$TimeEntryColleaguesTableReferences),
      TimeEntryColleague,
      PrefetchHooks Function({bool timeEntryId})
    >;
typedef $$WorkClocksTableCreateCompanionBuilder = WorkClocksCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required DateTime day,
  required DateTime start,
  Value<String?> pauses,
  Value<DateTime?> end,
  Value<int> rowid,
});
typedef $$WorkClocksTableUpdateCompanionBuilder = WorkClocksCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<DateTime> day,
  Value<DateTime> start,
  Value<String?> pauses,
  Value<DateTime?> end,
  Value<int> rowid,
});

class $$WorkClocksTableFilterComposer
    extends Composer<_$AppDatabase, $WorkClocksTable> {
  $$WorkClocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pauses => $composableBuilder(
    column: $table.pauses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkClocksTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkClocksTable> {
  $$WorkClocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pauses => $composableBuilder(
    column: $table.pauses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkClocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkClocksTable> {
  $$WorkClocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<String> get pauses =>
      $composableBuilder(column: $table.pauses, builder: (column) => column);

  GeneratedColumn<DateTime> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);
}

class $$WorkClocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkClocksTable,
          WorkClock,
          $$WorkClocksTableFilterComposer,
          $$WorkClocksTableOrderingComposer,
          $$WorkClocksTableAnnotationComposer,
          $$WorkClocksTableCreateCompanionBuilder,
          $$WorkClocksTableUpdateCompanionBuilder,
          (
            WorkClock,
            BaseReferences<_$AppDatabase, $WorkClocksTable, WorkClock>,
          ),
          WorkClock,
          PrefetchHooks Function()
        > {
  $$WorkClocksTableTableManager(_$AppDatabase db, $WorkClocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkClocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkClocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkClocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> day = const Value.absent(),
                Value<DateTime> start = const Value.absent(),
                Value<String?> pauses = const Value.absent(),
                Value<DateTime?> end = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkClocksCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                day: day,
                start: start,
                pauses: pauses,
                end: end,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required DateTime day,
                required DateTime start,
                Value<String?> pauses = const Value.absent(),
                Value<DateTime?> end = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkClocksCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                day: day,
                start: start,
                pauses: pauses,
                end: end,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkClocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkClocksTable,
      WorkClock,
      $$WorkClocksTableFilterComposer,
      $$WorkClocksTableOrderingComposer,
      $$WorkClocksTableAnnotationComposer,
      $$WorkClocksTableCreateCompanionBuilder,
      $$WorkClocksTableUpdateCompanionBuilder,
      (WorkClock, BaseReferences<_$AppDatabase, $WorkClocksTable, WorkClock>),
      WorkClock,
      PrefetchHooks Function()
    >;
typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required NoteParentType parentType,
  required String parentId,
  Value<NoteType> type,
  Value<String?> body,
  Value<String?> mediaPath,
  Value<String?> transcript,
  Value<bool> isSolution,
  Value<int> rowid,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<NoteParentType> parentType,
  Value<String> parentId,
  Value<NoteType> type,
  Value<String?> body,
  Value<String?> mediaPath,
  Value<String?> transcript,
  Value<bool> isSolution,
  Value<int> rowid,
});

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<NoteParentType, NoteParentType, String>
  get parentType => $composableBuilder(
    column: $table.parentType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<NoteType, NoteType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaPath => $composableBuilder(
    column: $table.mediaPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transcript => $composableBuilder(
    column: $table.transcript,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSolution => $composableBuilder(
    column: $table.isSolution,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentType => $composableBuilder(
    column: $table.parentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaPath => $composableBuilder(
    column: $table.mediaPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transcript => $composableBuilder(
    column: $table.transcript,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSolution => $composableBuilder(
    column: $table.isSolution,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NoteParentType, String> get parentType =>
      $composableBuilder(
        column: $table.parentType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NoteType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get mediaPath =>
      $composableBuilder(column: $table.mediaPath, builder: (column) => column);

  GeneratedColumn<String> get transcript => $composableBuilder(
    column: $table.transcript,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSolution => $composableBuilder(
    column: $table.isSolution,
    builder: (column) => column,
  );
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
          Note,
          PrefetchHooks Function()
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<NoteParentType> parentType = const Value.absent(),
                Value<String> parentId = const Value.absent(),
                Value<NoteType> type = const Value.absent(),
                Value<String?> body = const Value.absent(),
                Value<String?> mediaPath = const Value.absent(),
                Value<String?> transcript = const Value.absent(),
                Value<bool> isSolution = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                parentType: parentType,
                parentId: parentId,
                type: type,
                body: body,
                mediaPath: mediaPath,
                transcript: transcript,
                isSolution: isSolution,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required NoteParentType parentType,
                required String parentId,
                Value<NoteType> type = const Value.absent(),
                Value<String?> body = const Value.absent(),
                Value<String?> mediaPath = const Value.absent(),
                Value<String?> transcript = const Value.absent(),
                Value<bool> isSolution = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                parentType: parentType,
                parentId: parentId,
                type: type,
                body: body,
                mediaPath: mediaPath,
                transcript: transcript,
                isSolution: isSolution,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
      Note,
      PrefetchHooks Function()
    >;
typedef $$MaterialsTableCreateCompanionBuilder = MaterialsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String taskId,
  Value<int> quantity,
  Value<String?> ean,
  Value<String?> name,
  Value<String?> photoPath,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$MaterialsTableUpdateCompanionBuilder = MaterialsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> taskId,
  Value<int> quantity,
  Value<String?> ean,
  Value<String?> name,
  Value<String?> photoPath,
  Value<String?> note,
  Value<int> rowid,
});

final class $$MaterialsTableReferences
    extends BaseReferences<_$AppDatabase, $MaterialsTable, MaterialItem> {
  $$MaterialsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('materials__task_id__tasks__id');

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MaterialsTableFilterComposer
    extends Composer<_$AppDatabase, $MaterialsTable> {
  $$MaterialsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ean => $composableBuilder(
    column: $table.ean,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaterialsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaterialsTable> {
  $$MaterialsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ean => $composableBuilder(
    column: $table.ean,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaterialsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaterialsTable> {
  $$MaterialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get ean =>
      $composableBuilder(column: $table.ean, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaterialsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaterialsTable,
          MaterialItem,
          $$MaterialsTableFilterComposer,
          $$MaterialsTableOrderingComposer,
          $$MaterialsTableAnnotationComposer,
          $$MaterialsTableCreateCompanionBuilder,
          $$MaterialsTableUpdateCompanionBuilder,
          (MaterialItem, $$MaterialsTableReferences),
          MaterialItem,
          PrefetchHooks Function({bool taskId})
        > {
  $$MaterialsTableTableManager(_$AppDatabase db, $MaterialsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaterialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaterialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaterialsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> ean = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaterialsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                taskId: taskId,
                quantity: quantity,
                ean: ean,
                name: name,
                photoPath: photoPath,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String taskId,
                Value<int> quantity = const Value.absent(),
                Value<String?> ean = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaterialsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                taskId: taskId,
                quantity: quantity,
                ean: ean,
                name: name,
                photoPath: photoPath,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MaterialsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$MaterialsTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$MaterialsTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MaterialsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaterialsTable,
      MaterialItem,
      $$MaterialsTableFilterComposer,
      $$MaterialsTableOrderingComposer,
      $$MaterialsTableAnnotationComposer,
      $$MaterialsTableCreateCompanionBuilder,
      $$MaterialsTableUpdateCompanionBuilder,
      (MaterialItem, $$MaterialsTableReferences),
      MaterialItem,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$CheckRoundsTableCreateCompanionBuilder =
    CheckRoundsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String name,
      required int weekday,
      Value<String?> templateId,
      Value<int> rowid,
    });
typedef $$CheckRoundsTableUpdateCompanionBuilder =
    CheckRoundsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> name,
      Value<int> weekday,
      Value<String?> templateId,
      Value<int> rowid,
    });

final class $$CheckRoundsTableReferences
    extends BaseReferences<_$AppDatabase, $CheckRoundsTable, CheckRound> {
  $$CheckRoundsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.templates.createAlias('check_rounds__template_id__templates__id');

  $$TemplatesTableProcessedTableManager? get templateId {
    final $_column = $_itemColumn<String>('template_id');
    if ($_column == null) return null;
    final manager = $$TemplatesTableTableManager(
      $_db,
      $_db.templates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CheckRoundResultsTable, List<CheckRoundResult>>
  _checkRoundResultsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.checkRoundResults,
        aliasName: 'check_rounds__id__check_round_results__check_round_id',
      );

  $$CheckRoundResultsTableProcessedTableManager get checkRoundResultsRefs {
    final manager = $$CheckRoundResultsTableTableManager(
      $_db,
      $_db.checkRoundResults,
    ).filter((f) => f.checkRoundId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _checkRoundResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CheckRoundsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckRoundsTable> {
  $$CheckRoundsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  $$TemplatesTableFilterComposer get templateId {
    final $$TemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableFilterComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> checkRoundResultsRefs(
    Expression<bool> Function($$CheckRoundResultsTableFilterComposer f) f,
  ) {
    final $$CheckRoundResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checkRoundResults,
      getReferencedColumn: (t) => t.checkRoundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckRoundResultsTableFilterComposer(
            $db: $db,
            $table: $db.checkRoundResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CheckRoundsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckRoundsTable> {
  $$CheckRoundsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  $$TemplatesTableOrderingComposer get templateId {
    final $$TemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CheckRoundsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckRoundsTable> {
  $$CheckRoundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  $$TemplatesTableAnnotationComposer get templateId {
    final $$TemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> checkRoundResultsRefs<T extends Object>(
    Expression<T> Function($$CheckRoundResultsTableAnnotationComposer a) f,
  ) {
    final $$CheckRoundResultsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.checkRoundResults,
          getReferencedColumn: (t) => t.checkRoundId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CheckRoundResultsTableAnnotationComposer(
                $db: $db,
                $table: $db.checkRoundResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CheckRoundsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckRoundsTable,
          CheckRound,
          $$CheckRoundsTableFilterComposer,
          $$CheckRoundsTableOrderingComposer,
          $$CheckRoundsTableAnnotationComposer,
          $$CheckRoundsTableCreateCompanionBuilder,
          $$CheckRoundsTableUpdateCompanionBuilder,
          (CheckRound, $$CheckRoundsTableReferences),
          CheckRound,
          PrefetchHooks Function({bool templateId, bool checkRoundResultsRefs})
        > {
  $$CheckRoundsTableTableManager(_$AppDatabase db, $CheckRoundsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckRoundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckRoundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckRoundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<String?> templateId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckRoundsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                weekday: weekday,
                templateId: templateId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                required int weekday,
                Value<String?> templateId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckRoundsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                weekday: weekday,
                templateId: templateId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CheckRoundsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({templateId = false, checkRoundResultsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (checkRoundResultsRefs) db.checkRoundResults,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (templateId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.templateId,
                            referencedTable: $$CheckRoundsTableReferences
                                ._templateIdTable(db),
                            referencedColumn: $$CheckRoundsTableReferences
                                ._templateIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (checkRoundResultsRefs)
                        await $_getPrefetchedData<
                          CheckRound,
                          $CheckRoundsTable,
                          CheckRoundResult
                        >(
                          currentTable: table,
                          referencedTable: $$CheckRoundsTableReferences
                              ._checkRoundResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CheckRoundsTableReferences(
                                db,
                                table,
                                p0,
                              ).checkRoundResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.checkRoundId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CheckRoundsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckRoundsTable,
      CheckRound,
      $$CheckRoundsTableFilterComposer,
      $$CheckRoundsTableOrderingComposer,
      $$CheckRoundsTableAnnotationComposer,
      $$CheckRoundsTableCreateCompanionBuilder,
      $$CheckRoundsTableUpdateCompanionBuilder,
      (CheckRound, $$CheckRoundsTableReferences),
      CheckRound,
      PrefetchHooks Function({bool templateId, bool checkRoundResultsRefs})
    >;
typedef $$CheckRoundResultsTableCreateCompanionBuilder =
    CheckRoundResultsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String checkRoundId,
      required String customerId,
      required CheckResult result,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$CheckRoundResultsTableUpdateCompanionBuilder =
    CheckRoundResultsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> checkRoundId,
      Value<String> customerId,
      Value<CheckResult> result,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$CheckRoundResultsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CheckRoundResultsTable,
          CheckRoundResult
        > {
  $$CheckRoundResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CheckRoundsTable _checkRoundIdTable(_$AppDatabase db) => db
      .checkRounds
      .createAlias('check_round_results__check_round_id__check_rounds__id');

  $$CheckRoundsTableProcessedTableManager get checkRoundId {
    final $_column = $_itemColumn<String>('check_round_id')!;

    final manager = $$CheckRoundsTableTableManager(
      $_db,
      $_db.checkRounds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_checkRoundIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CustomersTable _customerIdTable(_$AppDatabase db) => db.customers
      .createAlias('check_round_results__customer_id__customers__id');

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<String>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CheckRoundResultsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckRoundResultsTable> {
  $$CheckRoundResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CheckResult, CheckResult, String> get result =>
      $composableBuilder(
        column: $table.result,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$CheckRoundsTableFilterComposer get checkRoundId {
    final $$CheckRoundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkRoundId,
      referencedTable: $db.checkRounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckRoundsTableFilterComposer(
            $db: $db,
            $table: $db.checkRounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CheckRoundResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckRoundResultsTable> {
  $$CheckRoundResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$CheckRoundsTableOrderingComposer get checkRoundId {
    final $$CheckRoundsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkRoundId,
      referencedTable: $db.checkRounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckRoundsTableOrderingComposer(
            $db: $db,
            $table: $db.checkRounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CheckRoundResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckRoundResultsTable> {
  $$CheckRoundResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CheckResult, String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$CheckRoundsTableAnnotationComposer get checkRoundId {
    final $$CheckRoundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkRoundId,
      referencedTable: $db.checkRounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckRoundsTableAnnotationComposer(
            $db: $db,
            $table: $db.checkRounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CheckRoundResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckRoundResultsTable,
          CheckRoundResult,
          $$CheckRoundResultsTableFilterComposer,
          $$CheckRoundResultsTableOrderingComposer,
          $$CheckRoundResultsTableAnnotationComposer,
          $$CheckRoundResultsTableCreateCompanionBuilder,
          $$CheckRoundResultsTableUpdateCompanionBuilder,
          (CheckRoundResult, $$CheckRoundResultsTableReferences),
          CheckRoundResult,
          PrefetchHooks Function({bool checkRoundId, bool customerId})
        > {
  $$CheckRoundResultsTableTableManager(
    _$AppDatabase db,
    $CheckRoundResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckRoundResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckRoundResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckRoundResultsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> checkRoundId = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<CheckResult> result = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckRoundResultsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                checkRoundId: checkRoundId,
                customerId: customerId,
                result: result,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String checkRoundId,
                required String customerId,
                required CheckResult result,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckRoundResultsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                checkRoundId: checkRoundId,
                customerId: customerId,
                result: result,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CheckRoundResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({checkRoundId = false, customerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (checkRoundId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.checkRoundId,
                        referencedTable: $$CheckRoundResultsTableReferences
                            ._checkRoundIdTable(db),
                        referencedColumn: $$CheckRoundResultsTableReferences
                            ._checkRoundIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (customerId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.customerId,
                        referencedTable: $$CheckRoundResultsTableReferences
                            ._customerIdTable(db),
                        referencedColumn: $$CheckRoundResultsTableReferences
                            ._customerIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CheckRoundResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckRoundResultsTable,
      CheckRoundResult,
      $$CheckRoundResultsTableFilterComposer,
      $$CheckRoundResultsTableOrderingComposer,
      $$CheckRoundResultsTableAnnotationComposer,
      $$CheckRoundResultsTableCreateCompanionBuilder,
      $$CheckRoundResultsTableUpdateCompanionBuilder,
      (CheckRoundResult, $$CheckRoundResultsTableReferences),
      CheckRoundResult,
      PrefetchHooks Function({bool checkRoundId, bool customerId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$WorkspacesTableTableManager get workspaces =>
      $$WorkspacesTableTableManager(_db, _db.workspaces);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$ContactsTableTableManager get contacts =>
      $$ContactsTableTableManager(_db, _db.contacts);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$MilestonesTableTableManager get milestones =>
      $$MilestonesTableTableManager(_db, _db.milestones);
  $$CriteriaTableTableManager get criteria =>
      $$CriteriaTableTableManager(_db, _db.criteria);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$TemplatesTableTableManager get templates =>
      $$TemplatesTableTableManager(_db, _db.templates);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$ChecklistItemsTableTableManager get checklistItems =>
      $$ChecklistItemsTableTableManager(_db, _db.checklistItems);
  $$TimeEntriesTableTableManager get timeEntries =>
      $$TimeEntriesTableTableManager(_db, _db.timeEntries);
  $$TimeEntryColleaguesTableTableManager get timeEntryColleagues =>
      $$TimeEntryColleaguesTableTableManager(_db, _db.timeEntryColleagues);
  $$WorkClocksTableTableManager get workClocks =>
      $$WorkClocksTableTableManager(_db, _db.workClocks);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$MaterialsTableTableManager get materials =>
      $$MaterialsTableTableManager(_db, _db.materials);
  $$CheckRoundsTableTableManager get checkRounds =>
      $$CheckRoundsTableTableManager(_db, _db.checkRounds);
  $$CheckRoundResultsTableTableManager get checkRoundResults =>
      $$CheckRoundResultsTableTableManager(_db, _db.checkRoundResults);
}
